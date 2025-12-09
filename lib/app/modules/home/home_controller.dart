import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/app_params.dart';
import '../../../main_extension.dart';
import '../../../utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/respository/home_respository.dart';
import '../Account/controller/account_controller.dart';
import '../navigation/bottom_navigation.dart';
import 'change_location_view/country_model.dart';
import 'home_model.dart';

class HomeController extends GetxController with AppLoader {
  final _repository = HomeRepository();

  final RxList<Collection> posts = <Collection>[].obs;
  Rxn<CountrySelectModel> countryModel = Rxn<CountrySelectModel>();
  String selectedCountry = "";
  RxString currencySymbol = "".obs;
  int currentPage = 1;
  bool isLastPage = false;
  bool isPageLoading = false;
  final isLoading = false.obs;
  var refreshHome = false.obs;

  @override
  void onInit() {
    super.onInit();

    // 🔥 Listen to bottom tab changes
    ever(Get.find<BottomNavController>().currentIndex, (index) {
      if (index == 0) {
        if (PrefStore().loadBoolean(AppParams.refreshHome) == true) {
          showLoader(Get.context!);
          reloadHomeData();
          PrefStore().saveBoolean(AppParams.refreshHome, false);
        }
      }
    });


    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    isLoading(true);
    posts.clear();
    currentPage = 1;
    isLastPage = false;
    currencySymbol.value = _repository.currencyCode ;
    await loadNextPage();
    hideLoader(Get.context!);
    isLoading(false);
  }

  Future<void> loadNextPage() async {
    if (isPageLoading || isLastPage) return;

    isPageLoading = true;
    update(); // refresh loader widget

    final newCollections = await _repository.fetchHomePage(currentPage);

    if (newCollections.isEmpty) {
      isLastPage = true;
    } else {
      posts.addAll(newCollections);
      currentPage++;
    }

    isPageLoading = false;
    update(); // refresh loader widget

  }


  Future<void> setCountry(String countryId,String countryName) async {
    try {
      isLoading(true);
      final response = await _repository.setCountry(countryId,countryName);
      countryModel.value = response;
      reloadHomeData();
    } catch (e) {
      print("❌ fetch error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> reloadHomeData() async {
    await loadFirstPage();
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {'productId': productId,'productName': productName},
    );
  }

  @override
  void onClose() {
    // posts.close();
    super.onClose();
  }
}