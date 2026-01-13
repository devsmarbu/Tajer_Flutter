import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/Account/sections/quick_action_card.dart';

import '../../../../utils/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/account_controller.dart';

class AccountQuickActions extends StatelessWidget {
  final VoidCallback? onCartTap;
  final AccountController? accountController;

  const AccountQuickActions({
    super.key,
    this.onCartTap,
    this.accountController,
  });

  List<_QuickActionItem> _buildActionItems() {
    return [
      _QuickActionItem(
        title: AppStrings.appMyOrders.tr,
        subtitle: AppStrings.appManageTrack.tr,
        icon: "assets/icons/ic_my_order.svg",
        onTap: () => Get.toNamed(AppRoutes.myOrders,arguments: {'paramId': ''}),
      ),
      _QuickActionItem(
        title: AppStrings.appReturnRequests.tr,
        subtitle: accountController?.returnReqCount.value ?? "",
        icon: "assets/icons/ic_return_request.svg",
        onTap: () => Get.toNamed(
          AppRoutes.returnRequest,
          arguments: {'title': AppStrings.appReturnRequests.tr},
        ),
      ),
      _QuickActionItem(
        title: 'APP_TAJER_CREDITS'.tr,
        subtitle: accountController?.userBalance.value ?? "",
        icon: "assets/icons/ic_credits.svg",
        onTap: () async {
          await Get.toNamed(AppRoutes.walletScreen);

          // 🔄 Refresh Tajer credits after coming back
          accountController?.getProfileInfo();
        },
      ),
      _QuickActionItem(
        title: 'APP_WISHLIST'.tr,
        subtitle: accountController?.userWishListCount.value ?? "",
        icon: "assets/icons/ic_wishlist.svg",
        onTap: () => onCartTap?.call(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Obx(() { // ✅ LISTEN TO RX CHANGES
        final actions = _buildActionItems();

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.7,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];
            return GestureDetector(
              onTap: item.onTap,
              child: QuickActionCard(
                title: item.title,
                subtitle: item.subtitle,
                icon: item.icon,
              ),
            );
          },
        );
      }),
    );
  }

}

class _QuickActionItem {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
