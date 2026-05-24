import 'package:flutter/material.dart';
import '../../../../../utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../../utils/app_strings.dart';
import '../account_screen.dart';
import '../controller/account_controller.dart';

class HeaderNameEmail extends StatelessWidget {
  final String name;
  final String email;
  final AccountController controller;
  final VoidCallback? onEditTap; // optional edit tap handler

  const HeaderNameEmail({
    super.key,
    this.name = "",
    this.email = "",
    required this.controller,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(AccountController());
    return Column(
      key: const ValueKey("header_name_email"),
      children: [
        Row(
          key: const ValueKey("row_name_edit"),
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: const ValueKey("text_user_name"),
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black1,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            // GestureDetector(
            //   onTap: () {
            //     controller.goToEditProfile();
            //   },
            //   child: Image.asset(
            //     "assets/images/edit.png",
            //     height: 20,
            //     width: 20
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          key: const ValueKey("text_user_email"),
          email,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Nunito',
            color: AppColors.colorSubtitle,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        ///  Edit Profile Button (Top Right)
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Centered Text
              GestureDetector(
                onTap: () {
                  controller.goToEditProfile();
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    AppStrings.appEditProfile.toUpperCase().tr,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              /// Icon positioned slightly left of text
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 90, // tweak this value
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}