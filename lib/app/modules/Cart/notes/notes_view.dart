import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../utils/app_params.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../home/header_view/header_view.dart';
import 'package:flutter/gestures.dart';

class NotesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("notes_view"),
      spacing: 0,
      children: [
        HeaderView(
          titleHeader: AppStrings.appNotes.toUpperCase().tr,
          hideSeeAll: true,
          isHomeHeader: false,
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: bulletRichText(
            text: TextSpan(
              text: AppStrings.appCartNote.toUpperCase().tr,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5),
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            maxLines: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bulletRichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    TextSpan(
                      text: "By placing order, you agree to tajershop's ",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "APP_TERMS".tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          final link = PrefStore().loadString(
                            AppConstants.termsConditionLink,
                          );
                          navigateToWebView(
                            AppStrings.appTermCondition.toUpperCase().tr,
                            link ?? 'https://tajershops.com/terms',
                          );
                        },
                    ),
                     TextSpan(
                      text: " and ",
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: "APP_PRIVACY_POLICY".tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          final link = PrefStore().loadString(
                            AppConstants.privacyLink,
                          );
                          navigateToWebView(
                            AppStrings.appPrivacy.toUpperCase().tr,
                            link ?? 'https://tajershops.com/privacy-policies',
                          );
                        },
                    ),
                  ],
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bulletRichText({required InlineSpan text, int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: text,
              softWrap: true,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
