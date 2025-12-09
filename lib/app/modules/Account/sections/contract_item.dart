import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../../utils/app_colors.dart';

class ContactItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const ContactItem({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => debugPrint("$label clicked"),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.colorAccountBackground,
            child: SvgPicture.asset(
              icon,
              height: 28,
              width: 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}