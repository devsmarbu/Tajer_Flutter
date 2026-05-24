import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/Account/controller/account_controller.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../utils/app_params.dart';
import 'contract_item.dart';

class ReachOutSection extends StatelessWidget {
  final AccountController controller;

  const ReachOutSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isFolded = width <= 400;

    return Semantics(
      label: "reach_out_section",
      child: Column(
        key: const ValueKey("reach_out_container"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              'APP_REACH_OUT_TO_US'.tr,
              key: const ValueKey("text_reach_out_title"),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Nunito",
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            key: const ValueKey("reach_out_grid_container"),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: GridView.count(
              key: const ValueKey("reach_out_grid"),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              crossAxisSpacing: 16,
              childAspectRatio: isFolded ? 0.78 : 0.88,
              children: [
                ContactItem(
                  keyName: "contact_us",
                  icon: "assets/icons/ic_contact.svg",
                  label: AppStrings.appContactUs.toUpperCase().tr,
                  onTap: () {
                    Get.toNamed(AppRoutes.contactUsScreen);
                  },
                ),
                ContactItem(
                  keyName: "faq",
                  icon: "assets/icons/ic_faq.svg",
                  label: AppStrings.app_faq.toUpperCase().tr,
                  onTap: () {
                    navigateToWebView(AppStrings.app_faq.toUpperCase().tr,controller.faqLink);
                  },
                ),
                ContactItem(
                    keyName: "privacy_policy",
                  icon: "assets/icons/ic_privacy_policy.svg",
                  label: AppStrings.appPrivacy.toUpperCase().tr,
                    onTap: (){
                      navigateToWebView(AppStrings.appPrivacy.toUpperCase().tr,controller.privacyPolicyLink);
                    }
                ),
                ContactItem(
                    keyName: "terms_conditions",
                  icon: "assets/icons/ic_terms.svg",
                  label: AppStrings.appTermCondition.toUpperCase().tr,
                    onTap: (){
                      navigateToWebView(AppStrings.appTermCondition.toUpperCase().tr,controller.termsAndConditionsLink);
                    }
                ),
                ContactItem(
                    keyName: "warranty_exchange",
                  icon: "assets/icons/ic_warranty.svg",
                  label: AppStrings.appWarrantyExchange.toUpperCase().tr,
                    onTap: (){
                      navigateToWebView(AppStrings.appWarrantyExchange.toUpperCase().tr,controller.warrantyExchangeLink);
                    }
                ),
                ContactItem(
                    keyName: "user_agreement",
                  icon: "assets/icons/ic_agreement.svg",
                  label: AppStrings.app_all_tajer_user_agreement.toUpperCase().tr,
                    onTap: (){
                      navigateToWebView(AppStrings.app_all_tajer_user_agreement.toUpperCase().tr,controller.userAggrementLink);
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToWebView(String title, String url) {
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      AppParams.title: title,
      AppParams.webViewUrl: url,
    });
  }
}