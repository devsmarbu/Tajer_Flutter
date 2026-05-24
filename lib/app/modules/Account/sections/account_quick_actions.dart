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
        key: "my_orders",
        title: AppStrings.appMyOrders.tr,
        subtitle: AppStrings.appManageTrack.tr,
        icon: "assets/icons/ic_my_order.svg",
        onTap: () => Get.toNamed(AppRoutes.myOrders,arguments: {'paramId': ''}),
      ),
      _QuickActionItem(
        title: AppStrings.app_pending_request.tr,
        key: "return_requests",
        subtitle: '${'APP_ACTIVE_REQUESTS'.tr} ${accountController?.returnReqCount.value ?? 0}',
        icon: "assets/icons/ic_return_request.svg",
        onTap: () => Get.toNamed(
          AppRoutes.returnRequest,
          arguments: {'title': AppStrings.appReturnRequests.tr},
        ),
      ),
      _QuickActionItem(
        key: "tajer_credits",
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
        key: "wishlist",
        title: 'APP_WISHLIST'.tr,
        subtitle: '${"APP_SAVED_ITEMS".tr} ${accountController?.userWishListCount.value ?? 0}',
        icon: "assets/icons/ic_wishlist.svg",
        onTap: () => onCartTap?.call(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "account_quick_actions_section",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Obx(() { // ✅ LISTEN TO RX CHANGES
          final actions = _buildActionItems();
          final width = MediaQuery.of(context).size.width;
          final bool isFolded = width <= 400;
      
          return GridView.builder(
            key: const ValueKey("quick_actions_grid"),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isFolded ? 2.3 : 2.7,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              return Semantics(
                label: "quick_action_${item.key}",
                button: true,
                child: GestureDetector(
                  key: ValueKey("quick_action_${item.key}"),
                  onTap: item.onTap,
                  child: QuickActionCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

}

class _QuickActionItem {
  final String key;
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  _QuickActionItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
