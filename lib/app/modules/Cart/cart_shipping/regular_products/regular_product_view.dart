import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/Cart/MainCartView.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/regular_products/regular_product_controller.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_params.dart';
import '../../../../Extensions/alert.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_labels.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../address/addressList/view/address_list_screen.dart';
import '../../address/address_view.dart';
import '../../choose_payment/choose_payment_view.dart';
import '../../coupon_view/coupon_view.dart';
import '../../delivery_option/delivery_option_view.dart';
import '../../notes/notes_view.dart';
import '../../order_price_detail/order_price_detail_view.dart';
import '../../place_order/place_order_view.dart';
import '../../reward_points/reward_points_view.dart';
import '../../save_for_later/save_for_later_view.dart';
import '../../shipping_guideline/shipping_guideline_view.dart';
import '../cart_listing_model/cart_listing_model.dart';
import '../cart_listing_model/product_card.dart';
import 'add_comment/add_comment.dart';
import 'package:flutter/gestures.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with AppLoader {
  final controller = Get.put(RegularProductController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetVariables();

      controller.getCartListing(
        (controller.isDeliverAllTogether.value ? "1" : "0"),
        "5",
      );
    });
  }

  bool get isGuestUser {
    final rates = controller.cartListingModel.value?.data?.rates?.rates;
    return rates == null || rates.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: Key("regular_product_view"),
      backgroundColor: Colors.transparent,
      body: Obx(() {
        Widget buildContent() {
          if ((controller.cartListingModel.value?.status == "0") ||
              (controller.cartListingModel.value == null)) {
            return Center(
              child: EmptyCartWidget(
                 key: Key("empty_cart_widget"),
                imagePath: 'assets/images/shopping_cart.png',
                // message: AppStrings.appYourCartIsEmpty.toUpperCase().tr,
                message: AppStrings.appYourCartIsEmpty.tr,
              ),
            );
          }

          if (isGuestUser) {
            if (controller
                    .cartListingModel
                    .value
                    ?.data
                    ?.products
                    ?.available
                    ?.isEmpty ==
                true) {
              return Center(
                child: EmptyCartWidget(
                   key: Key("empty_cart_widget2"),
                  imagePath: 'assets/images/shopping_cart.png',
                  message: AppStrings.appYourCartIsEmpty.tr,
                ),
              );
            }
          } else {
            if (controller.groupedCombo.isEmpty) {
              return Center(
                child: EmptyCartWidget(
                   key: Key("empty_cart_widget3"),
                  imagePath: 'assets/images/shopping_cart.png',
                  message: AppStrings.appYourCartIsEmpty.tr,
                ),
              );
            }
          }
          return SingleChildScrollView(
           key: Key("single_child_scroll_view"),
          controller: _scrollController, // Attached here
          child: Column(
             key: Key("single_child_scroll_column"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.cartListingModel.value?.data?.isDTVisible == "1")
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Checkbox(
                         key: Key("single_child_scroll_check_box"),
                        activeColor: Colors.black,
                        value: controller.isDeliverAllTogether.value,
                        onChanged: (bool? newValue) {
                          setState(() {
                            controller.isDeliverAllTogether.value =
                                newValue ?? false; // Toggle the state
                            // widget.onAgreeBtnTap?.call(_agreed);
                            controller.getCartListing(
                              (controller.isDeliverAllTogether.value == true
                                  ? "1"
                                  : "0"),
                              "5",
                            );
                          });
                        },
                      ),
                    ),

                    Text(
                      AppStrings.appDeliverAllProductsTogether.toUpperCase().tr,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              Column(
                children: [
                  if (isGuestUser)
                    ..._buildGuestUserItems() // directly show available items
                  else
                    ..._buildRegisteredUserCombos(),
                  // original groupedCombo logic
                ],
              ),
              SaveForLaterView(
                cartItems:
                    controller
                        .cartListingModel
                        .value
                        ?.data
                        ?.products
                        ?.saveForLater ??
                    [],
                onSelected: (cartItem, quantity) async {
                  await controller.moveItemToCart(
                    cartItem.selprodId ?? '',
                    "1",
                    isRemovingSaveForLater: '1',
                  );
                  controller.addRemoveSaveForLaterItem(
                    cartItem.fulfillmentType ?? "2",
                    cartItem.selprodId ?? "",
                    cartItem.uwlpUwlistId ?? "",
                    "0",
                    cartItem.key ?? "",
                    false,
                    cartItem,
                  );
                },
                removeItem: (cartItem) {
                  showAlertMessage(
                    context,
                    title: AppLabels.APP_NAME,
                    message: AppStrings.appRemoveCartItemLabel.toUpperCase().tr,
                    onOk: () {
                      controller.addRemoveSaveForLaterItem(
                        cartItem.fulfillmentType ?? "2",
                        cartItem.selprodId ?? "",
                        cartItem.uwlpUwlistId ?? "",
                        "0",
                        cartItem.key ?? "",
                        false,
                        cartItem,
                      );
                    },
                    onCancel: () {
                      debugPrint("dismissed");
                    },
                  );
                },
              ),
              // AddressView at the bottom
              Obx(
                () => Column(
                  children: [
                    (controller
                                .cartListingModel
                                .value
                                ?.data
                                ?.cartSelectedShippingAddress
                                ?.addrRecordId !=
                            null)
                        ? AddressView(
                            address: controller
                                .cartListingModel
                                .value
                                ?.data
                                ?.cartSelectedShippingAddress,
                            isSelected: true,
                            onEdit: () async {
                              // final result = await Get.to(
                              //   () => AddressListScreen(),
                              //   arguments: {"comeFromCart": "1"},
                              // );
                              final result = await Get.toNamed(
                                AppRoutes.shippingAddress,
                                arguments: {"comeFromCart": "1"},
                              );
                              debugPrint(result);
                              if (result == "1") {
                                controller.getCartListing(
                                  (controller.isDeliverAllTogether.value == true
                                      ? "1"
                                      : "0"),
                                  "5",
                                );
                              }
                            },
                            onLabelTap: () {},
                          )
                        : (PrefStore().loadString(AppConstants.sessionToken) !=
                              "")
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 20,
                            ),
                            child: controller.isLoggedIn.value == true
                                ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final result = await Get.to(
                                        () => AddressListScreen(),
                                        arguments: {"comeFromCart": "1"},
                                      );
                                      if (result == "1") {
                                        controller.getCartListing(
                                          (controller
                                                      .isDeliverAllTogether
                                                      .value ==
                                                  true
                                              ? "1"
                                              : "0"),
                                          "5",
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text(
                                      'APP_ADD_ADDRESS'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              // 👈 CENTER CONTENT
                              child: Text(
                                controller.paymentSummaryModel.value?.msg ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Nunito",
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (controller.paymentSummaryModel.value?.data != null)
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    height: controller.couponErrorMessage.value.isNotEmpty
                        ? 130
                        : 110,

                    child: CouponInput(
                      couponCode: controller.appliedCouponCode.value,
                      errorMessage: controller.couponErrorMessage.value,
                      onTextChanged: () {
                        controller.couponErrorMessage.value = "";
                      },
                      onApplyingCoupon: (coupon) {
                        controller.applyCouponCode(coupon, "2");
                      },
                      onRemovingCoupon: () {
                        controller.removeCoupon("2");
                      }, isLoading: controller.isCouponLoading.value,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              if (controller.paymentSummaryModel.value?.data != null)
                // DeliveryHtmlPage(
                //   onAgreeBtnTap: (agree) {
                //     setState(() {
                //       controller.isAgreed.value = agree;
                //       debugPrint("${controller.isAgreed.value}");
                //     });
                //   },
                //   shippingGuidelines: controller
                //       .cartListingModel
                //       .value
                //       ?.data
                //       ?.shippingGuidelines, isAgreed: controller.isAgreed.value,
                // ),
                if (controller.paymentSummaryModel.value?.data != null)
                  SizedBox(
                    child: OrderPriceDetailView(
                      paymentSummaryModel: controller.paymentSummaryModel.value,
                    ),
                  ),
              if ((controller.paymentSummaryModel.value?.data != null) &&
                  (controller.paymentSummaryModel.value?.data?.rewardPoints !=
                      "0"))
                Obx(
                  () => RewardPointsView(
                    rewardPoints:
                        controller
                            .paymentSummaryModel
                            .value
                            ?.data
                            ?.rewardPoints ??
                        "",
                    canBeUseRP:
                        controller
                            .paymentSummaryModel
                            .value
                            ?.data
                            ?.canBeUseRp ??
                        "",
                    applyRewardPoints: (points) {
                      controller.getpaymentSummary(
                        redeemPoints: points,
                        orderId: controller.cartOrderId,
                      );
                    },
                    onRemovingCoupon: () {
                      controller.removeReward(orderId: controller.cartOrderId);
                    },
                    usedRewardPoints: controller.usedRewardPoints,
                  ),
                ),
              if (controller.paymentSummaryModel.value?.data != null)
                PaymentSelectionPage(
                  cards: controller.cardTokens ?? [],
                  onRadioSelected: (cards, selectedCardIndex) async {
                    print("radio button tap");
                    controller.selectedPlugin = selectedCardIndex;
                    showLoader(context);
                    if (controller.selectedMethod == "both" ||
                        controller.selectedMethod == "WALLET") {
                      /// Only call API when wallet fully used (rare case)
                      await controller.getpaymentSummary(
                        redeemPoints: controller.usedRewardPoints,
                        orderId: controller.cartOrderId,
                        payFromWallet: "1",
                      );
                    } else {
                      await controller.getpaymentSummary(
                        redeemPoints: controller.usedRewardPoints,
                        orderId: controller.cartOrderId,
                        payFromWallet: "0",
                      );
                    }

                    hideLoader(context);

                    // _scrollToBottom(cards);
                  },
                  paymentSummaryModel: controller.paymentSummaryModel.value,
                  walletMethodSelected: () async {
                    final payFromWallet = controller.useWallet.value
                        ? "1"
                        : "0";
                    await controller.getpaymentSummary(
                      redeemPoints: controller.usedRewardPoints,
                      orderId: controller.cartOrderId,
                      payFromWallet: payFromWallet,
                    );
                  },
                  selectedPaymentMethod: controller.selectedPaymentMethod,
                ),
              if (controller.paymentSummaryModel.value?.data != null)
                NotesView(),
              if (controller.paymentSummaryModel.value?.data != null)
                Obx(
                  () => PlaceOrderView(
                    isAgreed: controller.isAgreed.value,
                    paymentSummaryModel: controller.paymentSummaryModel.value,
                    orderId: controller.cartOrderId,
                    usedRewardPoint: controller.usedRewardPoints,
                  ),
                ),
              PlatformInfo.isIOS26OrHigher()
                  ? SizedBox(height: 90)
                  : SizedBox.shrink(),
            ],
          ),
        );
        }
        return Stack(
          children: [
            buildContent(),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ),
          ],
        );
      }),
    );
  }

  void navigateToWebView(String title, String url) {
    Get.toNamed(
      AppRoutes.webViewScreen,
      arguments: {AppParams.title: title, AppParams.webViewUrl: url},
    );
  }

  void _scrollToBottom(int cardsCount) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        (_scrollController.position.maxScrollExtent) + (cardsCount * 110),
        duration: const Duration(milliseconds: 500), // Smooth animation
        curve: Curves.easeInOut, // Easing curve
      );
    }
  }

  List<Widget> _buildGuestUserItems() {
    debugPrint("you are here in this guest user block");
    final items =
        controller.cartListingModel.value?.data?.products?.available ?? [];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Padding(
        // key: Key("build_guest_user_item"),
        padding: EdgeInsets.only(top: index == 0 ? 0 : 10, bottom: 10),
        child: CartItemCard(
          item: item,
          onComment: () async {
            final comment = await showCommentDialog(context);
            if (comment != null) debugPrint("User comment: $comment");
          },
          onDecrease: () {
            if (item.quantity == "1") {
              showAlertMessage(
                Get.context!,
                title: AppLabels.APP_NAME,
                message: "Minimum order quantity is 1.",
              );
            } else {
              controller.productQuantityUpdate(
                item.key ?? "",
                "${((item.quantity ?? "1").toIntSafe()) - 1}",
              );
            }
          },
          onIncrease: () {
            controller.productQuantityUpdate(
              item.key ?? "",
              "${((item.quantity ?? "1").toIntSafe()) + 1}",
            );
          },
          onSaveForLater: () {
            debugPrint("on save for later");
            controller.saveForLaterProduct(item.selprodId ?? "");
          },
          onRemove: () {
            showAlertMessage(
              context,
              title: AppLabels.APP_NAME,
              message: "Are you sure want to remove this?",
              onOk: () {
                controller.deleteCartItem(item.key ?? "", "2", item);
              },
              onCancel: () {},
            );
          },
          onFavTap: () {
            if (item.isInAnyWishlist == "0" || item.isInAnyWishlist == "") {
              controller.addRemoveSaveForLaterItem(
                item.fulfillmentType ?? '2',
                item.selprodId ?? "",
                item.uwlpUwlistId ?? "",
                "1",
                item.key ?? "",
                true,
                item,
              );
            } else {
              showAlertMessage(
                context,
                title: AppLabels.APP_NAME,
                message: "Already Added To Your Wishlist.",
              );
            }
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildRegisteredUserCombos() {
    debugPrint("you are here in this registered user block");

    return controller.groupedCombo.asMap().entries.map((combo) {
      final index = combo.key;

      final ratesMap = controller.cartListingModel.value?.data?.rates?.rates;
      final rateValues = ratesMap?.values.toList() ?? [];
      final rateKeys = ratesMap?.keys.toList() ?? [];

      final shippingMethods =
          (rateValues.isNotEmpty &&
              index < rateValues.length &&
              rateValues[index].shippingMethods != null)
          ? List<ShippingMethod>.from(rateValues[index].shippingMethods!)
          : <ShippingMethod>[];

      return Container(
        // key: Key("build_registered_user_combo"),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SHIPPING PICKER
              SizedBox(
                height: (shippingMethods.isEmpty) ? 60 : 40,
                child: ShippingPickerWidget(
                  shippingMethods: shippingMethods,
                  onSelected: (selectedMethod) {
                    final selectedKey = rateKeys[index];
                    controller
                            .groupedCombo[index]
                            .shippingMethod?["shipping_services[$selectedKey]"] =
                        selectedMethod.serviceCode ?? "";
                    controller.getpaymentSummary();
                  },
                ),
              ),

              Divider(color: Colors.grey[200]),

              // ITEMS inside this combo
              ...?combo.value.availableItems?.asMap().entries.map((entry) {
                final itemIndex = entry.key;
                final item = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    top: itemIndex == 0 ? 0 : 10,
                    bottom: 10,
                  ),
                  child: CartItemCard(
                    item: item,
                    controller: controller,
                    onComment: () async {
                      final comment = await showCommentDialog(context);
                      if (comment != null) {
                        debugPrint("User comment: $comment");
                      }
                    },
                    onDecrease: () {
                      if (item.quantity == "1") {
                        showAlertMessage(
                          Get.context!,
                          title: AppLabels.APP_NAME,
                          message: "Minimum order quantity is 1.",
                        );
                      } else {
                        controller.productQuantityUpdate(
                          item.key ?? "",
                          "${((item.quantity ?? "1").toIntSafe()) - 1}",
                        );
                      }
                    },
                    onIncrease: () {
                      controller.productQuantityUpdate(
                        item.key ?? "",
                        "${((item.quantity ?? "1").toIntSafe()) + 1}",
                      );
                    },
                    onSaveForLater: () {
                      controller.saveForLaterProduct(item.selprodId ?? "");
                    },
                    onRemove: () {
                      showAlertMessage(
                        context,
                        title: AppLabels.APP_NAME,
                        message: "Are you sure want to remove this?",
                        onOk: () {
                          controller.deleteCartItem(item.key ?? "", "2", item);
                        },
                        onCancel: () {
                          debugPrint("dismissed");
                        },
                      );
                    },
                    onFavTap: () {
                      if ((item.isInAnyWishlist == "0") ||
                          (item.isInAnyWishlist == "")) {
                        debugPrint("in this block");
                        debugPrint("${item.isInAnyWishlist}");
                        controller.addRemoveSaveForLaterItem(
                          item.fulfillmentType ?? '2',
                          item.selprodId ?? "",
                          item.uwlpUwlistId ?? "",
                          "1",
                          item.key ?? "",
                          true,
                          item,
                        );
                      } else {
                        showAlertMessage(
                          context,
                          title: AppLabels.APP_NAME,
                          message: "Already Added To Your Wishlist.",
                        );
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }).toList();
  }
}
