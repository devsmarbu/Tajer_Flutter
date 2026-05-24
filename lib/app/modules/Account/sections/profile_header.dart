import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../controller/account_controller.dart';

/// Profile avatar with white background and proper overlap using Positioned
class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountController>();
    final double avatarRadius = MediaQuery.of(context).size.width * 0.1;

    return Stack(
      key: const ValueKey("profile_header_stack"),
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          key: const ValueKey("profile_header_background"),
          width: double.infinity,
          height: 50, // adjust height as needed
          decoration: const BoxDecoration(
            color: AppColors.colorAccountBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),

        Positioned(
          top: -avatarRadius,
          child: Obx(() {
            final imageUrl = controller.profileImageUrl.value;

            return CircleAvatar(
              key: const ValueKey("profile_avatar"),
              radius: avatarRadius,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: avatarRadius - 3,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty
                    ? Icon(
                  Icons.person,
                  size: avatarRadius,
                  color: Colors.black,
                )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}