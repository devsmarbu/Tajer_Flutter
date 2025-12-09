import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/app/modules/return/return_order/controller/return_order_controller.dart';

import '../model/resason_item.dart';

class ReturnOrderScreen extends StatelessWidget {
  final controller = Get.put(ReturnOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Return"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text("Return Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              // Quantity dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedQty.value,
                    items: controller.quantities
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e.toString())))
                        .toList(),
                    onChanged: (v) => controller.selectedQty.value = v!,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // -------- Reason List ---------
              ...controller.reasonList.map((reason) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(reason.value ?? "",
                                style: TextStyle(fontSize: 15))),
                        Radio<ReasonsItem>(
                          value: reason,
                          groupValue: controller.selectedReason.value,
                          onChanged: (val) {
                            controller.selectedReason.value = val;
                          },
                        )
                      ],
                    ),
                    Divider(color: Colors.grey.shade300),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Message
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller.messageController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Write Your Message",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => controller.pickImage(ImageSource.gallery),
                child: Container(
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: controller.image.value == null
                      ? Icon(Icons.camera_alt, size: 35)
                      : Image.file(controller.image.value!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () => controller.orderExchangeRequest(),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
