import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/home_respository.dart';
import 'package:tajer/app/modules/home/change_location_view/country_model.dart';
import '../../../core/routes/app_routes.dart';

class ChangeLocationController extends GetxController {
  final _repository = HomeRepository();
  var isLoading = true.obs;
  Rxn<CountryModel> countryModel = Rxn<CountryModel>();
  var listId = "";
  var searchText = "".obs;

  @override
  void onInit() {
    super.onInit();

    // 🔥 Debounce: wait 500 ms after user stops typing
    debounce(searchText, (_) => fetchCountriesBySearch(searchText.value),
        time: const Duration(milliseconds: 500));
  }

  Future<void> fetchCountriesBySearch(String keyword) async {
    if (keyword.trim().isEmpty) return;

    try {
      isLoading(true);
      final response = await _repository.getCountriesBySearch(keyword);
      countryModel.value = response;
    } catch (e) {
      print("❌ fetch error: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    final params = Get.parameters;
    debugPrint("Received Params: $params");

    if (params.isNotEmpty) {
      if (params['listId'] != null) {
        listId = params['listId']!;
      }
    }
  }

  void resetSearch() {
    searchText.value = "";
    countryModel.value = null;
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {'productId': productId, 'productName': productName},
    );
  }

}
