import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/common/functions/app_function.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../controller/return_request_controller.dart';
import '../models/request_item.dart';

class ReturnRequestsScreen extends StatelessWidget {
  final ReturnRequestController controller = Get.put(ReturnRequestController());

  final String screenTitle = Get.arguments['title'] ?? AppStrings.appReturnRequests.tr;

  ReturnRequestsScreen({Key? key}) : super(key: key) {
    controller.screenTitle.value = screenTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          screenTitle,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.returnRequests.isEmpty) {
          return Center(
            child: Text(
              "APP_CAPTION_NO_DATA".tr,
              style: TextStyle(fontSize: 16, color: AppColors.black1),
            ),
          );
        }

        return Container(
          color: AppColors.colorAccountBackground,
          child: ListView.builder(
            itemCount: controller.returnRequests.length,
            itemBuilder: (context, index) {
              final request = controller.returnRequests[index];
              return ReturnRequestTile(request: request,title: controller.screenTitle.value);
            },
          ),
        );
      }),
    );
  }
}

class ReturnRequestTile extends StatefulWidget {
  final RequestItem request;
  final String title;

  const ReturnRequestTile({super.key, required this.request, required this.title});

  @override
  State<ReturnRequestTile> createState() => _ReturnRequestTileState();
}

class _ReturnRequestTileState extends State<ReturnRequestTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {

        if(widget.title==AppStrings.app_return_request){
          Get.toNamed(AppRoutes.returnRequestDetail, arguments: {'requestId': request.orrequestId.toString(),'title':widget.title});
        }else if(widget.title==AppStrings.app_cancellation_request){
        //  requestId=request.oeRequestId.toString();
        }else if(widget.title==AppStrings.app_exchange_request){
          debugPrint('checkrequestId : ${request.oeRequestId}');
          Get.toNamed(AppRoutes.returnRequestDetail, arguments: {'requestId': request.oeRequestId.toString(),'title':widget.title});
        }
      },
      child: Card(
        color: AppColors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (request.productImageUrl?.isNotEmpty ?? false)
                        ? Image.network(
                      request.productImageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                        : const Icon(Icons.image_not_supported,
                        size: 100, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.opInvoiceNumber ?? "-",
                          style: TextStyle(
                            color: AppColors.splashCenter,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.selprodTitle ?? "-",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.black1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                    Text(
                      widget.title == AppStrings.app_return_request
                          ? "Order on: ${AppFunction.getDateFormat(request.orrequestDate ?? "", "dd-MMM-yyyy, HH:mm")}"
                          : widget.title == AppStrings.app_cancellation_request
                          ? "Order on: ${AppFunction.getDateFormat(request.ocrequestDate ?? "", "dd-MMM-yyyy, HH:mm")}"
                          : "Order on: ${AppFunction.getDateFormat(request.oerequestDate ?? "", "dd-MMM-yyyy, HH:mm")}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.black1,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),

              // Status Row (Expandable)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: request.statusName?.toLowerCase() == "pending"
                            ? Colors.orange
                            : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        request.statusName ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded Content: Reason
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 16, right: 8),
                  child: Row(
                    children: [
                      const Text(
                        "Reason: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: AppColors.black1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title==AppStrings.app_cancellation_request ? request.ocReasonTitle.toString() :
                          request.requestReason.toString(),
                          style: const TextStyle(
                            color: AppColors.black1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
