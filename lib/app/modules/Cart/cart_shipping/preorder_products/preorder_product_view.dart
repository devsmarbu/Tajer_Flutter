import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/Cart/MainCartView.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/regular_products/regular_product_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/pref_store.dart';
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
import '../regular_products/add_comment/add_comment.dart';

class PreOrderCartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  PreOrderCartPage({super.key, required this.cartItems});

  @override
  State<PreOrderCartPage> createState() => _PreOrderCartPageState();
}

class _PreOrderCartPageState extends State<PreOrderCartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCartListing(
      (controller.isDeliverAllTogether.value == true ? "1" : "0"),
      "4",
    );
  }

  final ScrollController _scrollController = ScrollController();
  final controller = Get.put(RegularProductController());

  bool get isGuestUser {
    final rates = controller.cartListingModel.value?.data?.rates?.rates;
    return rates == null || rates.isEmpty;
  }

  bool _isAgreed = false; // 🔹 store value from DeliveryHtmlPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(
            height: Get.height,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }
        if ((controller.cartListingModel.value?.status == "0") ||
            (controller.cartListingModel.value == null)) {
          if (controller.groupedCombo.isEmpty) {
            return Center(
              child: EmptyCartWidget(
                imagePath: 'assets/images/shopping_cart.png',
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
                  imagePath: 'assets/images/shopping_cart.png',
                  message: AppStrings.appYourCartIsEmpty.tr,
                ),
              );
            }
          } else {
            if (controller.groupedCombo.isEmpty) {
              return Center(
                child: EmptyCartWidget(
                  imagePath: 'assets/images/shopping_cart.png',
                  message: AppStrings.appYourCartIsEmpty.tr,
                ),
              );
            }
          }
        }
        return SingleChildScrollView(
          controller: _scrollController, // Attached here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.cartListingModel.value?.data?.isDTVisible == "1")
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Checkbox(
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
                              "4",
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
                  await controller.moveItemToCart(cartItem.selprodId ?? '', "1",isRemovingSaveForLater: '1');
                  controller.addRemoveSaveForLaterItem(
                      cartItem.fulfillmentType ?? "2",
                      cartItem.selprodId ?? "",
                      cartItem.uwlpUwlistId ?? "",
                      "0",
                      cartItem.key ?? "",
                      false,
                      cartItem
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
                              final result = await Get.to(
                                () => AddressListScreen(),
                                arguments: {"comeFromCart": "1"},
                              );
                              debugPrint(result);
                              if (result == "1") {
                                controller.getCartListing(
                                  (controller.isDeliverAllTogether.value == true
                                      ? "1"
                                      : "0"),
                                  "4",
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
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
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
                                    (controller.isDeliverAllTogether.value ==
                                            true
                                        ? "1"
                                        : "0"),
                                    "4",
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
                            ),
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
                SizedBox(
                  height: 120,
                  child: CouponInput(
                    couponCode: controller.appliedCouponCode,
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
              SizedBox(height: 10),
              // if (controller.paymentSummaryModel.value?.data != null)
              //   DeliveryHtmlPage(
              //     onAgreeBtnTap: (agree) {
              //       setState(() {
              //         _isAgreed = agree;
              //       });
              //     },
              //     shippingGuidelines: controller
              //         .cartListingModel
              //         .value
              //         ?.data
              //         ?.shippingGuidelines,
              //     isAgreed: controller.isAgreed.value,
              //   ),
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
                  onRadioSelected: (cards, selectedCardIndex) {
                    print("radio button tap");
                    controller.getpaymentSummary(
                      redeemPoints: controller.usedRewardPoints,
                      orderId: controller.cartOrderId,
                      payFromWallet: "0",
                    );
                    controller.selectedPlugin = selectedCardIndex;
                    _scrollToBottom(cards);
                  },
                  paymentSummaryModel: controller.paymentSummaryModel.value,
                  walletMethodSelected: () async {
                    await controller.getpaymentSummary(
                      redeemPoints: controller.usedRewardPoints,
                      orderId: controller.cartOrderId,
                      payFromWallet: "1",
                    );
                  },
                  selectedPaymentMethod: controller.selectedPaymentMethod,
                ),
              if (controller.paymentSummaryModel.value?.data != null)
                NotesView(),
              if (controller.paymentSummaryModel.value?.data != null)
                Obx(
                  () => PlaceOrderView(
                    isAgreed: _isAgreed,
                    paymentSummaryModel: controller.paymentSummaryModel.value,
                    orderId: controller.cartOrderId,
                    usedRewardPoint: controller.usedRewardPoints,
                  ),
                ),
              PlatformInfo.isIOS26OrHigher() ? SizedBox(height: 90) : SizedBox.shrink()
            ],
          ),
        );
      }),
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
                    controller: controller,
                    item: item,
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
