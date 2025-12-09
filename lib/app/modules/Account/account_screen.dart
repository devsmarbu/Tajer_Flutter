import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/bankInfo/view/bank_info_view.dart';
import 'package:tajer/common/widgets/common_loader.dart';
import '../../../utils/app_params.dart';
import '../../core/routes/app_routes.dart';
import '../../modules/Account/sections/account_quick_actions.dart';
import '../../modules/Account/sections/footer.dart';
import '../../modules/Account/sections/header_name_email.dart';
import '../../modules/Account/sections/profile_header.dart';
import '../../modules/Account/sections/reach_out_section.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import 'controller/account_controller.dart';
import 'models/section.dart';
import 'models/section_item.dart';

class AccountScreen extends StatelessWidget {
  final VoidCallback? onCartTap;

  const AccountScreen({super.key, this.onCartTap});


  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.put(AccountController());
    return Stack(
      children: [
        Scaffold(
          // appBar: AppBar(backgroundColor: AppColors.white,scrolledUnderElevation: 0),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(), // 👈 disables bouncing
            child: Column(
              spacing: 0,
              children: [
                Container(
                  color: AppColors.black1,
                  child: Image.asset(
                    "assets/images/account_header_image.png",
                    height: 160,
                    width: Get.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                ProfileHeader(),
                Container(
                  color: AppColors.colorAccountBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0,
                    ),
                    child: Obx(() {
                      final isLogin = controller.isLogin.value;
                      final sections = controller.currentSections;
                      return Column(
                        children: [
                          if (isLogin) ...[
                            HeaderNameEmail(email:controller.emailId.value,name: controller.userName.value),
                            // const SizedBox(height: 20),
                            AccountQuickActions(onCartTap: onCartTap,accountController: controller,),
                          ] else ...[
                            _SignInButton(onPressed: controller.login),
                          ],
                          const SizedBox(height: 20),
                          ...sections
                              .map((section) => SectionList(section: section)),
                          ReachOutSection(controller: controller),
                          const SizedBox(height: 20),
                          if (isLogin) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: logoutButton(context, controller),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Footer(),
                          const SizedBox(height: 50),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logoutButton(BuildContext context, AccountController controller) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_logout.svg",
        width: 24,
        height: 24,
      ),
      title: Text(
        AppStrings.appLogout.toUpperCase().tr,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.redColor1,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        controller.showLogoutDialog(context);
      },
    );
  }
}

/// Sign in / Join us button
/// Sign in / Join us button
class _SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          "assets/icons/ic_login.svg",
          width: 24,
          height: 24,
          color: Colors.white,
        ),
        label: Text(
          // AppStrings.appJoinUsSignIn.toUpperCase().tr,
          "APP_SIGN_IN_JOIN".tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Section list widget
class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Only show title if it's not empty
        if (section.title.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              section.title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              color: AppColors.colorAccountBackground,
              tiles: section.children
                  .map((item) => buildSectionTile(context, item))
                  .toList(),
            ).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSectionTile(BuildContext context, SectionItem item) {
    return ListTile(
      leading: SvgPicture.asset(
        item.icon,
        width: 24,
        height: 24,
        color: Colors.black,
        semanticsLabel: "${item.title} icon",
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _onSectionItemTap(context, item);
      },
    );
  }

  /// Handle item click actions
  void _onSectionItemTap(BuildContext context, SectionItem item) {
    final controller = Get.find<AccountController>();
    switch (item.key) {
      case AppStrings.appSippingAddress:
        Get.toNamed(AppRoutes.shippingAddress);
        break;

      case AppStrings.appCurrency:
        controller.getCurrency();
       // controller.showCurrencyBottomSheet(context);
        break;
      case 'APP_REQUEST_MY_DATA':
        Get.toNamed(AppRoutes.requestMyDataScreen);
        break;

      case 'APP_CHANGE_EMAIL':
        Get.toNamed(AppRoutes.changeEmail);
        break;

      case 'APP_UPDATE_PHONE':
        Get.toNamed(AppRoutes.updatePhoneNumber,arguments: {
          AppParams.title:AppStrings.appUpdatePhone.toUpperCase().tr,
          AppParams.isUpdate:true
        });
        break;

      case 'APP_CHANGE_PHONE':
        Get.toNamed(AppRoutes.updatePhoneNumber,arguments: {
          AppParams.title:AppStrings.appChangePhone.toUpperCase().tr,
          AppParams.isUpdate:false
        });
        break;

      case 'APP_BANK_INFO':
        final accountController = Get.find<AccountController>();
        BankInfoView.show(accountController);
        break;

      case 'APP_SHARE_EARN':
        controller.openShareAndEarnBottomSheet(context);
        break;

      case AppStrings.appMyRewards:
        Get.toNamed(AppRoutes.myRewards);
        break;

      case AppStrings.appExchangeRequest:
        Get.toNamed(
          AppRoutes.returnRequest,
          arguments: {'title': AppStrings.appExchangeRequest.tr},
        );
        break;

      case AppStrings.appCancellationRequest:
        Get.toNamed(
          AppRoutes.returnRequest,
          arguments: {'title': AppStrings.appCancellationRequest.tr},
        );
        break;

      case 'APP_GIFT_CARD':
        Get.toNamed(AppRoutes.giftCardsList);
        break;

      case 'APP_CHANGE_PASSWORD':
        Get.toNamed(AppRoutes.changePassword);
        break;

        case 'APP_MAKE_SUGGESTION':
        controller.navigateToWebView('APP_MAKE_SUGGESTION'.tr, controller.suggestionLink);
        break;

      case AppStrings.appMessage:
        Get.toNamed(AppRoutes.messageListScreen);
        break;

      case AppStrings.appMyOffers:
        Get.toNamed(AppRoutes.myOfferScreen);
        break;

      case 'APP_LANGUAGE':
        controller.getLanguage();
        break;

      case 'APP_ACCOUNT_DELETE':
        // Get.toNamed(AppRoutes.myOfferScreen);
        controller.showDeleteAccountDialog(context);
        break;

      default:
        debugPrint('Clicked on ${item.title}');
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
