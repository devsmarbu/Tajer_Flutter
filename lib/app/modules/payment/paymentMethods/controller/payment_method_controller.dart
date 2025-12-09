import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/payment/paymentMethods/model/payment_methods_data.dart';
import 'package:tajer/app/modules/payment/payment_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/app_params.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../Extensions/alert.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/respository/cart_listing_repository.dart';
import '../../../Cart/cart_shipping/confirm_order_model.dart';
import '../../../Cart/payment_web_view/payment_web_view.dart';
import '../../../wallet/myWallet/models/payout_plugin.dart';

class PaymentMethodController extends GetxController
    with PaymentApiClient, AppLoader {

  final CartListingRepository _repository = CartListingRepository();

  Rx<PayoutPlugin?> selectedMethod = Rx<PayoutPlugin?>(null);
  Rx isWalletSelected = false.obs;
  RxString orderId = ''.obs;
  RxString orderType = ''.obs;
  RxString canUseWalletForPayment = ''.obs;
  RxString displayUserWalletBalance = ''.obs;
  RxString userWalletBalance = ''.obs;
  RxString orderNetAmount = ''.obs;
  RxString amount = ''.obs;

  /// Dynamic list from API
  RxList<PayoutPlugin> paymentMethods = <PayoutPlugin>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// 🔹 Get amount from route arguments
    amount.value = (Get.arguments?[AppParams.amount] ?? "").toString();
    orderType.value = (Get.arguments?[AppParams.orderType] ?? "").toString();


    /// 🔹 Call API automatically
    if(orderType.value.isNotEmpty){
      orderId.value = (Get.arguments?[AppParams.orderId] ?? "").toString();
      canUseWalletForPayment.value = (Get.arguments?[AppParams.canUseWalletForPayment] ?? "").toString();
      displayUserWalletBalance.value = (Get.arguments?[AppParams.displayUserWalletBalance] ?? "").toString();
      userWalletBalance.value = (Get.arguments?[AppParams.userWalletBalance] ?? "").toString();
      orderNetAmount.value = (Get.arguments?[AppParams.orderNetAmount] ?? "").toString();
      paymentMethods.value = (Get.arguments?[AppParams.paymentMethods] ?? []);


    }else{
      canUseWalletForPayment.value="0";
      if (amount.isNotEmpty) {
        setUpWalletRecharge();
      }
    }

  }

  Future<void> setUpWalletRecharge() async {
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection");
      return;
    }

    try {
      showLoader(Get.context!);
      final response = await setUpWalletRechargeApi(amount.value);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<PaymentMethodsData>.fromJson(
        body,
        fromJsonT: (jsonData) => PaymentMethodsData.fromJson(jsonData),
      );

      if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {

        /// 🔹 Update list from API
        paymentMethods.value = data.data?.paymentMethods ?? [];
        orderId.value=data.data?.orderId.toString()??"";
        orderType.value=data.data?.orderType.toString()??"";

      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong");
      }
    } catch (e) {
      AppDialog.showMessage("An error occurred. Please try again later.");
    } finally {
      hideLoader(Get.context!);
    }
  }

  void handleConfirmOrder() {
    final walletSelected = isWalletSelected.value;
    final userWalletBalanceNew = double.tryParse(userWalletBalance.value) ?? 0.0;
    final orderNetAmountNew = double.tryParse(orderNetAmount.value) ?? 0.0;



    // ---------- CASE 1: Wallet selected AND wallet balance is enough ----------
    if (walletSelected && userWalletBalanceNew >= orderNetAmountNew) {
      confirmOrder("0");   // 0 = wallet only
      return;
    }

    // ---------- CASE 2: Wallet selected BUT balance is NOT enough ----------
    else if (walletSelected && userWalletBalanceNew < orderNetAmountNew) {

      if (selectedMethod != null) {
        confirmOrder(selectedMethod.value!.pluginId);
        return;
      }

    }

    // ---------- CASE 3: Wallet NOT selected ----------
    else {

      if (selectedMethod != null) {
        confirmOrder(selectedMethod.value!.pluginId);
        return;
      }

    }
  }

  Future<void> confirmOrder(String pluginId) async {
    try {
      showLoader(Get.context!);

      debugPrint("🔵 calling API...");
      final response = await _repository.confirmOrder(
        orderId.value,
        orderType.value,
        pluginId,
      );

      hideLoader(Get.context!);

      // ⭐ FIX: response.data is already ConfirmOrderModel
      final ConfirmOrderModel? body = response;

      debugPrint("🟢 status = ${body?.status}");
      debugPrint("🟢 message = ${body?.msg}");
      debugPrint("🟢 orderPayment = ${body?.data?.orderPayment}");

      if (body?.status != "0") {
        // -------- Wallet payment logic ----------
        final orderNetAmountNew = orderNetAmount.value.toIntSafe();

        final walletBal =
            double.tryParse(displayUserWalletBalance.value) ?? 0.0;

        final orderAmt =
            double.tryParse(orderNetAmountNew.toString()) ?? 0.0;

        if (canUseWalletForPayment.value == "1" && walletBal > orderAmt) {
          debugPrint("🟣 paying from wallet");
          payFromWallet(orderId.value);
        } else {
          debugPrint("🟣 redirecting to payment page");
          final result = await Get.to(
                () => PaymentWebProcessPage(
              webUrl: body?.data?.orderPayment ?? "",
              orderId: orderId.value,
              isFromGift: false,
              tokenId: "",
              userId: "",
            ),
          );

          if (result != null && result["status"] == "success") {
            goToOrderSuccess(orderId: result["orderId"]);
          }
        }
      } else {
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: body?.msg ?? "",
        );
      }
    } catch (e, s) {
      debugPrint("❌ EXCEPTION: $e");
      debugPrint("❌ STACK: $s");
      AppDialog.showMessage("An error occurred. Please try again later.");
    } finally {
      hideLoader(Get.context!);
    }
  }

//pay from wallet
  Future<void> payFromWallet(String orderId) async {
    showLoader(Get.context!);
    try {
      final response = await _repository.payFromWallet(orderId);

      if (response?.status != "0") {
        hideLoader(Get.context!);
        goToOrderSuccess(orderId: orderId);
        debugPrint("✅ $response");
      } else {
        hideLoader(Get.context!);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      hideLoader(Get.context!);
      debugPrint("❌  fetch error: $e");
    }
  }

  Future<void> walletGiftSelection() async {
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection");
      return;
    }

    final walletValue=isWalletSelected.value==true?"1":"0";
    try {
      showLoader(Get.context!);
      final response = await walletGiftSelectionApi(walletValue,orderId.value);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<PaymentMethodsData>.fromJson(
        body,
        fromJsonT: (jsonData) => PaymentMethodsData.fromJson(jsonData),
      );

      if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {



      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
      AppDialog.showMessage("An error occurred. Please try again later.");
    } finally {
      hideLoader(Get.context!);
    }
  }

  void goToOrderSuccess({required String? orderId}) {
    Get.offAllNamed(AppRoutes.orderSuccess, arguments: {"orderId": orderId});
  }


}
