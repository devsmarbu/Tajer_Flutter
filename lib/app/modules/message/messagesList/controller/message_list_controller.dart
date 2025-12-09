import 'dart:convert';
import 'package:get/get.dart';
import 'package:tajer/app/modules/message/chat_api_client.dart';
import 'package:tajer/app/modules/message/messagesList/models/message_data.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/threads.dart';

class MessageListController extends GetxController
    with ChatApiClient, AppLoader {
  var messages = <Threads>[].obs;
  var currentPage = 1.obs;
  var isLastPage = false.obs;
  var isLoadingMore = false.obs;
  final int pageSize = 10; // adjust based on API pagination size

  @override
  void onInit() {
    super.onInit();
    fetchMessages(); // initial load
  }

  Future<void> fetchMessages({bool isLoadMore = false}) async {
    // Prevent multiple simultaneous loads
    if (isLoadingMore.value || isLastPage.value) return;

    isLoadingMore.value = true;

    // Reset on fresh load
    if (!isLoadMore) {
      currentPage.value = 1;
      messages.clear();
    }

    if (await AppFunction.isInternetAvailable()) {
      try {
        if (!isLoadMore) showLoader(Get.context!);

        // 🔹 API call
        final response = await getChatList(currentPage.value);
        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<MessageData>.fromJson(
          body,
          fromJsonT: (jsonData) => MessageData.fromJson(jsonData),
        );

        hideLoader(Get.context!);

        if (data.responseCode == "200" &&
            data.status == AppConstants.SUCCESS) {
          final newMessages = data.data?.messages ?? [];

          messages.addAll(newMessages);

          // 🔹 Detect last page
          if (newMessages.length < pageSize) {
            isLastPage.value = true;
          } else {
            currentPage.value++;
          }
        }
        else if (data.responseCode == "200" && data.status == "0") {
          messages.addAll([]);
        }
        else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e, stack) {
        print('❌ Exception in fetchMessages: $e');
        print(stack);
        AppDialog.showMessage("Error loading messages.");
      } finally {
        if (!isLoadMore) hideLoader(Get.context!);
        isLoadingMore.value = false;
      }
    } else {
      AppDialog.showMessage("No internet connection.");
      isLoadingMore.value = false;
    }
  }
}
