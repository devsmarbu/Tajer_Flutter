import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/product_detail/product_detail_model.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../home/search_view/search_view.dart';
import '../controller/my_order_controller.dart';
import 'order_card.dart';

class MyOrdersView extends StatelessWidget {
  MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MyOrdersController(),
      tag: UniqueKey().toString(),
    );
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
         elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF3F2F8),
        title: Text(
          controller.orderId.value == ''
              ? AppStrings.appMyOrders.toUpperCase().tr
              : controller.orderNumber.value,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: controller.orderId.value == ''
            ? [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {
                    controller.openFilterBottomSheet(
                      Get.context!,
                      controller.filterList,
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Container(
        color: const Color(0xFFF3F2F8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 🔍 Search bar
            if (controller.orderId.value == '')
              TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: AppStrings.appSearch.toUpperCase().tr,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: 'Nunito',
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    suffixIcon: Obx(() {
                      return GestureDetector(
                        onTap: () => controller.isListening.value
                            ? controller.stopListening()
                            : controller.startListening(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isListening.value
                                ? Colors.red.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Icon(
                            controller.isListening.value
                                ? Icons.mic // 🎤 ACTIVE
                                : Icons.mic_none, // 🎙️ INACTIVE
                            color: controller.isListening.value
                                ? Colors.red
                                : Colors.black54,
                          ),
                        ),
                      );
                    }),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black12, // light border
                      width: 1,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black38, // darker when focused
                      width: 1.2,
                    ),
                  ),

                ),
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
              ),

            const SizedBox(height: 10),

            // 🔹 Order list
            Expanded(
              child: Obx(() {
                // 1️⃣ Loading state
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                // 2️⃣ Empty list state
                if (controller.orders.isEmpty) {
                  return  Center(
                    child: Text(
                      "APP_CAPTION_NO_DATA".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: "Nunito",
                      ),
                    ),
                  );
                }

                // 3️⃣ Main list view
                return RefreshIndicator(
                  onRefresh: controller.refreshOrders,
                   color: Colors.black,
                  backgroundColor: Colors.white,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.orderId.isEmpty
                        ? controller.orders.length + 1
                        : controller.ordersChild.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index ==
                          (controller.orderId.isEmpty
                              ? controller.orders.length
                              : controller.ordersChild.length)) {
                        // Loader for pagination
                        return controller.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }

                      if (controller.orderId.isEmpty) {
                        final order = controller.orders[index];
                        return OrderCard(order: order,onActionCompleted: controller.refreshOrders);
                      } else {
                        final order = controller.ordersChild[index];
                        return OrderCard(childOrderDetailItem: order,onActionCompleted: controller.refreshOrders);
                      }
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
