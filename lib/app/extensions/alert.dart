import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tajer/utils/app_colors.dart';

/// iOS-style Alert (matches native UIAlertController)
void showAlertMessage(
    BuildContext context, {
      required String title,
      required String message,
      VoidCallback? onOk,
      VoidCallback? onCancel,
      String okText = "Ok",
      String cancelText = "Cancel",
    }) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
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
            fontFamily: "Nunito",
            fontSize: 15,
          ),
        ),
      ),

      // ✅ ACTIONS (One button if onCancel == null, otherwise both)
      actions: [
        if (onCancel != null)
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              onCancel();
            },
            child: Text(cancelText),
          ),

        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            if (onOk != null) onOk();
          },
          child: Text(
            okText,
            style: const TextStyle(
              fontFamily: "Nunito",
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}