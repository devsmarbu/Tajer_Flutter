import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/common_text_field.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/add_gift_card_controller.dart';

class AddGiftCardScreen extends StatelessWidget {
  const AddGiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddGiftCardController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: const Text(
          AppStrings.app_add_gift_card,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          children: [
            Obx(
              () => CommonTextField(
                backgroundColor: AppColors.colorAccountBackground,
                label: AppStrings.app_enter_amount,
                hint: AppStrings.app_error_enter_amount,
                controller: controller.amountController,
                errorText: controller.amountError.value.isNotEmpty
                    ? controller.amountError.value
                    : null,
                keyboardType: TextInputType.number,
                onChanged: controller.validateAmount,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
                  () => CommonTextField(
                    backgroundColor: AppColors.colorAccountBackground,
                    label: AppStrings.app_receiver_name,
                hint: AppStrings.app_error_enter_receiver_name,
                controller: controller.receiverNameController,
                errorText: controller.receiverNameError.value.isNotEmpty
                    ? controller.receiverNameError.value
                    : null,
                keyboardType: TextInputType.name,
                onChanged: controller.validateReceiverName,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
                  () => CommonTextField(
                    backgroundColor: AppColors.colorAccountBackground,
                label: AppStrings.app_receiver_email,
                hint: AppStrings.app_error_enter_receiver_email,
                controller: controller.receiverEmailController,
                errorText: controller.receiverEmailError.value.isNotEmpty
                    ? controller.receiverEmailError.value
                    : null,
                keyboardType: TextInputType.emailAddress,
                onChanged: controller.validateReceiverEmail,
              ),
            ),
            const SizedBox(height: 30),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveGiftCard,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          AppStrings.app_save,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 15,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontFamily: 'Nunito',
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87),
        ),
      ),
    );
  }
}
