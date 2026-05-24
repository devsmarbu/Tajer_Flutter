import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../Extensions/alert.dart';
import '../../../core/constants/app_labels.dart';
import '../cart_shipping/payment_summary_model/payment_summary_model.dart';
import '../cart_shipping/regular_products/regular_product_controller.dart';

class SelectedPlugin {
  String pluginId;
  final String pluginCode;
  final Token token;

  SelectedPlugin({
    required this.pluginCode,
    required this.token,
    required this.pluginId,
  });
}

class PaymentSelectionPage extends StatefulWidget {
  final Function(int, SelectedPlugin)? onRadioSelected;
  final List<Token> cards;
  final PaymentSummaryModel? paymentSummaryModel;
  final Future<void> Function() walletMethodSelected;
  final PaymentMethod? selectedPaymentMethod;

  PaymentSelectionPage({
    super.key,
    this.onRadioSelected,
    required this.cards,
    required this.paymentSummaryModel,
    required this.walletMethodSelected,
    required this.selectedPaymentMethod,
  });

  @override
  _PaymentSelectionPageState createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> with AppLoader{


  RxString selectedCardToken = "".obs;
  var selectedCardIndex = 0;

  final controller = Get.find<RegularProductController>();

  final otherCardToken = Token(
    token: "",
    cardNumber: "Other Card",
    cardExpiry: "",
  );

  @override
  void initState() {
    super.initState();

    final wallet =
        widget.paymentSummaryModel?.data?.userWalletBalance.toIntSafe() ?? 0;

    final total =
        widget.paymentSummaryModel?.data?.orderNetAmount.toIntSafe() ?? 0;

    /// ✅ CASE 1: Wallet has some balance
    if (wallet > 0) {
      controller.useWallet.value = true;

      /// If wallet is NOT sufficient → allow both
      if (wallet < total) {
        controller.useCard.value = false; // default only wallet selected
        controller.selectedMethod = "both"; // for internal tracking
      } else {
        /// Wallet sufficient → only wallet
        controller.useCard.value = false;
        controller.selectedMethod = "WALLET";
      }
    } else {
      /// No wallet → fallback to card
      controller.useWallet.value = false;
     // controller.useCard.value = true;
     // selectedMethod = "card";
    }

    // selectedMethod =
    // widget.paymentSummaryModel?.data?.cartSummary?.cartWalletSelected == "1"
    //     ? AppStrings.appWallet.toUpperCase().tr
    //     : "card";

    /// Auto-select first card ONLY if tokens exist
    if (controller.selectedMethod == "card") {
      if (widget.cards.isNotEmpty) {
        selectedCardToken.value = widget.cards.first.token ?? "";
        selectedCardIndex = 0;
        debugPrint("Auto-selected saved card: ${selectedCardToken.value}");
      } else {
        /// NO TOKENS → Do NOT pre-select other card
        selectedCardToken.value = "";
        debugPrint("No saved cards available.");
      }
    }

    debugPrint('this is selected method: $controller.selectedMethod');

    debugPrint("this is the wallet balance");
    debugPrint((widget.paymentSummaryModel?.data?.displayUserWalletBalance ?? "0"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("choose_payment_view"),
      children: [
        /// ——— HEADER ———
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Text(
            AppStrings.appChoosePaymentMethod.toUpperCase().tr,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        /// ——— MAIN ———
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              /// ——— WALLET ———
              if ((widget.paymentSummaryModel?.data?.userWalletBalance ?? "0")
                  .toIntSafe() >
                  0)
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appWallet.toUpperCase().tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${AppStrings.appAvailableBalance.toUpperCase().tr}  ${widget.paymentSummaryModel?.data?.displayUserWalletBalance ?? ""}",
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Checkbox(
                      activeColor: Colors.black,
                      value: controller.useWallet.value,
                      onChanged: (_) async {
                        if (controller.isWalletLoading.value) return;

                        controller.isWalletLoading.value = true;

                        showLoader(context); // ✅ SHOW APP LOADER

                        setState(() {
                          controller.useWallet.value = !(controller.useWallet.value);

                          if (controller.isWalletSufficient) {
                            controller.useCard.value = false;
                            controller.selectedMethod = "WALLET";
                          } else {
                            controller.selectedMethod =
                            controller.useWallet.value ? "both" : "card";
                          }
                        });

                        try {
                          await widget.walletMethodSelected(); // API call
                        } catch (e) {
                          debugPrint("Wallet API error: $e");
                        } finally {
                          controller.isWalletLoading.value = false;

                          hideLoader(context); // ✅ HIDE APP LOADER
                        }
                      },
                    )
                  ],
                ),

              const SizedBox(height: 12),

              /// ——— CREDIT/DEBIT CARD ———
              Row(
                children: [
                  Radio<String>(
                    activeColor: Colors.black,
                    value: "card",
                    groupValue: controller.useCard.value ? "card" : null,
                    onChanged: (value) {

                      setState(() {
                        controller.selectedMethod = "card";
                        controller.useCard.value = true;

                        if (controller.isWalletSufficient) {
                          /// Wallet alone is enough → disable wallet toggle
                          controller.useWallet.value = false;
                        } else {
                          /// Partial wallet → allow both
                          if (controller.useWallet.value) {
                            controller.selectedMethod = "both";
                          }
                        }
                      });

                      if (widget.cards.isNotEmpty) {
                        /// Saved cards exist
                        selectedCardIndex = 0;
                        selectedCardToken.value =
                            widget.cards.first.token ?? "";

                        final selectedPlugin = SelectedPlugin(
                          pluginId:
                          widget.selectedPaymentMethod?.pluginId ?? "",
                          pluginCode:
                          widget.selectedPaymentMethod?.pluginCode ?? "",
                          token: widget.cards.first,
                        );

                        widget.onRadioSelected?.call(
                            widget.cards.length, selectedPlugin);
                      } else {
                        /// NO saved cards → Implicitly Other Card
                        selectedCardToken.value = otherCardToken.token ?? "";

                        final selectedPlugin = SelectedPlugin(
                          pluginId:
                          widget.selectedPaymentMethod?.pluginId ?? "",
                          pluginCode:
                          widget.selectedPaymentMethod?.pluginCode ?? "",
                          token: otherCardToken,
                        );

                        widget.onRadioSelected?.call(
                            widget.cards.length, selectedPlugin);
                      }

                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Credit/Debit Card",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Image.asset(
                    // "assets/images/placeholder_image.png",
                    "assets/images/credit-card.png",
                    height: 28,
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 20),

              /// ——— CARD LIST (ONLY WHEN TOKENS EXIST) ———
              if (controller.useCard.value && widget.cards.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cards.length + 1, // +1 = Other Card option
                  itemBuilder: (context, index) {
                    final isOtherCard = index == widget.cards.length;

                    final card = isOtherCard
                        ? Token(
                      cardNumber:
                      AppStrings.appOtherCard.toUpperCase().tr,
                      cardExpiry: "",
                    )
                        : widget.cards[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (card.cardExpiry?.isEmpty ?? true)
                                  const SizedBox(height: 4),
                                Text(
                                  card.cardNumber ?? "",
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (card.cardExpiry?.isNotEmpty ?? false)
                                  Text(
                                    "${AppStrings.appExpiry.toUpperCase().tr} : ${card.cardExpiry}",
                                    style: const TextStyle(
                                      fontFamily: "Nunito",
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Obx(() => Radio<String>(
                                value: card.token ??
                                    (isOtherCard
                                        ? otherCardToken.token ?? ""
                                        : ""),
                                groupValue: selectedCardToken.value,
                                onChanged: (val) {
                                  selectedCardToken.value = val!;

                                  final selectedPlugin = SelectedPlugin(
                                    pluginId: widget
                                        .selectedPaymentMethod
                                        ?.pluginId ??
                                        "",
                                    pluginCode: widget
                                        .selectedPaymentMethod
                                        ?.pluginCode ??
                                        "",
                                    token:
                                    isOtherCard ? otherCardToken : card,
                                  );

                                  widget.onRadioSelected?.call(
                                    widget.cards.length,
                                    selectedPlugin,
                                  );
                                },
                              )),
                              if (card.cardExpiry?.isNotEmpty ?? false)
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/bin.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                    onPressed: () {
                                      final card = widget.cards[index];

                                      showAlertMessage(
                                        context,
                                        title: AppLabels.APP_NAME,
                                        message: AppStrings.appRemoveCartItemLabel.toUpperCase().tr, // reuse same text
                                        onOk: () async {
                                          await controller.removeCardItem(
                                            "2",
                                            card.token ?? "",
                                          );

                                        },
                                        onCancel: () {
                                          debugPrint("dismissed");
                                        },
                                      );
                                    }
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}