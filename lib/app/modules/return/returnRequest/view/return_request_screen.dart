import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../controller/return_request_controller.dart';
import '../models/request_data.dart';
import '../models/request_item.dart';

class ReturnRequestsScreen extends StatelessWidget {
  final ReturnRequestController controller = Get.put(ReturnRequestController());

  ReturnRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F2F8),
        scrolledUnderElevation: 0,
        title: Text(
          AppStrings.app_pending_request.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      body: Column(
        children: [
          /// 🔥 SEGMENT TABS
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.tabs.length,
              itemBuilder: (_, index) {
                final item = controller.tabs[index];

                final title = (item["title"] ?? '').toString();

                final value = (item["value"] ?? '').toString();

                return Obx(() {
                  final isSelected = controller.selectedFilters.contains(value);

                  return GestureDetector(
                    onTap: () {
                      controller.toggleFilter(value);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.black26,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                            ),
                          ),

                          const SizedBox(width: 6),

                          Icon(
                            isSelected ? Icons.close : Icons.add,
                            size: 16,
                            color: isSelected ? Colors.black : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          /// 🔥 LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (controller.returnRequests.isEmpty) {
                return Center(
                  child: Text(
                    'APP_CAPTION_NO_DATA'.tr,
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                );
              }

              return ListView.separated(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.returnRequests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                // 🔥 spacing
                itemBuilder: (context, index) {
                  final request = controller.returnRequests[index];
                  return ReturnRequestTile(request: request);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ReturnRequestTile extends StatelessWidget {
  final RequestItem request;

  const ReturnRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReturnRequestController>();

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final statusName = request.statusName ?? '';

    final colorCode = request.getStatusColor(
      controller.orderReturnRequestStatusArr,
    );
    final baseColor = hexToColor(colorCode ?? '');

    final dateRequested =
        request.orrequestDate ??
        request.oerequestDate ??
        request.ocrequestDate ??
        '';

    final formattedRequestedDate = AppFunction.getDateFormat(
      dateRequested,
      "d, MMM, hh:mm a",
    );

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        String requestId = '';
        String title = '';

        debugPrint(request.orrequestType);
        if (request.orrequestId != null &&
            request.orrequestId.toString().isNotEmpty &&
            request.request_type == 'missing') {
          requestId = request.orrequestId.toString();
          title = 'APP_MISSING_REQUEST_DETAIL'.tr;
        } else if (request.orrequestId != null &&
            request.orrequestId.toString().isNotEmpty) {
          requestId = request.orrequestId.toString();
          title = 'APP_RETURN_REQUEST_DETAILS'.tr;
        } else if (request.oeRequestId != null &&
            request.oeRequestId.toString().isNotEmpty) {
          requestId = request.oeRequestId.toString();
          title = 'APP_EXCHANGE_REQUEST_DETAILS'.tr;
        } else if (request.ocrequest_id != null &&
            request.ocrequest_id.toString().isNotEmpty) {
          requestId = request.ocrequest_id.toString();
          title = 'APP_CANCEL_REQUEST_DETAIL'.tr;
        }
        Get.toNamed(
          AppRoutes.returnRequestDetail,
          arguments: {'requestId': requestId, 'title': title},
        );
      },
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 TOP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// STATUS
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: isRTL
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          end: isRTL
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          colors: [
                            baseColor.withOpacity(0),
                            baseColor.withOpacity(0),
                            baseColor.withOpacity(0.05),
                            baseColor.withOpacity(0.1),
                            baseColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Text(
                        statusName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// DATE
                  Text(
                    "${'APP_ON'.tr} $formattedRequestedDate",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// 🔥 CONTENT
              Row(
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      request.productImageUrl ?? "",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          request.selprodTitle ?? "-",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Nunito',
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// OPTIONS
                        if ((request.opSelprodOptions ?? '').isNotEmpty)
                          Text(
                            request.opSelprodOptions ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Nunito',
                              color: Colors.black54,
                            ),
                          ),

                        const SizedBox(height: 6),

                        /// ORDER NUMBER
                        Text(
                          "${'APP_ORDER_NO'.tr} ${request.opInvoiceNumber}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right, color: Colors.black54),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return Colors.grey;
    }

    hex = hex.replaceAll("#", "");

    try {
      /// API FORMAT = RRGGBBAA
      if (hex.length == 8) {
        final rgb = hex.substring(0, 6);

        return Color(int.parse("FF$rgb", radix: 16));
      }

      /// RRGGBB
      if (hex.length == 6) {
        return Color(int.parse("FF$hex", radix: 16));
      }

      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}
