import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';

mixin NotificationApiClient{
  final ApiService _api = ApiService();

  Future<Response> notificationListApi(
      int page
      ) async {
    return await _api.dio.post(
      AppConstants.notificationList,
      data: FormData.fromMap({
        'page': page,
        'pagesize': 10,
      }),
    );
  }

  Future<Response> pushNotificationsListApi(
      int page
      ) async {
    return await _api.dio.post(
      AppConstants.pushNotificationsList,
      data: FormData.fromMap({
        'page': page,
        'pagesize': 10,
      }),
    );
  }

}