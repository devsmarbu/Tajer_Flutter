import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/bankInfo/view/bank_info_view.dart';
import 'package:tajer/common/widgets/common_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../utils/app_params.dart';
import '../../core/routes/app_routes.dart';
import '../../modules/Account/sections/account_quick_actions.dart';
import '../../modules/Account/sections/footer.dart';
import '../../modules/Account/sections/header_name_email.dart';
import '../../modules/Account/sections/profile_header.dart';
import '../../modules/Account/sections/reach_out_section.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../address/addressList/view/address_list_screen.dart';
import 'controller/account_controller.dart';
import 'models/section.dart';
import 'models/section_item.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback? onCartTap;

  const AccountScreen({super.key, this.onCartTap});

  Widget logoutButton(BuildContext context, AccountController controller) {
    return Semantics(
      label: "logout_button",
      button: true,
      child: ListTile(
        key: const ValueKey("logout_tile"),
        leading: SvgPicture.asset(
          "assets/icons/ic_logout.svg",
          width: 24,
          height: 24,
        ),
        title: Text(
          key: const ValueKey("logout_text"),
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
      ),
    );
  }

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountController controller = Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.token = PrefStore().loadString(AppConstants.sessionToken) ?? "";
    if (controller.token == "") {
      controller.isLogin.value = false;
      if (!deepLinkURL.contains('/guest-user/user-check-email-verification')) {
        controller.getAgreementUrl();
      }
    } else {
      controller.isLogin.value = true;
      controller.getProfileInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      "assets/images/account_header_image.png",
                      height: 220,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),

                    Obx(() {
                      final membership = controller.memberShipInfo.value;

                      if (membership == null ||
                          (membership.membershipType.isEmpty)) {
                        return const SizedBox();
                      }
                      final type =
                          controller.memberShipInfo.value?.membershipType;

                      // final m = controller.memberShipInfo.value;

                      // double progress = 0.0;
                      // if (m != null) {
                      //   final used = double.tryParse(m.discountLimitRemaining ?? "0") ?? 0;
                      //   final total = double.tryParse(m.discountLimitRemainingFormatted ?? "0") ?? 0;
                      //
                      //   if (total > 0) {
                      //     progress = used / total;
                      //   }
                      // }

                      return Positioned(
                        left: 16,
                        right: 16,
                        top: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                /// Background
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/img_profile_header.svg",
                                          fit: BoxFit.cover,
                                        ),
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 10,
                                            sigmaY: 10,
                                          ),
                                          child: Container(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Spark icon
                                Positioned(
                                  top: 10,
                                  right: 44,
                                  child: Image.asset(
                                    "assets/images/ic_spark.png",
                                    height: 16,
                                  ),
                                ),

                                /// Content
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        16,
                                        16,
                                        20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 14),

                                          /// ✅ Dynamic text
                                          Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0x33FFD24C),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "Enjoy ${controller.memberShipInfo.value?.membershipDiscount ?? ""} ",
                                                      style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          type != null &&
                                                              type.isNotEmpty
                                                          ? "For $type Members"
                                                          : "",
                                                      style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 18),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Offer Claims For This Month",
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF939393),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "${controller.membershipUsed.value} / "
                                                "${controller.membershipTotal.value}",
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: LinearProgressIndicator(
                                                  value: controller
                                                      .membershipProgress
                                                      .value
                                                      .clamp(0.0, 1.0),
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.white12,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xFFF2C94C)),
                                                ),
                                              ),
                                            ],
                                          ),

                                          /// (keep your progress UI here)
                                        ],
                                      ),
                                    ),

                                    Image.asset(
                                      "assets/images/img_star.png",
                                      height: 70,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                // Stack(
                //   children: [
                //     Image.asset(
                //       "assets/images/account_header_image.png",
                //       height: 160,
                //       width: Get.width,
                //       fit: BoxFit.fitWidth,
                //     ),
                //   ],
                // ),
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
                            HeaderNameEmail(
                              email: controller.emailId.value,
                              name: controller.userName.value,
                              controller: controller,
                            ),
                            // const SizedBox(height: 20),
                            AccountQuickActions(
                              onCartTap: widget.onCartTap,
                              accountController: controller,
                            ),
                          ] else ...[
                            _SignInButton(onPressed: controller.login),
                          ],
                          const SizedBox(height: 20),
                          ...sections.map(
                            (section) => SectionList(section: section),
                          ),
                          ReachOutSection(controller: controller),
                          const SizedBox(height: 20),
                          if (isLogin) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: widget.logoutButton(context, controller),
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
}

/// Sign in / Join us button
/// Sign in / Join us button
class _SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "sign_in_button",
      button: true,
      child: SizedBox(
        key: const ValueKey("sign_in_button"),
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
            key: const ValueKey("sign_in_text"),
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
    return Semantics(
      label: "section_${item.key}",
      button: true,
      child: ListTile(
        key: ValueKey("section_tile_${item.key}"),
        leading: SvgPicture.asset(
          item.icon,
          width: 24,
          height: 24,
          color: Colors.black,
          semanticsLabel: "${item.title} icon",
        ),
        title: Text(
          key: ValueKey("title_${item.key}"),
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
      ),
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
        Get.toNamed(
          AppRoutes.updatePhoneNumber,
          arguments: {
            AppParams.title: AppStrings.appUpdatePhone.toUpperCase().tr,
            AppParams.isUpdate: true,
          },
        );
        break;

      case 'APP_CHANGE_PHONE':
        Get.toNamed(
          AppRoutes.updatePhoneNumber,
          arguments: {
            AppParams.title: AppStrings.appChangePhone.toUpperCase().tr,
            AppParams.isUpdate: false,
          },
        );
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
        controller.navigateToWebView(
          'APP_MAKE_SUGGESTION'.tr,
          controller.suggestionLink,
        );
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
