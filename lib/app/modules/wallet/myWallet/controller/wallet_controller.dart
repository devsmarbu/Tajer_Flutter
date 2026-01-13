import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wallet/myWallet/models/transaction_data.dart';
import 'package:tajer/app/modules/wallet/myWallet/models/wallet_payout.dart';
import 'package:tajer/app/modules/wallet/wallet_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/common_data.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../models/credit_listing_item.dart';
import '../models/payout_plugin.dart';

class WalletController extends GetxController with WalletApiClient, AppLoader {

  /// Payout method IDs
  static const int BANK_TRANSFER = 5659;
  static const int PAYPAL = 9;

  var availableBalance = 0.0.obs;
  var withdrawalRequest = 0.0.obs;
  var currencySymbol = ''.obs;
  var selectedTab = 0.obs; // 0 = All, 1 = Credit, 2 = Debit
  var displayUserBalance='';
  var pref=PrefStore();
  /// Pagination variables
  var currentPage = 1.obs;
  var isLastPage = false.obs;
  var isLoadingMore = false.obs;
  final payoutPlugin = <PayoutPlugin>[].obs;

  /// Transactions
  var creditsListingItem = <CreditsListingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCreditSearch(currentPage.value.toString());
  }

  /// Handle tab change
  void changeTab(int index) {
    selectedTab.value = index;

    // Reset pagination when tab changes
    currentPage.value = 1;
    isLastPage.value = false;
    creditsListingItem.clear();

    // Fetch data for the new tab
    getCreditSearch(currentPage.value.toString());
  }

  /// Fetch wallet transactions
  Future<void> getCreditSearch(String page) async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        if (currentPage.value == 1) {
          // Show loader only for first page
          showLoader(Get.context!);
        } else {
          isLoadingMore.value = true;
        }

        final int type = getTabType();
        print('📡 Fetching page=$page, type=$type');

        final response = await getCreditSearchApi(page, type);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<TransactionData>.fromJson(
          body,
          fromJsonT: (jsonData) => TransactionData.fromJson(jsonData),
        );

        if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {
          currencySymbol.value=data.data!.currencySymbol.toString();
          final newList = data.data?.creditsListing ?? [];

          if (newList.isEmpty) {
            isLastPage.value = true;
          } else {
            // Append new data
            creditsListingItem.addAll(newList);
          }

          // ✅ Update wallet balance and withdrawal info if available
          availableBalance.value =
              double.tryParse(data.data?.userWalletBalance ?? '0') ?? 0.0;
          withdrawalRequest.value =
              double.tryParse(data.data?.withdrawlRequestAmount ?? '0') ?? 0.0;
          displayUserBalance=data.data?.displayUserWalletBalance ?? '';

        } else {
          AppDialog.showMessage(data.msg ?? 'Something went wrong');
        }
      } catch (e) {
        print('❌ Exception in getCreditSearch: $e');
      } finally {
        if (currentPage.value == 1) hideLoader(Get.context!);
        isLoadingMore.value = false;
      }
    }
  }


  Future<void> payout() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await payoutsApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<WalletPayout>.fromJson(
          body,
          fromJsonT: (jsonData) => WalletPayout.fromJson(jsonData),
        );

        if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {
          final plugins = data.data?.payoutPlugins ?? [];

          if (plugins.isEmpty) {
            // No payout options — go straight to Withdraw Request
            moveToWithdrawRequestScreen(AppParams.bankWithdraw);
          }else{
            // ✅ Update observable list safely
            payoutPlugin.assignAll(plugins);
            withdrawRequestPopup(Get.context!,plugins, availableBalance.value, displayUserBalance);
          }


        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in payout: $e');
      } finally {
        hideLoader(Get.context!);
        isLoadingMore.value = false;
      }
    }
  }

  void moveToWithdrawRequestScreen(String withdrawType) async {
    // Navigate safely using GetX routing

    await Future.delayed(const Duration(milliseconds: 300));

    Get.toNamed(
      AppRoutes.withdrawRequestScreen,
      arguments: {
        AppParams.walletBalance: availableBalance.value,
        AppParams.displayUserBalance: displayUserBalance,
        AppParams.currencySymbol: currencySymbol,
        AppParams.withdrawType: withdrawType,
      },
    )?.then((result) {
      // When coming back from withdraw screen, refresh if needed
      if (result == true) {
        refreshPage();
      }
    });
  }


  Future<void> redeemGiftCard(String code) async {

    if (await AppFunction.isInternetAvailable()) {
      try {

        final response = await redeemGiftCardApi(code);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (jsonData) => CommonData.fromJson(jsonData),
        );

        if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {

          Get.snackbar(AppConstants.appName, data.msg);
          refreshPage();
          //refresh();

        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in getCreditSearch: $e');
      } finally {
        if (currentPage.value == 1) hideLoader(Get.context!);
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshPage() async {
    currentPage.value = 1;
    isLastPage.value = false;
    creditsListingItem.clear();
    await getCreditSearch(currentPage.value.toString());
  }

  /// Determine tab type for API param
  int getTabType() {
    if (selectedTab.value == 0) {
      return -1; // All
    } else if (selectedTab.value == 1) {
      return 1; // Credit
    } else {
      return 2; // Debit
    }
  }

  /// Load next page (for infinite scroll)
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLastPage.value) return;

    currentPage.value += 1;
    await getCreditSearch(currentPage.value.toString());
  }

  void withdrawRequestPopup(BuildContext context, List<PayoutPlugin> list, double walletBalance, String displayWalletBalance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Withdraw", // replace with getValueForKey("app_btn_withdraw")
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // List of payout methods
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final plugin = list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(plugin.pluginName),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          Get.back();
                          // Delay navigation slightly to ensure bottom sheet closes completely
                          await Future.delayed(const Duration(milliseconds: 300));

                          // Use GetX navigation directly (without relying on Get.context!)
                          if (plugin.pluginId == BANK_TRANSFER) {
                            Get.toNamed(
                              AppRoutes.withdrawRequestScreen,
                              arguments: {
                                AppParams.walletBalance: walletBalance,
                                AppParams.displayUserBalance: displayWalletBalance,
                                AppParams.withdrawType: AppParams.bankWithdraw,
                              },
                            )?.then((result) {
                              if (result == true) {
                                refreshPage();
                              }
                            });
                          } else if (plugin.pluginId == PAYPAL) {
                            Get.toNamed(
                              AppRoutes.withdrawRequestScreen,
                              arguments: {
                                AppParams.walletBalance: walletBalance,
                                AppParams.displayUserBalance: displayWalletBalance,
                                AppParams.withdrawType: AppParams.paypalWithdraw,
                              },
                            )?.then((result) {
                              if (result == true) {
                                refreshPage();
                              }
                            });
                          }
                        },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
