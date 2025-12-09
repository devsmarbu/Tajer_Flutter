import 'package:flutter/material.dart';
import '../../../../../utils/app_colors.dart';
import 'package:get/get.dart';

import '../account_screen.dart';
import '../controller/account_controller.dart';

class HeaderNameEmail extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onEditTap; // optional edit tap handler

  const HeaderNameEmail({
    super.key,
    this.name = "",
    this.email = "",
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());
    return Column(
      children: [
        Row(
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black1,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                controller.goToEditProfile();
              },
              child: Image.asset(
                "assets/images/edit.png",
                height: 20,
                width: 20
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Nunito',
            color: AppColors.colorSubtitle,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}