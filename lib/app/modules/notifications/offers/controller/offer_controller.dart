import 'dart:convert';
import 'package:get/get.dart';
import 'package:tajer/app/modules/notifications/notification_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../alerts/models/notificationData.dart';

class OfferController extends GetxController
    with NotificationApiClient, AppLoader {

  /// Offers (push notifications)
  RxList<PushNotificationsItem> offers = <PushNotificationsItem>[].obs;

  /// Pagination
  int currentPage = 1;
  int lastPage = 1;

  /// Loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(isFirst: true);
  }

  /// Reset pagination before switching tabs
  void resetPagination() {
    currentPage = 1;
    lastPage = 1;
    offers.clear();
  }

  /// Whether more data exists
  bool get hasMoreData => currentPage < lastPage;

  /// -------- API CALL ----------
  Future<void> fetchNotifications({bool isFirst = false}) async {
    if (isLoading.value) return;
    isLoading(true);

    /// ❗ SAFE: Call loader after this frame so no overlay crash happens
    if (isFirst) {
      Future.delayed(Duration.zero, () {
        final ctx = Get.context;
        if (ctx != null) showLoader(ctx);
      });
    }

    try {
      final response = await pushNotificationsListApi(currentPage);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final parsed = BaseResponse<NotificationData>.fromJson(
        body,
        fromJsonT: (data) => NotificationData.fromJson(data),
      );

      if (parsed.responseCode == "200" &&
          parsed.status == AppConstants.SUCCESS) {

        lastPage = int.parse(parsed.data?.totalPages ?? "1");

        offers.addAll(parsed.data?.pnotifications ?? []);

        currentPage++;
      } else {
        AppDialog.showMessage(parsed.msg);
      }

    } catch (e) {
      print("❌ Error: $e");
    } finally {
      final ctx = Get.context;
      if (ctx != null) hideLoader(ctx);

      isLoading(false);
    }
  }
}
