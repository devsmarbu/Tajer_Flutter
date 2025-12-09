import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_strings.dart';

class AppDialogs {

  static Future<bool?> showConfirmationDialog(
      BuildContext context, {
        String title = "Tajer - تاجر",
        String message = AppStrings.app_want_to_logout,
      }) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Nunito",
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
                fontFamily: "Nunito",
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context, true),
              textStyle: const TextStyle(
                color: AppColors.redColor1,
                fontWeight: FontWeight.bold,
              ),
              child: Text(AppStrings.appOk.toUpperCase().tr),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              textStyle: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              child: Text(AppStrings.appCancel.toUpperCase().tr),
            ),
          ],
        );
      },
    );
  }
}
