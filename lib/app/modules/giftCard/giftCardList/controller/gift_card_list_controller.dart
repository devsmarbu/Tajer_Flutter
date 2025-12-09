import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/giftCard/giftCardList/models/gift_model.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/routes/app_routes.dart';
import '../../gift_card_api_client.dart';

class GiftCardListController extends GetxController with GiftCardApiClient {
  var giftCards = <GiftCard>[].obs;
  var statusList = <String>[].obs;
  var statusPaymentList = <String>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  String filterKeyword = "";
  String filterStatus = "";
  String filterPaymentStatus = "";

  int currentPage = 1;
  int totalPages = 1;
  bool hasMore = true;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadGiftCards(isInitialLoad: true);
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void addGiftCard(String card) async {
    final result = await Get.toNamed(AppRoutes.addGiftCard);
    if (result == true) {
      refreshGiftCards();
    }
  }

  /// Refresh (Pull to refresh or Add new)
  void refreshGiftCards() {
    currentPage = 1;
    hasMore = true;
    giftCards.clear();
    loadGiftCards(isInitialLoad: true);
  }

  void applyFilters({
    required String keyword,
    required String status,
    required String paymentStatus,
  }) {
    filterKeyword = keyword;
    filterStatus = status;
    filterPaymentStatus = paymentStatus;

    currentPage = 1;
    hasMore = true;
    giftCards.clear();

    loadGiftCards(isInitialLoad: true);
  }

  /// Load Gift Cards with pagination
  Future<void> loadGiftCards({bool isInitialLoad = false}) async {
    if (isLoading.value || isLoadingMore.value || !hasMore) return;

    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      return;
    }

    try {
      if (isInitialLoad) {
        isLoading(true);
      } else {
        isLoadingMore(true);
      }

      final response = await searchGiftCardsApi(filterKeyword,
        currentPage,
        filterStatus,
        filterPaymentStatus,);
      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<GiftModel>.fromJson(
        body,
        fromJsonT: (json) => GiftModel.fromJson(json),
      );

      if (data.responseCode == "200") {
        final newCards = data.data?.giftCards ?? [];
        final pageCount = int.tryParse(data.data?.pageCount ?? '1') ?? 1;

        if (currentPage == 1) {
          giftCards.assignAll(newCards);
          statusList.assignAll(data.data?.useStatusArr ??[]);
          statusPaymentList.assignAll(data.data?.orderPaymentStatusArr ??[]);
        } else {
          giftCards.addAll(newCards);
        }

        totalPages = pageCount;
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
      AppDialog.showMessage("Error occurred while fetching gift cards.");
      print('❌ Exception in loadGiftCards: $e');
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  /// Detect scroll to bottom
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore.value &&
        hasMore) {
      loadGiftCards();
    }
  }

  void clearAllFilters() {
    filterKeyword = "";
    filterStatus = "";
    filterPaymentStatus = "";

    currentPage = 1;
    hasMore = true;
    giftCards.clear();

    loadGiftCards(isInitialLoad: true);
  }
}
