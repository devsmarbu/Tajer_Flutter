import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../returnRequest/controller/return_request_controller.dart';
import 'package:flutter/material.dart';


class CancelOrderScreen extends StatelessWidget {
  final String opId;
  final controller = Get.put(ReturnRequestController());
  CancelOrderScreen({super.key, required this.opId}) {
    controller.fetchCancelReasons();
  }

  @override
  Widget build(BuildContext context) {
    controller.opId.value = opId; // 👈 set here
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
         backgroundColor:Colors.grey[100],
        title: Text(AppStrings.appCancel.toUpperCase().tr,style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w600)),
        leading: BackButton(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                   Text(
                    'APP_REASON_FOR_CANCELLATION'.tr,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🔥 Dynamic list
                  ...controller.cancelReasons.map((reason) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Obx(() => Radio<String>(
                              value: reason.key ?? '',
                              groupValue:
                              controller.selectedReasonKey.value,
                              activeColor: Colors.black87,
                              onChanged: (val) {
                                controller.selectedReasonKey.value =
                                    val ?? '';
                              },
                            )),
                            Expanded(
                              child: Text(
                                reason.value ?? '',
                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Nunito'),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.black.withAlpha(13)),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  /// Message box
                  TextField(
                    controller: controller.messageController,
                    cursorColor: Colors.black, // 👈 cursor color
                    style: TextStyle(fontFamily: 'Nunito'),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: AppStrings.appWriteYourMessage.toUpperCase().tr,
                      hintStyle: TextStyle(fontFamily: 'Nunito'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      /// 👇 when enabled
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 Bottom button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (controller.selectedReasonKey.value.isEmpty) {
                      Get.snackbar(AppStrings.appName.tr, 'APP_PLEASE_SELECT_A_REASON'.tr);
                      return;
                    }
                    if (controller.messageController.text.trim().isEmpty) {
                      Get.snackbar(AppStrings.appName.tr, 'APP_PLEASE_ENTER_MESSAGE'.tr);
                      return;
                    }
                    controller.submitCancelOrder();
                  },
                  child: Text('APP_SUBMIT'.tr,style: TextStyle(fontFamily: 'Nunito',color: Colors.white),),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}