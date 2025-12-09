import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/Extensions/image_color_utils.dart';
import '../../../../../utils/app_colors.dart';

import '../../../core/routes/app_routes.dart';
import 'models/brand.dart';

class DisplayItem {
  final String id;
  final String name;
  final String image;
  final String isBrand;
  String? shopUserID;

  DisplayItem({required this.id, required this.name, required this.image,required this.isBrand,this.shopUserID});
}

class BrandTile extends StatelessWidget {
  final DisplayItem displayItem;

  const BrandTile({super.key, required this.displayItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (displayItem.isBrand == "1") {
          AppRoutes.goToProductListPage(brandId: displayItem.id, productVideoAvailable: "0", titleHeader: displayItem.name, prodCatId: '');
        }
        else {
          Get.toNamed(
            AppRoutes.shopDetailView,
            arguments: {"shopId": displayItem.id, "shopUserId": displayItem.shopUserID},
          );
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade500, width: 1),
            ),
            clipBehavior: Clip.none, // 👈 prevent border cutting
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              // slightly smaller radius
              child: Image.network(
                displayItem.image,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[200]),
              ).withDefaultError(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            displayItem.name,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
