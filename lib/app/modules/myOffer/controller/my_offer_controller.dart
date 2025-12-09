import 'dart:convert';
import 'package:get/get.dart';
import 'package:tajer/app/modules/myOffer/models/coupon_data.dart';
import 'package:tajer/app/modules/myOffer/offer_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';

class MyOfferController extends GetxController with OfferApiClient, AppLoader {
  var offers = <CouponsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  /// Load Offers with optional pagination
  Future<void> fetchOffers({bool isInitialLoad = false}) async {
    // Check internet availability
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      return;
    }

    try {
      showLoader(Get.context!); // Show loader

      final response = await getSearchOffersApi();

      dynamic body = response.data;
      if (body is String) {
        body = json.decode(body);
      }

      // Parse response using BaseResponse
      final data = BaseResponse<CouponData>.fromJson(
        body,
        fromJsonT: (json) => CouponData.fromJson(json),
      );

      if (data.responseCode == "200" && data.data != null) {
        offers.assignAll(data.data!.offers ?? []);
      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong");
      }
    } catch (e, stack) {
      AppDialog.showMessage("Error occurred while fetching offers.");
      print('❌ Exception in fetchOffers: $e');
      print(stack);
    } finally {
      hideLoader(Get.context!);
    }
  }
}
