import 'dart:convert';
import 'package:get/get.dart';
import 'package:tajer/app/modules/rewards/models/rewards_data.dart';
import 'package:tajer/app/modules/rewards/reward_api_client.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';

class RewardsController extends GetxController with RewardApiClient {
  RxList<RewardPointsStatementItem> rewards = <RewardPointsStatementItem>[].obs;
  RxString totalPoints = ''.obs;
  RxString qrValue = ''.obs;

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isInitialLoading = false.obs;

  Future<void> fetchRewards({bool isInitialLoad = false, bool loadMore = false}) async {
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      return;
    }

    int page = loadMore ? currentPage.value + 1 : 1;

    try {
      if (isInitialLoad) isInitialLoading.value = true;
      if (loadMore) isLoadingMore.value = true;

      final response = await rewardPointsSearchApi(page);
      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<RewardsData>.fromJson(
        body,
        fromJsonT: (json) => RewardsData.fromJson(json),
      );

      if (data.responseCode == "200") {
        final rewardsData = data.data;
        if (rewardsData != null) {
          totalPoints.value = rewardsData.rewardPointsDetail?.balance ?? "0";
          qrValue.value = rewardsData.rewardPointsDetail?.convertedValue ?? "0";

          totalPages.value = int.tryParse(rewardsData.pageCount ?? "1") ?? 1;
          currentPage.value = int.tryParse(rewardsData.page ?? "1") ?? 1;

          final newItems = rewardsData.rewardPointsStatement ?? [];

          if (loadMore) {
            rewards.addAll(newItems);
          } else {
            rewards.assignAll(newItems);
          }
        }
      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong");
      }
    } catch (e) {
      AppDialog.showMessage("Error occurred while fetching rewards.");
      print('❌ Exception in fetchRewards: $e');
    } finally {
      isInitialLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreRewards() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      await fetchRewards(loadMore: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRewards(isInitialLoad: true);
  }
}
