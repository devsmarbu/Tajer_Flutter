import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/common/functions/app_function.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../messagesList/models/exchange_message.dart';
import '../../messagesList/models/return_message.dart';
import '../../messagesList/models/threads.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightGrey.withValues(alpha: 0.5),
        titleSpacing: 0,
        title: Obx(
              () => Text(
            controller.screenTitle.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          /// ✅ MESSAGES LIST
          Expanded(
            child: Obx(
                  () {
                // Dynamically choose message list
                final messages = controller.threadId.value.isNotEmpty
                    ? controller.messages
                    : controller.screenTitle.value ==
                    AppStrings.app_exchange_request
                    ? controller.messagesExchange
                    : controller.messagesReturn;

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    controller.loadMoreIfNeeded(scrollInfo);
                    return false;
                  },
                  child: ListView.builder(
                    reverse: false,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      /// ✅ Extract fields safely based on model type
                      String messageText = "";
                      String messageDate = "";
                      String messageFromUserId = "";

                      if (msg is Threads) {
                        messageText = msg.messageText ?? "";
                        messageDate = msg.messageDate ?? "";
                        messageFromUserId = msg.messageFromUserId ?? "";
                      } else if (msg is ExchangeMessage) {
                        messageText = msg.oermsgMsg ?? "";
                        messageDate = msg.oermsgDate ?? "";
                        messageFromUserId = msg.oermsgFromUserId ?? "";
                      } else if (msg is ReturnMessage) {
                        messageText = msg.orrmsgMsg ?? "";
                        messageDate = msg.orrmsgDate ?? "";
                        messageFromUserId = msg.orrmsgFromUserId ?? "";
                      }

                      final bool isSender =
                          controller.userID.value == messageFromUserId;

                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSender
                                    ? Colors.black
                                    : AppColors.lightGrey,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: isSender
                                      ? const Radius.circular(18)
                                      : const Radius.circular(0),
                                  bottomRight: isSender
                                      ? const Radius.circular(0)
                                      : const Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                messageText,
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                AppFunction.getDateFormat(
                                  messageDate,
                                  "dd-MMM-yyyy, HH:mm",
                                ),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Container(
                    color: AppColors.lightGrey,
                    height: 1,
                    width: Get.width,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          style: TextStyle(
                            color: AppColors.colorSubtitle,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: AppStrings.app_type_message_here,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.sendMessageCall();
                        },
                        icon: Image.asset(
                          'assets/images/ic_msg_send.png',
                          width: 22,
                          height: 22,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
