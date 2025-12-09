import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../utils/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

  const QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.black1,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 2),

                /// SUBTITLE
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
