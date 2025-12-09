import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wallet/myWallet/models/credit_listing_item.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../redeem_gift_card/redeem_gift_card.dart';
import '../controller/wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.appWallet.toUpperCase().tr,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.black1,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: OutlinedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierLabel: AppStrings.appRedeemGiftCard.toUpperCase().tr,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.4),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, __, ___) => RedeemGiftCard(controller: controller),
                  transitionBuilder: (_, anim, __, child) {
                    return SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      ),
                      child: child,
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              child: Text(
                AppStrings.appRedeemGiftCard.toUpperCase().tr,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Nunito",
                  color: AppColors.black1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),

      /// 🟢 Main Body
      body: Obx(() {
        return Container(
          color: AppColors.colorAccountBackground,
          child: Column(
            children: [
              // ✅ Balance Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _balanceItem(
                      AppStrings.appAvailableBalance.toUpperCase().tr,
                      '${controller.currencySymbol.value} ${controller.availableBalance.value.toStringAsFixed(2)}',
                    ),
                    _balanceItem(
                      AppStrings.appBtnWithdraw.toUpperCase().tr,
                      '${controller.currencySymbol.value} ${controller.withdrawalRequest.value.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ✅ Withdraw & Add Money Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(controller.pref.loadString(AppConstants.confEnableWithdrawals)=="1")
                  _walletButton(
                      AppStrings.appWithdraw.toUpperCase().tr, Icons.account_balance_wallet_outlined,controller),
                  const SizedBox(width: 20),
                  _walletButton(
                      '+ ${AppStrings.appAddMoney.toUpperCase().tr}', Icons.add_card_outlined,controller),
                ],
              ),

              const SizedBox(height: 20),

              // ✅ Tabs
              Container(
                color: Colors.grey.shade100,
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabButton(AppStrings.appAll.toUpperCase().tr, 0, controller),
                    _tabButton(AppStrings.appCredit.toUpperCase().tr, 1, controller),
                    _tabButton(AppStrings.appDebit.toUpperCase().tr, 2, controller),
                  ],
                )),
              ),

              const Divider(height: 1),

              // ✅ Transactions List
              Expanded(
                child: Obx(() {
                  if (controller.creditsListingItem.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.appNoTransactionsAvailable.tr,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                          !controller.isLoadingMore.value &&
                          !controller.isLastPage.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.creditsListingItem.length,
                      itemBuilder: (context, index) {
                        final tx = controller.creditsListingItem[index];
                        return _transactionCard(tx);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 🟩 Balance widget
  Widget _balanceItem(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(amount,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// 🟦 Withdraw/Add Money Button
  Widget _walletButton(String title, IconData icon, WalletController controller) {
    return ElevatedButton.icon(
      onPressed: () {
        if (title == '+ ${AppStrings.appAddMoney.toUpperCase().tr}') {
          Get.toNamed(AppRoutes.addMoneyScreen, arguments: {
            AppParams.walletBalance: controller.availableBalance.value,
            AppParams.displayUserBalance: controller.displayUserBalance,
            AppParams.currencySymbol: controller.currencySymbol,
           // AppParams.withdrawType: controller.withdrawType,
          });
        } else if (title == AppStrings.appWithdraw.toUpperCase().tr) {
          controller.payout();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(title),
    );
  }

  /// 🟨 Tab Button
  Widget _tabButton(String title, int index, WalletController controller) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 🟥 Transaction Card
  Widget _transactionCard(CreditsListingItem creditData) {
    final isCredit = (creditData.utxnType?.toLowerCase() == 'credit');
 //   final amount = double.tryParse(tx.utxnAmount ?? '0') ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle,
                      //  color: isCredit ? Colors.green : Colors.red,
                        color: Colors.green,
                        size: 18),
                    const SizedBox(width: 6),
                    Text(
                      PrefStore().loadString(AppConstants.languageCode) == "AR" ?
                      (isCredit ? 'المبلغ المعتمد' : 'المبلغ المدين') : (isCredit ? 'Amount Credited' : 'Amount Debited'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  AppFunction.getDateFormat(creditData.utxnDate ?? '', "dd-MMM-yyyy, HH:mm"),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              creditData.utxnComments ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 6),
            Text(
              creditData.balance.toString(),
              style: TextStyle(
                color: isCredit ? Colors.green : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
