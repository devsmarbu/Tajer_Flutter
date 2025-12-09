import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';

/// Grid of subcategories
class SubcategoryListView extends StatelessWidget {
  final List<String> items;

  const SubcategoryListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      cacheExtent: 200,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.image, size: 30, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              items[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorSubcategoryText
              ),
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }
}