import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/app/data/service/return_request_api_client.dart';
import 'package:tajer/app/modules/return/return_order/model/reason_data.dart';
import 'package:tajer/app/modules/return/return_order/model/resason_item.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/common_data.dart';

import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../returnRequest/models/request_data.dart';

class ReturnOrderController extends GetxController
    with ReturnRequestApiClient, AppLoader {

  // Quantity Dropdown
  final quantities = [1, 2, 3, 4, 5];
  RxInt selectedQty = 1.obs;

  // Corrected
  RxList<ReasonsItem> reasonList = <ReasonsItem>[].obs;

  // From arguments
  RxString optId = ''.obs;
  RxBool isExchange = false.obs;

  // Selected Reason
  Rx<ReasonsItem?> selectedReason = Rx<ReasonsItem?>(null);

  // Image
  Rx<File?> image = Rx<File?>(null);

  // Message
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};

    if (args is Map) {
      optId.value = args[AppParams.optId]?.toString() ?? '';
      isExchange.value = args[AppParams.isExchange] == true;
    }
    returnRequestReason();
  }

  // ----------- VALIDATION -------------
  bool validateFields() {
    if (selectedReason.value == null) {
      AppDialog.showMessage("Please select a reason");
      return false;
    }
    if (messageController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter your message");
      return false;
    }
    if (image.value == null) {
      AppDialog.showMessage("Please upload an image");
      return false;
    }
    return true;
  }

  /// ---------- Submit Return Request -----------
  Future<void> orderExchangeRequest() async {
    if (!validateFields()) return;

    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);


        final response =
        isExchange.value ?
        await orderExchangeRequestApi(
          file: image.value!,
          opId: optId.value,
          oeRQty: selectedQty.value.toString(),
          oeRMessage: messageController.text.trim(),
          returnReasonId: selectedReason.value!.key ?? "",
        ) :
        await orderRequestRequestApi(
          file: image.value!,
          opId: optId.value,
          oeRQty: selectedQty.value.toString(),
          oeRMessage: messageController.text.trim(),
          returnReasonId: selectedReason.value!.key ?? "",
          orRequestType: "2"
        );

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final req = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if (req.responseCode == "200" &&
            req.status == AppConstants.SUCCESS) {
          AppDialog.showMessage("Request Submitted Successfully");
        } else {
          AppDialog.showMessage(req.msg);
        }
      } catch (e) {
        print("❌ Exception: $e");
        AppDialog.showMessage("Something went wrong");
      } finally {
        hideLoader(Get.context!);
      }
    }
  }

  /// Pick Image
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      image.value = File(picked.path);
    }
  }

  /// ---------- Load Return Reasons ----------
  Future<void> returnRequestReason() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = isExchange.value ?
        await getExchangeReasonApi(optId.value):await getReturnReasonApi(optId.value);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final req = BaseResponse<ReasonData>.fromJson(
          body,
          fromJsonT: (data) => ReasonData.fromJson(data),
        );

        hideLoader(Get.context!);

        if (req.responseCode == "200" &&
            req.status == AppConstants.SUCCESS) {
          reasonList.value = req.data?.reasons ?? [];
        } else {
          AppDialog.showMessage(req.msg);
        }

      } catch (e) {
        print("❌ Exception: $e");
        AppDialog.showMessage("Something went wrong");
      } finally {
        hideLoader(Get.context!);
      }
    }
  }
}
