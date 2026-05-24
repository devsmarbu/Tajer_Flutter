import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/common/functions/app_function.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../utils/app_params.dart';
import '../../chatScreen/view/chat_screen.dart';
import '../controller/message_list_controller.dart';

class MessageListScreen extends StatelessWidget {
  final MessageListController controller = Get.put(MessageListController());
  final ScrollController scrollController = ScrollController();

  MessageListScreen({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !controller.isLoadingMore.value &&
          !controller.isLastPage.value) {
        controller.fetchMessages(isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appMessage.tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
            () => controller.messages.isEmpty
            ? Center(child: Text(AppStrings.appNoMessagesFound.tr,style: TextStyle(fontSize: 16, color: AppColors.black1)))
            : ListView.builder(
          controller: scrollController,
          itemCount: controller.messages.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.messages.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator(color: Colors.black)),
              );
            }

            final msg = controller.messages[index];
            return InkWell(
              onTap: () {

                Get.toNamed(AppRoutes.chatScreen,arguments: {
                  AppParams.threadId: msg.threadId.toString(),
                  AppParams.orRequestId:'',
                  AppParams.screenTitle: "${msg.messageToUsername} (${msg.messageFromShopName})"
                });
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child:
                      Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${msg.messageToUsername} (${msg.messageFromShopName})",
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppStrings.appSubject.toUpperCase().tr}:-",
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  msg.threadSubject.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.messageText.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Text(
                                AppFunction.getDateFormat(msg.messageDate.toString(), "dd-MMM-yyyy, HH:mm"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
