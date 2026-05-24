import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/common/functions/app_function.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../controller/return_request_detail_controller.dart';

class ReturnRequestDetailScreen extends StatelessWidget {
  final controller = Get.put(ReturnRequestDetailController());

  ReturnRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
          controller.screenTitle.value.isNotEmpty
              ? controller.screenTitle.value
              : "Request Detail",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Nunito'
          ),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),

      /// Reactive UI
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appLabelVendorAddress.toUpperCase().tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'Nunito'
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Vendor Address Card (Reactive)
              Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.uraName.value.isNotEmpty)
                      Text(
                        controller.uraName.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Nunito'
                        ),
                      ),
                    if (controller.address.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          controller.address.value,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              )),

              const SizedBox(height: 16),

              // ✅ Request Details Section
              Obx(() => _buildDetailSection(controller)),

              const SizedBox(height: 20),

              // ✅ Buttons (Reactive)
               Obx(() {
                return Column(
                  children: [
                    if (controller.canWithdrawRequest.value == "1")
                      _buildActionTile(
                        title: AppStrings.appBtnWithdraw.toUpperCase().tr,
                        onTap: controller.withdrawRequestClick,
                      ),
                    _buildActionTile(
                      title: AppStrings.appMessage.toUpperCase().tr,
                      onTap: controller.openMessages,
                    ),
                    if (controller.downloadLink.isNotEmpty)
                      _buildActionTile(
                        title: AppStrings.appDownloadAttachment.toUpperCase().tr,
                        trailing: const Icon(Icons.download, color: Colors.black),
                        onTap: controller.downloadAttachment,
                      ),
                  ],
                );
               }),
            ],
          ),
        );
      }),
    );
  }

  /// 🧩 Details Section Widget Code
  Widget _buildDetailSection(ReturnRequestDetailController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorAccountBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.requestReference.value.isNotEmpty)
          _buildRow('APP_REQUEST_ID'.tr, controller.requestReference.value),
          _buildRow('APP_DATE'.tr, controller.date.value),
          if (controller.productName.value.isNotEmpty)
            _buildRow('APP_LABEL_PRODUCT'.tr, controller.productName.value),
          if (controller.qty.value.isNotEmpty)
            _buildRow(AppStrings.appQuantity.toUpperCase().tr, controller.qty.value),
          if (controller.reasonTitle.value.isNotEmpty)
            _buildRow(AppStrings.appReason.toUpperCase().tr, controller.reasonTitle.value),
          if (controller.screenTitle.value == AppStrings.app_return_request)
            _buildRow(AppStrings.appLabelRequestType.toUpperCase().tr, controller.requestType.value),
          if (controller.screenTitle.value == AppStrings.app_return_request &&
              controller.amount.value.isNotEmpty)
            _buildRow(AppStrings.appLabelAmount, controller.amount.value),
          if (controller.requestStatusTitle.value.isNotEmpty)
            _buildRow(AppStrings.appLabelStatus.toUpperCase().tr, controller.requestStatusTitle.value),
        ],
      ),
    );
  }

  /// 📋 Reusable Row widget
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                height: 1.3,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 Common Action Tile
  Widget _buildActionTile({
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
