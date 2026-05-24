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
import 'package:flutter/material.dart';


class ReturnRequestController extends GetxController
    with ReturnRequestApiClient {
  var returnRequests = <RequestItem>[].obs;
  var isLoading = false.obs;

  /// 🔥 MULTI SELECT FILTERS
  var selectedFilters = <String>[].obs;

  /// return,exchange,missing,cancel
  String get selectedFilter => selectedFilters.join(',');

  /// 🔥 PAGINATION
  var currentPage = 1.obs;
  var isLastPage = false.obs;
  var isPaginationLoading = false.obs;
  var cancelReasons = <CancelReason>[].obs;
  var selectedReasonKey = ''.obs;
  var messageController = TextEditingController();
  var opId = ''.obs;

  final scrollController = ScrollController();

  List<OrderReturnStatus>? orderReturnRequestStatusArr;

  final tabs = [
    {
      "title": "APP_RETURN".tr,
      "value": "return",
    },
    {
      "title": "APP_EXCHANGE".tr,
      "value": "exchange",
    },
    {
      "title": "APP_MISSING".tr,
      "value": "missing",
    },
    {
      "title": "APP_CANCEL".tr,
      "value": "cancel",
    },
  ];

  @override
  void onInit() {
    super.onInit();

    fetchRequests(isRefresh: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isPaginationLoading.value &&
          !isLastPage.value) {
        fetchRequests();
      }
    });
  }

  /// 🔥 TOGGLE FILTER
  void toggleFilter(String value) {
    if (selectedFilters.contains(value)) {
      selectedFilters.remove(value);
    } else {
      selectedFilters.add(value);
    }

    selectedFilters.refresh();

    fetchRequests(isRefresh: true);
  }

  /// 🔥 API
  Future<void> fetchRequests({bool isRefresh = false}) async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      if (isRefresh) {
        currentPage.value = 1;
        isLastPage.value = false;
        returnRequests.clear();
        isLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }

      final response = await getRequests(
        type: selectedFilter,
        page: currentPage.value.toString(),
      );

      dynamic body = response.data;

      if (body is String) body = json.decode(body);

      final parsed = BaseResponse<RequestData>.fromJson(
        body,
        fromJsonT: (data) => RequestData.fromJson(data),
      );

      if (parsed.responseCode == "200" &&
          parsed.status == AppConstants.SUCCESS) {
        orderReturnRequestStatusArr = parsed.data?.allStatuses ?? [];

        final newData = parsed.data?.requests ?? [];

        if (currentPage.value == 1) {
          returnRequests.assignAll(newData);
        } else {
          returnRequests.addAll(newData);
        }

        /// 🔥 LAST PAGE
        if (newData.isEmpty) {
          isLastPage.value = true;
        } else {
          currentPage.value++;
        }
      } else {
        AppDialog.showMessage(parsed.msg);
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> fetchCancelReasons() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      isLoading.value = true;
      final response = await orderCancelReasons();
      dynamic body = response.data;
      if (body is String) body = json.decode(body);
      final parsed = BaseResponse<RequestData>.fromJson(
        body,
        fromJsonT: (data) => RequestData.fromJson(data),
      );
      if (parsed.responseCode == "200") {
        final reasons = parsed.data?.reasons ?? [];
        cancelReasons.assignAll(reasons);
      }
    } catch (e) {
      print("❌ Cancel reason error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitCancelOrder() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      isLoading.value = true;

      final response = await orderCancel(
        opId: opId.value,
        ocRMessage: messageController.text.trim(),
        cancelReasonId: selectedReasonKey.value,
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      /// ✅ correct parsing
      final parsed = CancelOrderResponse.fromJson(body);

      if (parsed.responseCode == "200" && parsed.status == "1") {
        selectedReasonKey.value = '';
        messageController.clear();

        Get.back(result: true); // go back after dialog
        Future.delayed(Duration(milliseconds: 300), () {
          AppDialog.showMessage(title: AppStrings.appName.tr, parsed.msg ?? '');
        });
      } else {
        AppDialog.showMessage(title: AppStrings.appName.tr, parsed.msg ?? '');
      }
    } catch (e) {
      print("❌ Cancel API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}