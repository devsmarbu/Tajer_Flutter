import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../../utils/app_colors.dart';

class ContactItem extends StatelessWidget {
  final String icon;
  final String label;
  final String? keyName;
  final VoidCallback? onTap;

  const ContactItem({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
    this.keyName,
  }) : super(key: key);

  ///  Generate safe key from label (fallback)
  String _safeKey(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  @override
  Widget build(BuildContext context) {

    final finalKey = keyName ?? _safeKey(label);

    return Semantics(
      label: "contact_item_$finalKey",
      button: true,
      child: InkWell(
        key: ValueKey("contact_item_$finalKey"),
        onTap: onTap ?? () => debugPrint("$label clicked"),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          key: ValueKey("contact_item_column_$finalKey"),
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              key: ValueKey("contact_item_icon_$finalKey"),
              radius: 28,
              backgroundColor: AppColors.colorAccountBackground,
              child: SvgPicture.asset(
                key: ValueKey("contact_item_svg_$finalKey"),
                icon,
                height: 28,
                width: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              key: ValueKey("contact_item_text_$keyName"),
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}