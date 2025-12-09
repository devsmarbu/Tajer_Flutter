import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajer/common/functions/app_function.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../offers/view/offer_view.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  int selectedIndex = 0; // 0 = Alerts, 1 = Offers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          AppStrings.appNotification.toUpperCase().tr,
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.black1,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Custom Tab Bar in Body
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab(AppStrings.appAlerts.toUpperCase().tr, 0),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.shade400,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildTab(AppStrings.appOffers.toUpperCase().tr, 1),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Tab Content
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                // Alerts Tab
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: controller.alerts.length,
                    itemBuilder: (context, index) {
                      final note = controller.alerts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.unotificationBody.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyText,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                AppFunction.getDateFormat(note.unotificationDate.toString(), "dd-MMM-yyyy, HH:mm"),
                                style: TextStyle(fontSize: 12, color: AppColors.black1),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(height: 2, color: AppColors.colorAccountBackground),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                )),

                // Offers Tab
                OfferView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom tab with underline on selection
  Widget _buildTab(String title, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "nunito",
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.black1 : AppColors.greyColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            color: isSelected ? AppColors.black1 : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
