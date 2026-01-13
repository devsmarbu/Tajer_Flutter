import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/gift_card_list_controller.dart';
import 'gift_card_filter/gift_card_filter_popover.dart';

class GiftCardListScreen extends StatelessWidget {
  const GiftCardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiftCardListController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appGiftCard.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: () {
                controller.addGiftCard("68e7651d06fce");
              },
              child: Text(
                AppStrings.appAddGiftCard.toUpperCase().tr,
                style: TextStyle(
                  color: AppColors.black1,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.giftCards.isEmpty) {
          return Center(
            child: Text(
              "APP_CAPTION_NO_DATA".tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.giftCards.length +
                (controller.isLoadingMore.value ? 1 : 0),
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              if (index == controller.giftCards.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final giftCard = controller.giftCards[index];

              return _buildCard(
                context,
                index,
                [
                  [AppStrings.appOrderId.toUpperCase().tr, giftCard.ogcardsOrderId],
                  [AppStrings.appGiftCode.toUpperCase().tr, giftCard.ogcardsCode],
                  [AppStrings.appReceiverName.toUpperCase().tr, giftCard.ogcardsReceiverName],
                  [AppStrings.appReceiverEmail.toUpperCase().tr, giftCard.ogcardsReceiverEmail],
                  [AppStrings.appLabelAmount.toUpperCase().tr, giftCard.orderNetAmount ?? ''],
                  [AppStrings.appPaymentStatus.toUpperCase().tr, giftCard.orderPaymentStatus ?? ''],
                  [
                    AppStrings.appLabelStatus.toUpperCase().tr,
                    giftCard.ogcardsStatus == "1"
                        ? AppStrings.app_paid.tr
                        : AppStrings.app_pending.tr
                  ],
                ],
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await showGeneralDialog(
            context: context,
            barrierLabel: AppStrings.appApplyFilters.toUpperCase().tr,
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.4),
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => GiftCardFilterPopover(
              statusList: controller.statusList,
              statusPaymentList: controller.statusPaymentList,
            ),
          );

          if (result != null) {

            final map = result as Map<String, dynamic>;

            if (map["clearAll"] == true) {
              controller.clearAllFilters();
              return;
            }

            controller.applyFilters(
              keyword: map["keyword"] ?? "",
              status: map["status"] ?? "",
              paymentStatus: map["paymentStatus"] ?? "",
            );
          }
        },
        child: const Icon(Icons.menu, color: Colors.white),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int cardIndex, List<List<String>> rows) {
    const borderColor = AppColors.grey;
    final radius = BorderRadius.circular(10);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.all(color: AppColors.black1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(4),
          },
          border: TableBorder(
            verticalInside: const BorderSide(color: borderColor, width: 1),
            horizontalInside: const BorderSide(color: borderColor, width: 1),
          ),
          children: List.generate(rows.length, (i) {
            final isFirst = i == 0;
            final isLast = i == rows.length - 1;
            final title = rows[i][0];
            final value = rows[i][1];

            final leftDecoration = BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: isFirst
                  ? const BorderRadius.only(topLeft: Radius.circular(10))
                  : isLast
                  ? const BorderRadius.only(bottomLeft: Radius.circular(10))
                  : null,
            );

            final rightDecoration = BoxDecoration(
              color: Colors.white,
              borderRadius: isFirst
                  ? const BorderRadius.only(topRight: Radius.circular(10))
                  : isLast
                  ? const BorderRadius.only(bottomRight: Radius.circular(10))
                  : null,
            );

            return TableRow(children: [
              Container(
                decoration: leftDecoration,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                decoration: rightDecoration,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
