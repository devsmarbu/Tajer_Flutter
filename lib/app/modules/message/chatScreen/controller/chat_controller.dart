import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/message/chat_api_client.dart';
import 'package:tajer/app/modules/message/messagesList/models/threads.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_loader.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/common_data.dart';
import '../../../../../utils/pref_store.dart';
import '../../../../core/constants/app_constants.dart';
import '../../messagesList/models/exchange_message.dart';
import '../../messagesList/models/message_data.dart';
import '../../../../../utils/app_params.dart';
import '../../messagesList/models/return_message.dart';

class ChatController extends GetxController with ChatApiClient, AppLoader {
  /// Messages lists (chat thread)
  final messages = <Threads>[].obs;
  final messagesExchange = <ExchangeMessage>[].obs;
  final messagesReturn = <ReturnMessage>[].obs;

  /// Controllers
  final textController = TextEditingController();
  final pref = PrefStore();

  /// Args and state
  var threadId = ''.obs;
  var orRequestId = ''.obs;
  var getCanWithdrawRequest = ''.obs;
  var screenTitle = ''.obs;
  var title = ''.obs;
  var userID = ''.obs;

  /// Pagination state
  final currentPage = 1.obs;
  final isLastPage = false.obs;
  final isLoadingMore = false.obs;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    userID.value = pref.loadString(AppConstants.userId) ?? "";

    final args = Get.arguments ?? {};
    if (args is Map && args[AppParams.screenTitle] != null) {
      screenTitle.value = args[AppParams.screenTitle]?.toString() ?? '';
    }
    if (args is Map && args['title'] != null) {
      title.value = args['title']?.toString() ?? '';
    }

    if (screenTitle.value == AppStrings.app_return_request ||
        screenTitle.value == AppStrings.app_exchange_request || screenTitle.value == 'APP_RETURN_REQUEST_DETAILS'.tr || screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr || screenTitle.value == 'APP_MISSING_REQUEST_DETAIL'.tr || screenTitle.value == 'APP_CANCEL_REQUEST_DETAIL'.tr) {
      orRequestId.value = args[AppParams.orRequestId]?.toString() ?? '';
      getCanWithdrawRequest.value =
          args[AppParams.getCanWithdrawRequest]?.toString() ?? '';
    } else {
      threadId.value = args[AppParams.threadId]?.toString() ?? '';
    }

    fetchMessages();
  }

  /// ✅ Send message through API & update list instantly
  Future<void> sendMessageCall() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      return;
    }

    try {
      showLoader(Get.context!);

      dynamic response;

      // ✅ Call the correct send API
      if (threadId.value.isNotEmpty) {
        final messageId = messages.last.messageId.toString();
        response = await sendMessageApi(text,threadId.value,messageId);
      } else if (screenTitle.value == AppStrings.app_exchange_request || screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr) {
        response = await sendMessageExchangeOrderApi(text,orRequestId.value);
      } else {
        response = await sendMessageReturnOrderApi(text, orRequestId.value);
      }

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (jsonData) => CommonData.fromJson(jsonData),
      );

      hideLoader(Get.context!);

      if (data.responseCode == "200" &&
          data.status == AppConstants.SUCCESS) {

        textController.clear();
        fetchMessages();

      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e, stack) {
      AppDialog.showMessage("Error sending message.");
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// ✅ Fetch messages with pagination
  Future<void> fetchMessages({bool isLoadMore = false}) async {
    if (isLoadingMore.value) return;
    if (isLastPage.value && isLoadMore) return;

    isLoadingMore.value = true;

    if (!isLoadMore) {
      currentPage.value = 1;
      isLastPage.value = false;
      messages.clear();
      messagesExchange.clear();
      messagesReturn.clear();
    }

    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      isLoadingMore.value = false;
      return;
    }

    try {
      if (!isLoadMore) showLoader(Get.context!);

      dynamic response;
      // ✅ Determine which API to call
      if (threadId.value.isNotEmpty) {
        response = await getMessageList(threadId.value, currentPage.value);
      } else if (screenTitle.value == AppStrings.app_exchange_request || screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr) {
        response = await orderExchangeRequestMessageSearchApi(
            orRequestId.value, currentPage.value);
      } else {
        response = await orderReturnRequestMessageSearchApi(
            orRequestId.value, currentPage.value);
      }

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<MessageData>.fromJson(
        body,
        fromJsonT: (jsonData) => MessageData.fromJson(jsonData),
      );

      if (data.responseCode == "200" &&
          data.status == AppConstants.SUCCESS) {
        List newMessages;

        if (threadId.value.isNotEmpty) {
          newMessages = data.data?.threads ?? [];
        } else if (screenTitle.value == AppStrings.app_exchange_request || screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr) {
          newMessages = data.data?.exchangeMessagesList ?? [];
        } else {
          newMessages = data.data?.messagesList ?? [];
        }

        if (newMessages.isEmpty) {
          isLastPage.value = true;
        } else {
          if (threadId.value.isNotEmpty) {
            messages.addAll(newMessages.cast<Threads>());
          } else if (screenTitle.value ==
              AppStrings.app_exchange_request || screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr) {
            messagesExchange.addAll(newMessages.cast<ExchangeMessage>());
          } else {
            messagesReturn.addAll(newMessages.cast<ReturnMessage>());
          }

          if (newMessages.length < pageSize) {
            isLastPage.value = true;
          } else {
            currentPage.value++;
          }
        }
      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong.");
      }
    } catch (e, stack) {
      print('❌ Exception in fetchMessages: $e');
      print(stack);
      AppDialog.showMessage("Error loading messages.");
    } finally {
      if (!isLoadMore) hideLoader(Get.context!);
      isLoadingMore.value = false;
    }
  }

  /// ✅ Load more when scrolled to bottom
  void loadMoreIfNeeded(ScrollNotification scrollInfo) {
    if (!isLastPage.value &&
        !isLoadingMore.value &&
        scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent * 0.8) {
      fetchMessages(isLoadMore: true);
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
