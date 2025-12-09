import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/notifications/alerts/models/notificationData.dart';
import 'package:tajer/app/modules/notifications/notification_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';

class NotificationController extends GetxController
    with NotificationApiClient, AppLoader {

  /// Alerts (notification list)
  RxList<NotificationsItem> alerts = <NotificationsItem>[].obs;



  /// Pagination
  int currentPage = 1;
  int lastPage = 1;

  /// Loading state
  RxBool isLoading = false.obs;

  /// Tabs → 0 = Alerts, 1 = Offers
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();

    /// SAFELY load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotifications(isFirst: true);
    });

    /// Reload data whenever tab changes
    ever(selectedTab, (_) {
      resetPagination();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchNotifications(isFirst: true);
      });
    });
  }

  /// Reset pagination before switching tabs
  void resetPagination() {
    currentPage = 1;
    lastPage = 1;
    alerts.clear();
  }

  /// Whether more data exists
  bool get hasMoreData => currentPage < lastPage;

  /// -------- API CALL ----------
  Future<void> fetchNotifications({bool isFirst = false}) async {
    if (isLoading.value) return;

    isLoading(true);

    /// SAFE LOADER (after first frame)
    showLoader(Get.context!);

    try {
      final response = await notificationListApi(currentPage);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final parsed = BaseResponse<NotificationData>.fromJson(
        body,
        fromJsonT: (data) => NotificationData.fromJson(data),
      );

      if (parsed.responseCode == "200" &&
          parsed.status == AppConstants.SUCCESS) {

        lastPage = int.parse(parsed.data?.totalPages ?? "1");

        /// Add data to the proper tab list
        alerts.addAll(parsed.data?.notifications ?? []);


        currentPage++;
      } else {
        AppDialog.showMessage(parsed.msg);
      }

    } catch (e) {
      print("❌ Error: $e");
    } finally {
      hideLoader(Get.context!);
      isLoading(false);
    }
  }
}
