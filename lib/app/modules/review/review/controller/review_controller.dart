import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/app/modules/review/review_api_client.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_loader.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/common_data.dart';
import '../../../../core/constants/app_constants.dart';
import '../../rating/model/order_feedback.dart';

class ReviewController extends GetxController with AppLoader, ReviewApiClient {
  final ImagePicker picker = ImagePicker();

  RxList<File> selectedImages = <File>[].obs;
  final pref = PrefStore();

  RxString title = ''.obs;
  RxString description = ''.obs;
  RxBool isAgreed = false.obs;

  RxString productName = ''.obs;
  RxString optId = ''.obs;
  RxString imageUrl = ''.obs;
  RxString productType = ''.obs;
  RxString productRating = ''.obs;
  Rx<OrderFeedback?> orderFeedbackData = Rx<OrderFeedback?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    optId.value = args[AppParams.optId] ?? "";
    productName.value = args[AppParams.productName] ?? "";
    imageUrl.value = args[AppParams.imageUrl] ?? "";
    orderFeedbackData.value = args[AppParams.orderFeedback] as OrderFeedback?;
    productType.value = args[AppParams.productType] ?? "";
    productRating.value = args[AppParams.productRating] ?? "";
  }

  /// Pick Image and Add to List
  Future<void> pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      selectedImages.add(File(picked.path));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitOrderFeedback(OrderFeedback? feedback) async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      /// Build PartMap (HashMap<String, RequestBody>)
      Map<String, dynamic> map = {
        "op_id": optId.value ?? "",
        "spreview_title": title ?? "",
        "spreview_description": description ?? "",
        "review_rating[1]": productRating.value,
      };

      /// Add dynamic ratings
      // if (feedback?.otherRating != null) {
      //   for (var item in feedback?.otherRating!) {
      //     map["review_rating[${item.id}]"] = item.rating ?? "";
      //   }
      // }

      /// Image list to send
      List<String> imageList = feedback?.imgArray ?? [];

      /// API request through mixin method
      final response = await orderFeedbackApiRequest(map, imageList);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (json) => CommonData.fromJson(json),
      );

      hideLoader(Get.context!);

      if (data.status == AppConstants.SUCCESS) {

        Get.back(result: true);
        Get.back(result: true);
       // AppDialog.showMessage(data.msg);
      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
      print("❌ Error submitting feedback: $e");
    } finally {
      hideLoader(Get.context!);
    }
  }

}

