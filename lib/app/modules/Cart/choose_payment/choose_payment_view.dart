import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/utils/app_strings.dart';
import '../cart_shipping/payment_summary_model/payment_summary_model.dart';

class SelectedPlugin {
  final String pluginId;
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
  final Function() walletMethodSelected;
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

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {
  String? selectedMethod;
  RxString selectedCardToken = "".obs;
  var selectedCardIndex = 0;

  final otherCardToken = Token(
    token: "",
    cardNumber: "Other Card",
    cardExpiry: "",
  );

  @override
  void initState() {
    super.initState();

    selectedMethod =
    widget.paymentSummaryModel?.data?.cartSummary?.cartWalletSelected == "1"
        ? AppStrings.appWallet.toUpperCase().tr
        : "card";

    /// Auto-select first card ONLY if tokens exist
    if (selectedMethod == "card") {
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

    debugPrint("this is the wallet balance");
    debugPrint((widget.paymentSummaryModel?.data?.displayUserWalletBalance ?? "0"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      value: selectedMethod == "wallet",
                      onChanged: (_) {
                        setState(() {
                          selectedMethod = "wallet";
                          widget.walletMethodSelected();
                        });
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              /// ——— CREDIT/DEBIT CARD ———
              Row(
                children: [
                  Radio<String>(
                    activeColor: Colors.black,
                    value: "card",
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() => selectedMethod = value!);

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
                    "assets/images/placeholder_image.png",
                    height: 28,
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 20),

              /// ——— CARD LIST (ONLY WHEN TOKENS EXIST) ———
              if (selectedMethod == "card" && widget.cards.isNotEmpty)
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
                                    setState(() => widget.cards.removeAt(index));
                                  },
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