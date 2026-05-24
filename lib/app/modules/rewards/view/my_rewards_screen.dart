import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajer/common/functions/app_function.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../controller/rewards_controller.dart';

class MyRewardsScreen extends StatelessWidget {
  final RewardsController controller = Get.put(RewardsController());
  final ScrollController scrollController = ScrollController();

  MyRewardsScreen({super.key}) {
    // Scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // Trigger load more when close to bottom
        controller.loadMoreRewards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.app_my_rewards.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isInitialLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (controller.rewards.isEmpty) {
          return Center(
            child: Text(
              AppStrings.appNoRewardFound.toUpperCase().tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return Container(
          color: AppColors.colorAccountBackground,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.white,
                child: Column(
                  children: [
                    Text(
                      "${controller.totalPoints.value} ${AppStrings.appPoints.toUpperCase().tr}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "(${AppStrings.app_value.toUpperCase().tr} ${controller.qrValue.value})",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Rewards List with Pagination
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchRewards(isInitialLoad: true);
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.rewards.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at bottom
                      if (index == controller.rewards.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final reward = controller.rewards[index];

                      return Card(
                        color: AppColors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "+${reward.urpPoints ?? '0'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${AppStrings.app_earned_reward_points.toUpperCase().tr} ${reward.urpUsedOrderId ?? '-'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              const Divider(thickness: 1, height: 20),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(AppStrings.app_added_date.toUpperCase().tr,
                                          style: TextStyle(color: AppColors.black1,
                            fontWeight: FontWeight.w500,fontFamily: 'Nunito'
                        )),
                                      Text(AppFunction.getDateFormat(
                                          reward.urpDateAdded.toString(),
                                          "dd-MMM-yyyy, HH:mm"),
                                          style: TextStyle(
                                          fontWeight: FontWeight.w400,fontFamily: 'Nunito'
                                      )
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(AppStrings.app_expiry_date.toUpperCase().tr,
                                          style: TextStyle(color: AppColors.black1,
                                              fontWeight: FontWeight.w500,fontFamily: 'Nunito'
                                          )
                                      ),
                                      Text(reward.urpDateExpiry.toString(),style: TextStyle(
                                          fontWeight: FontWeight.w400,fontFamily: 'Nunito'
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
