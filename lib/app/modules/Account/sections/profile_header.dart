import 'package:flutter/material.dart';
import '../../../../../utils/app_colors.dart';

/// Profile avatar with white background and proper overlap using Positioned
class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double avatarRadius = MediaQuery.of(context).size.width * 0.1;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
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
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: avatarRadius,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}