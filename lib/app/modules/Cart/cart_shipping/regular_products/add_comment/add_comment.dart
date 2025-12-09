import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';

Future<String?> showCommentDialog(BuildContext context) async {
  final TextEditingController commentController = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tap outside
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Comment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Please enter comments/ other info",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const UnderlineInputBorder(),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // close without result
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      final text = commentController.text.trim();
                      Get.back(result: text.isNotEmpty ? text : null);
                    },
                    child: Text(AppStrings.appAddComment.toUpperCase().tr),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}