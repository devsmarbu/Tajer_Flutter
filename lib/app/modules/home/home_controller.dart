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
import '../../firebase/one_signal_notification.dart';
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
  var isFirstTimeBannerImage = "1";
  RxString firstTimeBannerImageURL = "".obs;
  RxString bannerRedirectURL = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    isLoading(true);
    posts.clear();
    currentPage = 1;
    isLastPage = false;
    currencySymbol.value = _repository.currencyCode;
    await loadNextPage();
    hideLoader(Get.context!);
    isLoading(false);
  }

  Future<void> loadNextPage() async {
    if (isPageLoading || isLastPage) return;

    isPageLoading = true;
    update(); // refresh loader widget

    final newCollections = await _repository.fetchHomePage(currentPage);
    isFirstTimeBannerImage = _repository.isFirstTimeBannerImage;
    firstTimeBannerImageURL.value = _repository.firstTimeBannerImageURL;
    bannerRedirectURL.value = _repository.bannerRedirectURL;
    if (newCollections.isEmpty) {
      isLastPage = true;
    } else {
      posts.addAll(newCollections);
      currentPage++;
    }

    isPageLoading = false;
    update(); // refresh loader widget
  }

  Future<void> setCountry(String countryId, String countryName) async {
    try {
      isLoading(true);
      final response = await _repository.setCountry(countryId, countryName);
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

  Future<String?> addRemoveToWishlist(
    String productId,
    String wishlistId,
    String isInAnyWishlist,
    String collectionLayoutType,
    String productIndex,
  ) async {
    try {
      final response = await _repository.addRemoveToWishList(
        productId,
        wishlistId,
        isInAnyWishlist,
      );
      if (response != null) {
        debugPrint("✅ item add/remove to wishlist");
        updateFav(isInAnyWishlist, collectionLayoutType, productIndex);
        return isInAnyWishlist;
      }
    } catch (e) {
      debugPrint("❌ add/remove wishlist error: $e");
    }
    return null;
  }

  void updateFav(
    String isInAnyWishlist,
    String collectionLayoutType,
    String productIndex,
  ) {
    // 🔁 toggle value
    String newValue = isInAnyWishlist == '0' ? '0' : '1';

    // find matching collection by layoutType
    final int collectionIndex = posts.indexWhere(
          (collection) => collection.collectionId == collectionLayoutType,
    );

    int cIndex = collectionIndex;
    int pIndex = int.parse(productIndex);

    // ✅ update inside posts
    posts[cIndex].products[pIndex] = posts[cIndex].products[pIndex]
        .copyWith(is_in_any_wishlist: newValue);

    posts.refresh(); // 🔥 important for UI update
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {'productId': productId, 'productName': productName},
    );
  }

  @override
  void onClose() {
    // posts.close();
    super.onClose();
  }
}
