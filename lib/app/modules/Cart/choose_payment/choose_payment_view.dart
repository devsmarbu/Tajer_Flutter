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

class _PaymentSelectionPageState extends State<PaymentSelectionPage>
    with AppLoader {
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

    if (wallet > 0) {
      controller.useWallet.value = true;
      if (wallet < total) {
        controller.useCard.value = false;
        controller.selectedMethod = "both";
      } else {
        controller.useCard.value = false;
        controller.selectedMethod = "WALLET";
      }
    } else {
      controller.useWallet.value = false;
    }

    if (controller.selectedMethod == "card") {
      if (widget.cards.isNotEmpty) {
        selectedCardToken.value = widget.cards.first.token ?? "";
        selectedCardIndex = 0;
      } else {
        selectedCardToken.value = "";
      }
    }
  }

  void _selectPaymentMethod(int methodIndex, PaymentMethod method) {
    setState(() {
      controller.selectedPaymentMethodIndex.value = methodIndex;
      controller.selectedPaymentMethod = method;
      controller.cardTokens = method.tokens;
      controller.useCard.value = true;

      if (controller.isWalletSufficient) {
        controller.useWallet.value = false;
        controller.selectedMethod = "card";
      } else {
        controller.selectedMethod =
            controller.useWallet.value ? "both" : "card";
      }

      // Auto-select first token if available
      final tokens = method.tokens ?? [];
      if (tokens.isNotEmpty) {
        selectedCardToken.value = tokens.first.token ?? "";
        selectedCardIndex = 0;
        final plugin = SelectedPlugin(
          pluginId: method.pluginId ?? "",
          pluginCode: method.pluginCode ?? "",
          token: tokens.first,
        );
        controller.selectedPlugin = plugin;
        widget.onRadioSelected?.call(tokens.length, plugin);
      } else if (method.pluginId == "56") {
        // SkipCash with no saved tokens → pre-select "Other Card"
        selectedCardToken.value = otherCardToken.token ?? "";
        final plugin = SelectedPlugin(
          pluginId: method.pluginId ?? "",
          pluginCode: method.pluginCode ?? "",
          token: otherCardToken,
        );
        controller.selectedPlugin = plugin;
        widget.onRadioSelected?.call(0, plugin);
      } else {
        // Non-card method with no tokens → just set plugin, no token selection needed
        selectedCardToken.value = "";
        final plugin = SelectedPlugin(
          pluginId: method.pluginId ?? "",
          pluginCode: method.pluginCode ?? "",
          token: Token(token: "", cardNumber: "", cardExpiry: ""),
        );
        controller.selectedPlugin = plugin;
        widget.onRadioSelected?.call(0, plugin);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key("choose_payment_view"),
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
            style: const TextStyle(
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // const SizedBox(height: 4),
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
                        showLoader(context);

                        setState(() {
                          controller.useWallet.value =
                              !(controller.useWallet.value);

                          if (controller.isWalletSufficient) {
                            controller.useCard.value = false;
                            controller.selectedMethod = "WALLET";
                          } else {
                            controller.selectedMethod =
                                controller.useWallet.value ? "both" : "card";
                          }
                        });

                        try {
                          await widget.walletMethodSelected();
                        } catch (e) {
                          debugPrint("Wallet API error: $e");
                        } finally {
                          controller.isWalletLoading.value = false;
                          hideLoader(context);
                        }
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              /// ——— DYNAMIC PAYMENT METHODS ———
              Obx(() {
                final methods = controller.paymentMethodsList;

                if (methods.isEmpty) {
                  // Fallback: no payment methods from API
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: methods.asMap().entries.map((entry) {
                    final methodIndex = entry.key;
                    final method = entry.value;
                    final isSelected =
                        controller.selectedPaymentMethodIndex.value ==
                            methodIndex;
                    final tokens = method.tokens ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Payment method row
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 1),
                                Radio<int>(
                                  activeColor: Colors.black,
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: methodIndex,
                                  groupValue: controller.useCard.value
                                      ? controller
                                          .selectedPaymentMethodIndex.value
                                      : null,
                                  onChanged: (value) {
                                    _selectPaymentMethod(methodIndex, method);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    method.pluginName ?? "",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0, bottom: 12.0, top: 0),
                              child: (method.cardsImage != null && method.cardsImage!.isNotEmpty)
                                  ? Image.network(
                                      method.cardsImage!,
                                      height: 28,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        "assets/images/credit-card.png",
                                        height: 28,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/credit-card.png",
                                      height: 28,
                                    ),
                            ),
                          ],
                        ),

                        /// Token list for the selected payment method
                        if (isSelected && controller.useCard.value && tokens.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 0, bottom: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // "Other Card" appended only for SkipCash (pluginId 56)
                              itemCount: method.pluginId == "56"
                                  ? tokens.length + 1
                                  : tokens.length,
                              itemBuilder: (context, index) {
                                final isOtherCard =
                                    method.pluginId == "56" &&
                                        index == tokens.length;
                                final card = isOtherCard
                                    ? Token(
                                        cardNumber: AppStrings.appOtherCard
                                            .toUpperCase()
                                            .tr,
                                        cardExpiry: "",
                                      )
                                    : tokens[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 0, 2, 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          spacing: 10,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (card.cardExpiry?.isEmpty ??
                                                true)
                                              const SizedBox(height: 4),
                                            Text(
                                              card.cardNumber ?? "",
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            if (card.cardExpiry?.isNotEmpty ??
                                                false)
                                              Text(
                                                "${AppStrings.appExpiry.toUpperCase().tr} : ${card.cardExpiry}",
                                                style: const TextStyle(
                                                    fontFamily: "Nunito"),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Obx(() => Radio<String>(
                                                value: card.token ??
                                                    (isOtherCard
                                                        ? otherCardToken
                                                                .token ??
                                                            ""
                                                        : ""),
                                                groupValue:
                                                    selectedCardToken.value,
                                                onChanged: (val) {
                                                  selectedCardToken.value =
                                                      val!;

                                                  final plugin =
                                                      SelectedPlugin(
                                                    pluginId:
                                                        method.pluginId ??
                                                            "",
                                                    pluginCode:
                                                        method.pluginCode ??
                                                            "",
                                                    token: isOtherCard
                                                        ? otherCardToken
                                                        : card,
                                                  );

                                                  controller.selectedPlugin =
                                                      plugin;

                                                  widget.onRadioSelected
                                                      ?.call(
                                                    tokens.length,
                                                    plugin,
                                                  );
                                                },
                                              )),
                                          if (card.cardExpiry?.isNotEmpty ??
                                              false)
                                            IconButton(
                                              icon: Image.asset(
                                                'assets/images/bin.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              onPressed: () {
                                                final targetCard =
                                                    tokens[index];
                                                showAlertMessage(
                                                  context,
                                                  title: AppLabels.APP_NAME,
                                                  message: AppStrings
                                                      .appRemoveCartItemLabel
                                                      .toUpperCase()
                                                      .tr,
                                                  onOk: () async {
                                                    await controller
                                                        .removeCardItem(
                                                      "2",
                                                      targetCard.token ?? "",
                                                    );
                                                  },
                                                  onCancel: () {
                                                    debugPrint("dismissed");
                                                  },
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),


                        if (methodIndex < methods.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Divider(height: 1, color: Colors.grey[100]),
                          ),
                        SizedBox(height: 5)
                      ],
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}