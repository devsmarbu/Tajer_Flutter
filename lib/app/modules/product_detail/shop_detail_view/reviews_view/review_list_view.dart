import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/Cart/MainCartView.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/reviews_view/shop_review_model.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_detail_controller.dart';

import '../../../../../../utils/app_colors.dart';

class ReviewListView extends StatelessWidget {
  var reviewList = <ReviewsList>[].obs;
  final controller = Get.put(ShopDetailController());
  ReviewListView({super.key, required this.reviewList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final reviewList = controller.reviews;
        if (reviewList.isEmpty) {
          return const Center(
            child: EmptyCartWidget(
              imagePath: "assets/images/no_data_image.png",
              message: "No data found",
              imageSize: 200,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviewList.length,
          itemBuilder: (context, index) =>
              _buildReviewCard(reviewList[index]),
        );
      }),
    );
  }

  Widget _buildReviewCard(ReviewsList review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Profile Row ---
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName ?? "",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    review.spreviewPostedOn ?? "",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- Review Title ---
          Text(
            review.spreviewTitle ?? "",
            style: const TextStyle(
              fontFamily: "Nunito",
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          // --- Review Message ---
          Text(
            review.spreviewDescription ?? "",
            style: const TextStyle(
              fontFamily: "Nunito",
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.lightGrey),

          const SizedBox(height: 15),

          // --- Shop Rating Tag ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Shop",
                  style: TextStyle(fontFamily: "Nunito", fontSize: 14),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 3),
                Text(
                  "${review.shopRating.toIntSafe()}",
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // --- Like / Dislike Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                controller.markReviewHelpful(isHelpful: '1', reviewId: review.spreviewId ?? "");
                },
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      review.helpful.toString(),
                      style: const TextStyle(fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  controller.markReviewHelpful(isHelpful: '0', reviewId: review.spreviewId ?? "");
                },
                child: Row(
                  children: [
                    const Icon(Icons.thumb_down_alt_outlined, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      review.notHelpful.toString(),
                      style: const TextStyle(fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
