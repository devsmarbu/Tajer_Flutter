import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/return/return_order/controller/return_order_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import '../model/resason_item.dart';

class ReturnOrderScreen extends StatelessWidget {
  ReturnOrderScreen({super.key});

  final ReturnOrderController controller =
  Get.put(ReturnOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F4F6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: Get.back,
        ),
        title: Obx(() {
          final type = controller.returnType.value;
          return Text(
            type == AppConstants.exchange
                ? AppStrings.appExchangeRequest.toUpperCase().tr
                : type == AppConstants.returnOrder
                ? AppStrings.appReturnRequests.toUpperCase().tr
                : AppStrings.appMissing.toUpperCase().tr,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          );
        }),
      ),

      /// ---------------- BODY ----------------
      body: Obx(
            () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// -------- PRODUCT CARD --------
              _productCard(),

              const SizedBox(height: 20),

              /// -------- QUANTITY --------
              _label('APP_QUANTITY'.tr),
              const SizedBox(height: 8),
              _quantitySelector(),

              const SizedBox(height: 20),

              /// -------- REASON --------
              if (controller.returnType.value != AppConstants.missing) ...[
                _label("APP_REASON".tr),
                const SizedBox(height: 8),
                _dropdownCard(),
                const SizedBox(height: 20),
              ],

              /// -------- COMMENTS --------
              _label("APP_COMMENTS".tr),
              const SizedBox(height: 8),
              _commentBox(),

              const SizedBox(height: 24),

              /// -------- IMAGE --------
              Obx(() {
                if (!controller.isImageRequired) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("APP_UPLOAD_IMAGE".tr),
                    const SizedBox(height: 8),
                    _imagePicker(),
                    const SizedBox(height: 24),
                  ],
                );
              }),

              /// -------- SUBMIT BUTTON --------
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- PRODUCT CARD ----------------
  Widget _productCard() {
    final productImageURL = controller.childOrderDetail?.product_image_url ?? controller.orderDetail?.productImageUrl;
    final productPrice = (controller.orderDetail?.opTotalPrice ?? '');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: productImageURL != null &&
                productImageURL.isNotEmpty
                ? Image.network(
              productImageURL,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderImage(),
            )
                : _placeholderImage(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  controller.orderDetail?.opSelprodTitle ?? controller.childOrderDetail?.selprod_title ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Nunito",
                  ),
                ),
                SizedBox(height: 4),
                // Text(
                //   controller.orderDetail?.opUnitPrice ?? controller.childOrderDetail?.op_unit_price  ?? ''
                //       '',
                //   style: TextStyle(
                //     fontSize: 13,
                //     color: Colors.grey,
                //   ),
                // ),
                // SizedBox(height: 6),
                // Text(
                //    controller.childOrderDetail?.totalAmount?.value ?? productPrice.toString() ,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w700,
                //     fontSize: 14,
                //   ),
                // ),
                Obx(() => Text(
                  controller.calculatedPriceWithCurrency,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ---------------- QUANTITY SELECTOR ----------------
  Widget _quantitySelector() {
    return Obx(
          () => Row(
        children: [
          _qtyBtn("-", () {
            if (controller.selectedQty.value > 1) {
              controller.selectedQty.value--;
            }
          }),
          const SizedBox(width: 12),
          Text(
            controller.selectedQty.value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito'
            ),
          ),
          const SizedBox(width: 12),
          _qtyBtn("+", () {
            if (controller.selectedQty.value <
                int.tryParse(controller.quantity ?? "1")!) {
              controller.selectedQty.value++;
            }
          }),
        ],
      ),
    );
  }

  Widget _qtyBtn(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  /// ---------------- DROPDOWN ----------------
  Widget _dropdownCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReasonsItem>(
          value: controller.selectedReason.value,
          isExpanded: true,
          hint:  Text('APP_SELECT_REASON'.tr,style: TextStyle(fontFamily: 'Nunito',fontSize: 14,fontWeight: FontWeight.w500),),
          items: controller.reasonList
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e.value ?? "",style: TextStyle(fontFamily: 'Nunito',fontSize: 14,fontWeight: FontWeight.w500)),
            ),
          )
              .toList(),
          onChanged: controller.onReasonChanged,
        ),
      ),
    );
  }

  /// ---------------- COMMENT BOX ----------------
  Widget _commentBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(fontFamily: "Nunito",fontSize: 14,fontWeight: FontWeight.w500),
        controller: controller.messageController,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "",
        ),
      ),
    );
  }

  /// ---------------- IMAGE PICKER ----------------
  Widget _imagePicker() {
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.gallery),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: controller.image.value == null
            ? const Center(
          child: Icon(Icons.camera_alt_outlined, size: 30),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            controller.image.value!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  /// ---------------- BUTTON ----------------
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: controller.orderExchangeRequest,
        child: Text(
          AppStrings.app_submit.tr,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );

  }

  Widget _placeholderImage() {
    return Container(
      width: 85,
      height: 85,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 30),
    );
  }

  /// ---------------- LABEL ----------------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: "Nunito",
        color: Colors.black87,
      ),
    );
  }
}