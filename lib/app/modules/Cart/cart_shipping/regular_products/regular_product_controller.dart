import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/data/events/app_analytics_service.dart';
import 'package:tajer/app/data/respository/cart_listing_repository.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/payment_summary_model/payment_summary_model.dart';
import 'package:tajer/app/modules/Cart/choose_payment/choose_payment_view.dart';
import 'package:tajer/common/widgets/app_dialog.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../authentication/login/login_screen.dart';
import '../../payment_web_view/payment_web_view.dart';
import '../cart_listing_model/cart_listing_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ComboProductWithSelectedShippingMethod {
  Map<String, String>? shippingMethod;
  List<Available>? availableItems;

  ComboProductWithSelectedShippingMethod({
    this.shippingMethod,
    this.availableItems,
  });
}

class RegularProductController extends GetxController with AppLoader {
  final CartListingRepository _repository = CartListingRepository();

  RxList<ComboProductWithSelectedShippingMethod> groupedCombo =
      <ComboProductWithSelectedShippingMethod>[].obs;
  var cartListingModel = Rxn<CartListingModel>();
  var paymentSummaryModel = Rxn<PaymentSummaryModel>();
  List<Token>? cardTokens;
  var isLoading = false.obs;
  var cartOrderId = "";
  var usedRewardPoints = "0";
  var isDeliverAllTogether = false.obs;
  RxString appliedCouponCode = "".obs;
  var pluginId = "";
  PaymentMethod? selectedPaymentMethod;
  SelectedPlugin? selectedPlugin;
  String cartTypee = "5";
  String orderType = "1";
  String isUseWalletPayment = "1";
  String userId = "";
  RxBool isAgreed = true.obs;
  RxBool isLoggedIn = true.obs;
  RxInt displayLoginForm = 0.obs;

  RxBool useWallet = false.obs;
  RxBool useCard = false.obs;
  RxBool isWalletLoading = false.obs;
  String? selectedMethod;
  RxString couponErrorMessage = "".obs;
  RxBool isCouponLoading = false.obs;

  @override
  void onInit() {
    resetVariables();
    super.onInit();
  }

  void goToOrderSuccess({required String? orderId}) {
    Get.offAllNamed(AppRoutes.orderSuccess, arguments: {"orderId": orderId});
  }

  Future<void> getCartListing(
    String isDeliverAllTogether,
    String cartType,
  ) async {
    cartTypee = cartType;
   // isLoading(true);
    showLoader(Get.context!);
    try {
      final response = await _repository.getCartListingData(
        cartType: cartType,
        isDeliverAllTogether: isDeliverAllTogether,
      );
      isLoading(false);
      hideLoader(Get.context!);
      if (response != null) {
        print("✅ $response");
        debugPrint('this is cart lising page ${PrefStore().loadString(AppConstants.sessionId)}');
        cartListingModel.value = response;
        if (response.data?.cartItemsCount != null) {
          cartItemCounts.value = response.data?.cartItemsCount ?? "0";
          debugPrint("this is cart item value :- ${cartItemCounts.value}");
        }
        userId =
            cartListingModel
                .value
                ?.data
                ?.cartSelectedShippingAddress
                ?.addrRecordId ??
            "";
        final available = response.data?.products?.available ?? [];
        debugPrint("--------------${available.length}--------------");
        debugPrint(
          "--------------${response.data?.rates?.rates?.length ?? 0}--------------",
        );
        final groupedCombos = groupAvailableProductsByRates(
          available,
          response.data?.rates,
        );
        groupedCombo.assignAll(groupedCombos);
        if (cartListingModel.value?.data?.products?.available?.isNotEmpty ==
            true) {
          getpaymentSummary(payFromWallet: "1");
        }
        final products = cartListingModel.value?.data?.products;
        final totalAmount =
        (cartListingModel.value?.data?.products?.available ?? [])
            .fold<double>(
          0.0,
              (sum, item) =>
          sum +
              ((double.tryParse(item.selprodPrice ?? '0') ?? 0.0) *
                  item.quantity.toIntSafe()),
        );
        AppAnalyticsService.viewCart(currency: PrefStore().loadString(AppConstants.currencySymbol) ?? '\$', totalValue: totalAmount, items: products?.available);
      }
    } catch (e) {
      //isLoading(false);
      hideLoader(Get.context!);
      print("❌ cart listing fetch error: $e");
    }
  }

