import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/review/rating/model/order_feedback.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/pref_store.dart';

import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_loader.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../review_api_client.dart';

class RatingController extends GetxController with AppLoader ,ReviewApiClient{
  RxInt rating = 0.obs;

  final pref=PrefStore();
  RxString productName = ''.obs;
  RxString orderNumber = ''.obs;
  RxString optId = ''.obs;
  RxString shopName = ''.obs;
  RxString imageUrl = ''.obs;
  RxString orderId = ''.obs;
  RxString productType = ''.obs;
  Rx<OrderFeedback?> orderFeedbackData = Rx<OrderFeedback?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    orderNumber.value = args[AppParams.orderNumber] ?? "";
    optId.value = args[AppParams.optId] ?? "";
    productName.value = args[AppParams.productName] ?? "";
    imageUrl.value = args[AppParams.imageUrl] ?? "";
    shopName.value = args[AppParams.shopName] ?? "";
    productType.value = args[AppParams.productType] ?? "";

    orderFeedbackApi();
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> orderFeedbackApi() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      final response =
      await orderFeedback(optId.value);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<OrderFeedback>.fromJson(
        body,
        fromJsonT: (data) => OrderFeedback.fromJson(data),
      );
      hideLoader(Get.context!);

      if (data.responseCode == "200" &&
          data.status == AppConstants.SUCCESS) {
         orderFeedbackData.value = data.data;

      } else {
        AppDialog.showMessage(data.msg);
      }
      AppDialog.showMessage(data.msg);
    } catch (e) {
      print('❌ Exception in uploadImage: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }
}