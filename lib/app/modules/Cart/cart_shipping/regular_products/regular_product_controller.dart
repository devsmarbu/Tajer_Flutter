import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/data/respository/cart_listing_repository.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/payment_summary_model/payment_summary_model.dart';
import 'package:tajer/app/modules/Cart/choose_payment/choose_payment_view.dart';
import 'package:tajer/utils/pref_store.dart';
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

class RegularProductController extends GetxController {
  final CartListingRepository _repository = CartListingRepository();

  RxList<ComboProductWithSelectedShippingMethod> groupedCombo =
      <ComboProductWithSelectedShippingMethod>[].obs;
  var cartListingModel = Rxn<CartListingModel>();
  var paymentSummaryModel = Rxn<PaymentSummaryModel>();
  List<Token>? cardTokens;
  var isLoading = true.obs;
  var cartOrderId = "";
  var usedRewardPoints = "";
  var isDeliverAllTogether = false.obs;
  var appliedCouponCode = "";
  var pluginId = "";
  PaymentMethod? selectedPaymentMethod;
  SelectedPlugin? selectedPlugin;
  String cartTypee = "5";
  String orderType = "1";
  String isUseWalletPayment = "1";
  String userId = "";
  RxBool isAgreed = false.obs;


  void goToOrderSuccess({required String? orderId}) {
    Get.offAllNamed(AppRoutes.orderSuccess, arguments: {"orderId": orderId});
  }

  Future<void> getCartListing(
    String isDeliverAllTogether,
    String cartType,
  ) async {
    cartTypee = cartType;
    isLoading(true);
    try {
      final response = await _repository.getCartListingData(
        cartType: cartType,
        isDeliverAllTogether: isDeliverAllTogether,
      );
      if (response != null) {
        isLoading(false);
        print("✅ $response");
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
        final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
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
        await analytics.logViewCart(
          currency: PrefStore().loadString(AppConstants.currencySymbol),
          value: totalAmount,
          items: (products?.available)?.map((item) {
            return AnalyticsEventItem(
              itemId: item.productId,
              itemName: item.productName,
              quantity: item.quantity.toIntSafe(),
              price: double.tryParse(item.selprodPrice ?? '0'),
            );
          }).toList(),
        );
      }
    } catch (e) {
      isLoading(false);
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
        isLoading(false);
        paymentSummaryModel.value = response;
        if (response?.displayLoginForm == 1) {
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

  Future<void> moveItemToCart(String selProductId, String quantity) async {
    isLoading(true);
    try {
      final response = await _repository.moveItemToCart(
        selproductId: selProductId,
        quantity: quantity,
      );
      if (response?.status == "1") {
        getCartListing(
          isDeliverAllTogether.value == true ? "1" : "0",
          cartTypee,
        );
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

  Future<void> productQuantityUpdate(String key, String quantity) async {
    isLoading(true);
    try {
      final response = await _repository.updateCartQuantity(
        key: key,
        quantity: quantity,
      );
      if (response?.status != "0") {
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
      print("❌ cart listing fetch error: $e");
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

        /// 🔥 GA4 Remove From Cart Event
        await FirebaseAnalytics.instance.logRemoveFromCart(
          items: [
            AnalyticsEventItem(
              itemId: key, // product ID
              itemName: item.productName, // optional but recommended
              quantity: 1,
              price: double.tryParse(item.total ?? '0'),
            ),
          ],
        );

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
    isLoading(true);
    try {
      final response = await _repository.applyCouponCode(
        couponCode: couponCode,
        fulfilmentType: fulfilmentType,
      );
      if (response?.status != "0") {
        isLoading(false);
        appliedCouponCode = couponCode;
        getpaymentSummary();
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

  Future<void> removeCoupon(String fulfilmentType) async {
    isLoading(true);
    try {
      final response = await _repository.removeCoupon(
        fulfilmentType: fulfilmentType,
      );
      if (response?.status != "0") {
        isLoading(false);
        appliedCouponCode = "";
        getpaymentSummary();
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
        if ((isUseWalletPayment == "1") && (walletBalance > orderNetAmount)) {
          debugPrint("here is pay from wallet");
          payFromWallet(orderId);
        } else if (selectedPlugin != null) {
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
              getCartListing(
                isDeliverAllTogether.value == true ? "1" : "0",
                cartTypee,
              );
            } else if (status == "success") {
              goToOrderSuccess(orderId: orderId);
            }
          }
        }
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
}
