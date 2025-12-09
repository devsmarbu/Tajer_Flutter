import 'dart:convert';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/return_request_api_client.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/request_data.dart';
import '../models/request_item.dart';

class ReturnRequestController extends GetxController
    with ReturnRequestApiClient {

  var returnRequests = <RequestItem>[].obs;
  var isLoading = false.obs;
  var screenTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  /// ----------------------------------------
  /// 🔥 API MAP → maps title to API function
  /// ----------------------------------------
  Future<dynamic> Function() _getApiForTitle(String title) {
    final map = {
      AppStrings.appReturnRequests.tr: getReturnRequest,
      AppStrings.appCancellationRequest.tr: orderCancellationRequestApi,
      AppStrings.appExchangeRequest.tr: getExchangeRequestApi,
    };
    return map[title] ?? getReturnRequest;
  }

  /// ----------------------------------------
  /// 🔥 Main fetch function (single source of truth)
  /// ----------------------------------------
  Future<void> fetchRequests() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      isLoading.value = true;

      /// Select correct API based on screen title
      final apiCall = _getApiForTitle(screenTitle.value);

      final response = await apiCall();
      dynamic body = response.data;

      if (body is String) body = json.decode(body);

      final parsed = BaseResponse<RequestData>.fromJson(
        body,
        fromJsonT: (data) => RequestData.fromJson(data),
      );

      /// Handle success/failure in one place
      if (parsed.responseCode == "200" &&
          parsed.status == AppConstants.SUCCESS) {
        returnRequests.assignAll(parsed.data?.requests ?? []);
      } else {
        AppDialog.showMessage(parsed.msg);
      }
    } catch (e) {
      print("❌ Exception in fetchRequests: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
