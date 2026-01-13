import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/common_text_field.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/add_money_controller.dart';

class AddMoneyScreen extends StatelessWidget {
  AddMoneyScreen({Key? key}) : super(key: key);

  final AddMoneyController controller = Get.put(AddMoneyController());
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appAddMoney.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // 🔹 Top black balance header
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(AppStrings.appAvailableBalance.toUpperCase().tr,
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          fontSize: 16)),
                  SizedBox(height: 8),
                  Text(controller.currencySymbol+controller.walletBalance.value,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            // 🔹 Main content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        AppStrings.app_add_money_to_wallet.tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Common TextField for Amount input
                      CommonTextField(
                        label: "${AppStrings.appHintAmount.toUpperCase().tr}(\$)",
                        controller: amountController,
                        hint: AppStrings.appHintAmount.toUpperCase().tr,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Amount chips (quick selection)
                      Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        children: controller.amounts.map((amount) {
                          return Obx(() {
                            final isSelected =
                                controller.selectedAmount.value == amount;
                            return GestureDetector(
                              onTap: () {
                                controller.selectAmount(amount);
                                amountController.text = amount.toString();
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width -
                                    40 -
                                    24) /
                                    3,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                  isSelected ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                child: Text(
                                  amount.toString(),
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Bottom Add Money Button
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.addMoney();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    AppStrings.appAddMoney.toUpperCase().tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}