  Future<void> getpaymentSummary({
    String? redeemPoints,
    String? orderId,
    String? payFromWallet,
  }) async {
    try {
      final mutableShippingMethods = <String, String>{};

      for (var combo in groupedCombo) {
        if (combo.shippingMethod != null) {
          mutableShippingMethods.addAll(combo.shippingMethod!);
        }
      }

      final response = await _repository.getPaymentSummary(
        orderId: orderId ?? "",
        redeemPoints: redeemPoints ?? "",
        fulfilmentType: "2",
        payFromWallet: payFromWallet ?? "1",
        shippingMethods: mutableShippingMethods,
      );
      if (response?.status == "1") {
        debugPrint('this is payment summary api ${PrefStore().loadString(AppConstants.sessionId)}');

        cartListingModel.value?.data?.cartSummary?.cartRewardPoints =
            redeemPoints;

        if (paymentSummaryModel
                .value
                ?.data
                ?.cartSummary
                ?.cartRewardPoints
                ?.isNotEmpty ==
            true) {
          usedRewardPoints =
              paymentSummaryModel.value?.data?.cartSummary?.cartRewardPoints ??
              "";
          debugPrint("used reward pointyttttt $usedRewardPoints");
        } else if (redeemPoints?.isNotEmpty == true && redeemPoints != "0") {
          cartListingModel.value?.data?.cartSummary?.cartRewardPoints =
              redeemPoints;
          usedRewardPoints = redeemPoints ?? "0";
        }

        debugPrint(
          "here is reward points applied value:- ${cartListingModel.value?.data?.cartSummary?.cartRewardPoints}",
        );
        paymentSummaryModel.value = response;

        if ((paymentSummaryModel.value?.data?.orderId?.isNotEmpty == true) &&
            (paymentSummaryModel.value?.data?.orderId != "")) {
          cartOrderId = paymentSummaryModel.value?.data?.orderId ?? "";
        }
        debugPrint("reeeeeeeedeeeeeemmm$redeemPoints");
        debugPrint("reeeeeeeedeeeeeemmm$usedRewardPoints");
        // if (redeemPoints?.isNotEmpty == true && redeemPoints != "0") {
        //   usedRewardPoints = redeemPoints ?? "0";
        //   debugPrint("this is redeemed points$usedRewardPoints");
        // }

        if (paymentSummaryModel.value?.data?.paymentMethods?.isNotEmpty ==
            true) {
          final selectedPlugin = paymentSummaryModel.value?.data?.paymentMethods
              ?.firstWhereOrNull((m) => m.pluginId == "56");
          cardTokens = selectedPlugin?.tokens;
          selectedPaymentMethod = selectedPlugin;
        }
        orderType = paymentSummaryModel.value?.data?.orderType ?? "1";
        // isLoading(false);
        isUseWalletPayment = payFromWallet ?? "0";
        debugPrint("-------------------$payFromWallet");
      } else {
        debugPrint('this is payment summary api ${PrefStore().loadString(AppConstants.sessionId)}');
       // isLoading(false);
        hideLoader(Get.context!);
        paymentSummaryModel.value = response;
        if (response?.displayLoginForm == 1) {

          displayLoginForm.value = 1;
          isLoggedIn.value = false;

          Get.bottomSheet(
            LoginScreen(isEmail: true, isBottomSheet: true),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        } else {
          showAlertMessage(
            Get.context!,
            title: AppLabels.APP_NAME,
            message: response?.msg ?? "Something went wrong.",
          );
        }
      }
    } catch (e) {
      print("❌ payment summary fetch error: $e");
    }
  }

  //
  Future<void> removeReward({String? orderId}) async {
    try {
      final response = await _repository.removeRewardPoints(
        orderId: orderId ?? "",
      );
      if (response?.status == "1") {
        usedRewardPoints = "0";
        debugPrint("after remove reward points apllied");
        cartListingModel.value?.data?.cartSummary?.cartRewardPoints = "";
        debugPrint(
          "here is reward points applied value:- ${cartListingModel.value?.data?.cartSummary?.cartRewardPoints}",
        );
        paymentSummaryModel.value = response;
        isLoading(false);
        print("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: AppLabels.APP_NAME,
          message: response?.msg ?? "Something went wrong.",
        );
      }
    } catch (e) {
      print("❌ payment summary fetch error: $e");
    }
  }

  Future<void> saveForLaterProduct(String selProductId) async {
    isLoading(true);
    try {
      final response = await _repository.saveForLaterProduct(
        fulfilmentType: "2",
        selproductId: selProductId,
      );
      if (response != null) {
        getCartListing(
          isDeliverAllTogether.value == true ? "1" : "0",
          cartTypee,
        );
        print("✅ $response");
        // paymentSummaryModel.value = response;
      }
    } catch (e) {
      isLoading(false);
      print("❌ cart listing fetch error: $e");
    }
  }

  Future<void> moveItemToCart(String selProductId, String quantity,{String isRemovingSaveForLater = ''}) async {
    isLoading(true);
    try {
      final response = await _repository.moveItemToCart(
        selproductId: selProductId,
        quantity: quantity,
      );
      if (response?.status == "1") {
        if (isRemovingSaveForLater == '') {
          getCartListing(
          isDeliverAllTogether.value == true ? "1" : "0",
          cartTypee,
        );
        }else {
          isLoading(false);
        }
        print("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: AppLabels.APP_NAME,
          message: response?.msg ?? "Something went wrong.",
        );
      }
    } catch (e) {
      isLoading(false);
      print("❌ cart listing fetch error: $e");
    }
  }

  Future<bool> productQuantityUpdate(String key, String quantity) async {
    //isLoading(true);
    showLoader(Get.context!);
    try {
      final response = await _repository.updateCartQuantity(
        key: key,
        quantity: quantity,
      );
      if (response?.status != "0") {
        await getCartListing(
          isDeliverAllTogether.value == true ? "1" : "0",
          cartTypee,
        );
        print("✅ $response");
        return true;
      } else {
        //isLoading(false);
        hideLoader(Get.context!);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
        return false;
      }
    } catch (e) {
     // isLoading(false);
      hideLoader(Get.context!);
      print("❌ cart listing fetch error: $e");
      return false;
    }
  }

  Future<void> deleteCartItem(String key, String fulfilmentType,Available item) async {
    isLoading(true);
    try {
      final response = await _repository.deleteCartItem(
        key: key,
        fulfilmentType: fulfilmentType,
      );
      if (response?.status != "0") {
        AppAnalyticsService.removeFromCart(productId: key, name: item.productName??'', value: double.tryParse(item.total ?? '0')??0);
        getCartListing(
          isDeliverAllTogether.value == true ? "1" : "0",
          cartTypee,
        );
        print("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      isLoading(false);
      print("❌ delete cart item fetch error: $e");
    }
  }

  Future<void> applyCouponCode(String couponCode, String fulfilmentType) async {
    isCouponLoading(true);
    try {
      final response = await _repository.applyCouponCode(
        couponCode: couponCode,
        fulfilmentType: fulfilmentType,
      );
      if (response?.status != "0") {
        isCouponLoading(false);
        appliedCouponCode.value = couponCode;
        couponErrorMessage.value = "";
        getpaymentSummary();
        debugPrint("✅ $response");
      } else {
        isCouponLoading(false);
        // showAlertMessage(
        //   Get.context!,
        //   title: "Error",
        //   message: response?.msg ?? "",
        // );
        couponErrorMessage.value = response?.msg ?? '';
      }
    } catch (e) {
      isCouponLoading(false);
      debugPrint("❌  fetch error: $e");
    }
  }

  Future<void> removeCoupon(String fulfilmentType) async {
    // isLoading(true);
    try {
      final response = await _repository.removeCoupon(
        fulfilmentType: fulfilmentType,
      );
      if (response?.status != "0") {
        // isLoading(false);
        appliedCouponCode.value = "";
        couponErrorMessage.value = "";
        getpaymentSummary();
        debugPrint("✅ $response");
      } else {
        // isLoading(false);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      // isLoading(false);
      debugPrint("❌  fetch error: $e");
    }
  }

  Future<void> removeCardItem(String fulfilmentType, String tokenId) async {
    isLoading(true);
    try {
      final response = await _repository.removeCardItem(
        fulfilmentType: fulfilmentType,
        tokenId: tokenId,
      );

      if (response?.status.toString() != "0") {
        debugPrint("✅ Card deleted successfully");

        /// 🔥 IMPORTANT: Refresh payment summary
        await getpaymentSummary(
          redeemPoints: usedRewardPoints,
          orderId: cartOrderId,
          payFromWallet: isUseWalletPayment,
        );

      } else {
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      debugPrint("❌ remove card error: $e");
    } finally {
      isLoading(false);
    }
  }

  //confirm order
  Future<void> confirmOrder(
    String orderId,
    String orderType,
    String pluginId,
    int walletBalance,
    String usingWalletBalance,
  ) async {
    isLoading(true);
    try {
      final response = await _repository.confirmOrder(
        orderId,
        orderType,
        pluginId,
      );
      if (response?.status != "0") {
        debugPrint("✅ $response");
        final orderNetAmount =
            paymentSummaryModel.value?.data?.orderNetAmount.toIntSafe() ?? 0;
        if ((isUseWalletPayment == "1") && (walletBalance >= orderNetAmount)) {
          debugPrint("here is pay from wallet");
          payFromWallet(orderId);
        } else if (selectedPlugin != null) {
          debugPrint(selectedPlugin?.pluginCode ?? '');
          final result = await Get.to(
            () => PaymentWebProcessPage(
              webUrl: response?.data?.orderPayment ?? "",
              orderId: orderId,
              isFromGift: false,
              tokenId: selectedPlugin?.token.token ?? "",
              userId: userId,
            ),
          );
          if (result != null) {
            final status = result["status"];
            final orderId = result["orderId"];
            debugPrint("-------------------");
            debugPrint(status);
            debugPrint(orderId);
            debugPrint("-------------------");
            if (status == "back") {

              resetVariables();

              getCartListing(
                isDeliverAllTogether.value == true ? "1" : "0",
                cartTypee,
              );
            } else if (status == "success") {
              goToOrderSuccess(orderId: orderId);
            }
          }
        }
        else{
          debugPrint("sfbsfbsbfsdfvs......jsbfbsfs");
        }
      } else {
        if (response?.isCouponInvalid == "1") {
          isLoading(false);
          showAlertMessage(
            Get.context!,
            title: "Error",
            message: response?.msg ?? "",
            onOk: () {
              debugPrint('calling api');
              resetVariables();
              getCartListing(
                isDeliverAllTogether.value == true ? "1" : "0",
                cartTypee,
              );
            },
          );
        } else {
          isLoading(false);
          showAlertMessage(
            Get.context!,
            title: "Error",
            message: response?.msg ?? "",
          );
        }
      }
    } catch (e) {
      isLoading(false);
      debugPrint("❌  fetch error: $e");
    }
  }

  //pay from wallet
  Future<void> payFromWallet(String orderId) async {
    isLoading(true);
    try {
      final response = await _repository.payFromWallet(orderId);

      if (response?.status != "0") {
        isLoading(false);
        goToOrderSuccess(orderId: orderId);
        debugPrint("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      isLoading(false);
      debugPrint("❌  fetch error: $e");
    }
  }

  Future<void> addRemoveSaveForLaterItem(
    String fulfilmentType,
    String selProductId,
    String wishListId,
    String rowAction,
    String key,
    bool removeItem,
      Available item
  ) async {
    isLoading(true);
    try {
      final response = await _repository.addRemoveItemSaveFromLater(
        fulfilmentType: fulfilmentType,
        selProductId: selProductId,
        wishListId: wishListId,
        rowAction: rowAction,
      );
      if (response?.status != "0") {
        if (removeItem == true) {
          deleteCartItem(key, fulfilmentType,item);
        } else {
          getCartListing(
            isDeliverAllTogether.value == true ? "1" : "0",
            cartTypee,
          );
        }
        print("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      isLoading(false);
      print("❌ add/remove save for later cart item fetch error: $e");
    }
  }

  List<ComboProductWithSelectedShippingMethod> groupAvailableProductsByRates(
    List<Available> availableProducts,
    ShippingRatesResponse? ratesMap,
  ) {
    List<ComboProductWithSelectedShippingMethod> grouped = [];

    ratesMap?.rates?.forEach((shippingCode, rateModel) {
      final ids = shippingCode.split("_");

      final comboProducts = availableProducts.where((product) {
        return ids.contains(product.selprodId);
      }).toList();

      // SAFE shipping method
      final serviceCode =
          (rateModel.shippingMethods != null &&
              rateModel.shippingMethods!.isNotEmpty)
          ? rateModel.shippingMethods!.first.serviceCode ?? ""
          : "";

      grouped.add(
        ComboProductWithSelectedShippingMethod(
          availableItems: comboProducts,
          shippingMethod: {"shipping_services[$shippingCode]": serviceCode},
        ),
      );
    });

    return grouped;
  }

  getRatesForCombo(String shippingCode, ShippingRatesResponse? ratesMap) {
    return ratesMap?.rates?[shippingCode];
  }

  bool get isWalletSufficient {
    final wallet = paymentSummaryModel.value?.data?.userWalletBalance.toIntSafe() ?? 0;
    final total = paymentSummaryModel.value?.data?.orderNetAmount.toIntSafe() ?? 0;
    return wallet >= total;
  }

  void resetVariables(){
    useWallet.value = false;
    useCard.value = false;
    isWalletLoading.value = false;
    couponErrorMessage.value = "";
    isCouponLoading.value = false;
    appliedCouponCode.value = "";
  }


}
