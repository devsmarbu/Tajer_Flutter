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
import 'package:tajer/app/modules/orders/orderDetail/models/order_detail.dart';
import '../../../orders/orderDetail/models/child_order_detail_item.dart';

class ReturnOrderController extends GetxController
    with ReturnRequestApiClient, AppLoader {

  // ---------------- Quantity ----------------
  RxInt selectedQty = 1.obs;

  // ---------------- Reasons -----------------
  RxList<ReasonsItem> reasonList = <ReasonsItem>[].obs;
  Rx<ReasonsItem?> selectedReason = Rx<ReasonsItem?>(null);

  // ---------------- Arguments ----------------
  RxString optId = ''.obs;
  RxString returnType = ''.obs;
  String? quantity;
  ChildOrderDetailItem? childOrderDetail;
  OrderDetail? orderDetail;

  // ---------------- Image -------------------
  Rx<File?> image = Rx<File?>(null);

  // ---------------- Message -----------------
  final TextEditingController messageController = TextEditingController();

  // ---------------- Getter ------------------
  /// Image required only if backend sends isImageRequired = "1"
  bool get isImageRequired {
    return selectedReason.value?.isImageRequired == "1";
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    if (args is Map) {
      optId.value = args[AppParams.optId]?.toString() ?? '';
      returnType.value = args[AppParams.returnType]?.toString() ?? '';
      quantity = args['quantity']?.toString();

      final data = args['orderDetail'];

      if (data is ChildOrderDetailItem) {
        childOrderDetail = data;
      } else if (data is OrderDetail) {
        /// 👇 convert OrderDetail → ChildOrderDetailItem (adjust mapping)
        orderDetail = data;
      }
      debugPrint('this is product title');
    }

    returnRequestReason();
  }

  // ---------------- VALIDATION ----------------
  bool validateFields() {
    if (returnType.value != AppConstants.missing &&
        selectedReason.value == null) {
      AppDialog.showMessage("APP_SELECT_REASON".tr);
      return false;
    }

    if (messageController.text.trim().isEmpty) {
      AppDialog.showMessage("APP_PLEASE_ENTER_MESSAGE".tr);
      return false;
    }

    // ✅ Image validation only when required
    if (isImageRequired && image.value == null) {
      AppDialog.showMessage('APP_PLEASE_UPLOAD_AN_IMAGE'.tr);
      return false;
    }

    return true;
  }

  // ---------------- SUBMIT REQUEST ----------------
  Future<void> orderExchangeRequest() async {
    if (!validateFields()) return;

    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        // ✅ Decide file safely
        File? uploadFile = isImageRequired ? image.value : null;

        final response =
        returnType.value == AppConstants.exchange
            ? await orderExchangeRequestApi(
          file: uploadFile,
          opId: optId.value,
          oeRQty: selectedQty.value.toString(),
          oeRMessage: messageController.text.trim(),
          returnReasonId: selectedReason.value?.key ?? "",
        )
            : returnType.value == AppConstants.returnOrder
            ? await orderRequestRequestApi(
          file: uploadFile,
          opId: optId.value,
          oeRQty: selectedQty.value.toString(),
          oeRMessage: messageController.text.trim(),
          returnReasonId:
          selectedReason.value?.key ?? "",
          orRequestType: "2",
        )
            : await orderMissingRequestApi(
          opId: optId.value,
          qty: selectedQty.value.toString(),
          msg: messageController.text.trim(),
          returnReasonId:
          reasonList.isNotEmpty
              ? reasonList.first.key ?? ""
              : "",
          orRequestType: "2",
        );

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final req = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if (req.status == '0') {
          hideLoader(Get.context!);
          Get.snackbar(AppConstants.appName, req.msg);
        }
        else {
          hideLoader(Get.context!);
          Get.back();
          Get.snackbar(AppConstants.appName, req.msg);
        }

      } catch (e) {
        hideLoader(Get.context!);
        debugPrint("❌ APIo Errr: $e");
        AppDialog.showMessage("Something went wrong");
      }
    }
  }


  // ---------------- IMAGE PICKER ----------------
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      image.value = File(picked.path);
    }
  }


  // ---------------- LOAD REASONS ----------------
  Future<void> returnRequestReason() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      final response =
      returnType.value == AppConstants.exchange
          ? await getExchangeReasonApi(optId.value)
          : returnType.value == AppConstants.returnOrder
          ? await getReturnReasonApi(optId.value)
          : await getMissingReasonApi(optId.value);

      hideLoader(Get.context!);

      // ---------------- RAW BODY ----------------
      dynamic body = response.data;
      if (body is String) {
        body = json.decode(body);
      }

      debugPrint("✅ REASON API RESPONSE: $body");

      // ---------------- BASE RESPONSE ----------------
      final base = BaseResponse.fromJson(body);

      if (base.responseCode == "200" &&
          base.status == AppConstants.SUCCESS) {

        final data = base.data;

        // ---------------- HANDLE BOTH SHAPES ----------------
        if (data is List) {
          // Case: data = [ {reason}, {reason} ]
          reasonList.value = data
              .map((e) => ReasonsItem.fromJson(e))
              .toList();
        } else if (data is Map<String, dynamic>) {
          // Case: data = { reasons: [...] }
          final reasonData = ReasonData.fromJson(data);
          reasonList.value = reasonData.reasons ?? [];
        } else {
          reasonList.clear();
          debugPrint("⚠️ Unknown data format: ${data.runtimeType}");
        }
      } else {
        AppDialog.showMessage(base.msg ?? "Failed to load reasons");
      }
    } catch (e, s) {
      hideLoader(Get.context!);
      debugPrint("❌ returnRequestReason ERROR: $e");
      debugPrint("❌ STACKTRACE: $s");
      AppDialog.showMessage("Something went wrong");
    }
  }


  String get calculatedPriceWithCurrency {
    // 🔹 Raw total (for extracting currency symbol)
    final raw =
        childOrderDetail?.totalAmount?.value ??
            orderDetail?.opTotalPrice ??
            "";

    // 🔹 Extract currency symbol
    final currency = raw.replaceAll(RegExp(r'[0-9.,]'), '').trim();

    // 🔹 Get unit price (may contain currency)
    final unitPriceRaw =
        childOrderDetail?.op_unit_price ??
            orderDetail?.opUnitPrice ??
            "0";

    // 🔥 Remove currency from unit price
    final unitPriceClean =
    unitPriceRaw.replaceAll(RegExp(r'[^\d.]'), '');

    final unitPrice = double.tryParse(unitPriceClean) ?? 0.0;

    final total = unitPrice * selectedQty.value;

    return "$currency${total.toStringAsFixed(2)}";
  }

  // ---------------- CLEANUP ----------------
  void onReasonChanged(ReasonsItem? reason) {
    selectedReason.value = reason;

    // ✅ Clear image if not required
    if (reason?.isImageRequired != "1") {
      image.value = null;
    }
  }
}
