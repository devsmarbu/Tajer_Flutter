import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/review/review/view/write_review_screen.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../../../utils/app_params.dart';
import '../controller/rating_controller.dart';

class RatingScreen extends StatelessWidget {

  final RatingController controller = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.appRateYourProduct.toUpperCase().tr,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          SizedBox(height: 40),

          /// PRODUCT IMAGE
          Obx(
            () => Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  controller.imageUrl.value,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.image, size: 50),
                ),
              ),
            ),
          ),

          SizedBox(height: 70),

          /// PRODUCT NAME
          Obx(
            () => Text(
              controller.productName.value,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: 100,
            height: 2,
            margin: EdgeInsets.only(top: 5),
            color: Colors.black,
          ),

          SizedBox(height: 100),

          /// STAR RATING
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => controller.setRating(index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: index < controller.rating.value
                          ? Color(0xffE89A29)
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              }),
            );
          }),

          Expanded(child: Container()),

          /// BUTTON ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        side: BorderSide(color: Colors.black),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        AppStrings.appCancel.toUpperCase().tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 15),

                  /// NEXT BUTTON (REACTIVE)
                  if (controller.rating.value > 0)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {

                          Get.to(() => WriteReviewScreen(), arguments: {
                            AppParams.optId: controller.optId.value,
                            AppParams.imageUrl: controller.imageUrl.value,
                            AppParams.productName: controller.productName.value,
                            AppParams.productType: controller.productType.value,
                            AppParams.orderFeedback: controller.orderFeedbackData.value,
                            AppParams.productRating: controller.rating.value.toString(),
                          });

                        },
                        child: Text(
                          AppStrings.appNext.toUpperCase().tr,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
