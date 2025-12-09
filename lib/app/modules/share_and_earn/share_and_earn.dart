import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../product_detail/share_activity/share_activity_view.dart';

class ShareAndEarnBottomSheet extends StatelessWidget {
  const ShareAndEarnBottomSheet({super.key});

  final String referralLink =
      "https://tajershops.com/home/referral/680a2d3f28bf7";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle + close icon
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const Spacer(),
                    Text(
                      AppStrings.appShareEarn.toUpperCase().tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                 Text(
                  "APP_WANT_MORE_OFFERS_OR_LESS".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                 Text(
                  "APP_SHARE_TEXT1".tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Illustration
                Center(
                  child: Image.asset(
                    "assets/images/share_and_earn.png",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 25),

                // Copy link info
                 Text(
                  "APP_SHARE_TEXT2".tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Nunito',
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Referral link box
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    referralLink,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Nunito',
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Buttons row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: referralLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Link copied to clipboard!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                        child: Text(
                          "APP_CAPTION_COPY".tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                         // Share.share(referralLink);
                          ShareProductUtil.shareProduct(
                            context: context,
                            productUrl: referralLink,
                            productTitle: "",
                            // assetImagePath: "assets/images/app_logo.png",
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        child: Text(
                          "APP_CAPTION_SHARE".tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}