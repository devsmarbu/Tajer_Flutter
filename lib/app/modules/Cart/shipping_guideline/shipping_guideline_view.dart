import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:tajer/utils/pref_store.dart';

import '../../../../utils/app_params.dart';
import '../../../core/routes/app_routes.dart';

class DeliveryHtmlPage extends StatefulWidget {
  final bool isAgreed;
  final Function(bool)? onAgreeBtnTap; // Updated: Now accepts int parameter
  final ShippingGuidelines? shippingGuidelines;

  const DeliveryHtmlPage({
    super.key,
    required this.isAgreed,
    this.onAgreeBtnTap,
    required this.shippingGuidelines,
  });

  @override
  State<DeliveryHtmlPage> createState() => _DeliveryHtmlPageState();
}

class _DeliveryHtmlPageState extends State<DeliveryHtmlPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.shippingGuidelines?.epageLabel ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DeliveryHtmlContent(
              htmlContent: widget.shippingGuidelines?.epageContent ?? "",
            ),
            // will auto-fit height
            // Padding(
            //   padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            //   child: Checkbox(
            //     activeColor: Colors.black,
            //     value: widget.isAgreed,
            //     onChanged: (bool? newValue) {
            //       setState(() {
            //         widget.onAgreeBtnTap?.call(newValue ?? false);
            //       });
            //     },
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    const TextSpan(
                      text: "By placing order, you agree to tajershop's ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "APP_TERMS".tr,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('APP_TERMS'.tr);
                          final termsConditionLink = PrefStore().loadString(
                            AppConstants.termsConditionLink,
                          );
                          navigateToWebView(
                            AppStrings.appTermCondition.toUpperCase().tr,
                            termsConditionLink ??
                                'https://tajershops.com/terms',
                          );
                        },
                    ),
                    const TextSpan(
                      text: " and ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "APP_PRIVACY_POLICY".tr,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('APP_PRIVACY_POLICY'.tr);
                          final privacyPolicyLink = PrefStore().loadString(
                            AppConstants.privacyLink,
                          );
                          navigateToWebView(
                            AppStrings.appPrivacy.toUpperCase().tr,
                            privacyPolicyLink ??
                                'https://tajershops.com/privacy-policies',
                          );
                          // Get.to(() => PrivacyPolicyScreen());
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToWebView(String title, String url) {
    Get.toNamed(
      AppRoutes.webViewScreen,
      arguments: {AppParams.title: title, AppParams.webViewUrl: url},
    );
  }
}

class DeliveryHtmlContent extends StatelessWidget {
  final String htmlContent;

  const DeliveryHtmlContent({Key? key, required this.htmlContent})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Html(data: htmlContent), // auto-sizes to content height
    );
  }
}
