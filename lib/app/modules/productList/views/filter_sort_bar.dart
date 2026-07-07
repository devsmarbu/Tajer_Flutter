import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/productList/controllers/product_controller.dart';
import 'package:tajer/app/modules/productList/views/sort_bottom_sheet.dart';
import '../../../../../utils/app_strings.dart';
import '../../filter/views/filter_screen.dart';

class FilterSortBar extends StatelessWidget {
  final String categoryId;
  final String brandId;
  const FilterSortBar({super.key, required this.categoryId, required this.brandId});

  Future<Map<String, dynamic>?> _showSortBottomSheet(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SortBottomSheet(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final tag = Get.parameters['uniqueId'];
    final ProductController controller = Get.put(ProductController(), tag: tag);
    Map<String, dynamic> baseParams = {};

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              final result = await _showSortBottomSheet(context);

              if (result != null) {
                baseParams["sortBy"] = result["sortKey"];
                debugPrint("check the category value");
                debugPrint(result["categoryIds"]);

                if (result["categoryIds"]?.toString() == "[]" || result["categoryIds"]?.toString() == null) {
                  baseParams["prodcat"] = categoryId;
                }
                if (result["brandsIds"]?.toString() == "[]" || result["brandIds"]?.toString() == null) {
                  baseParams["brand"] = brandId;
                }
                controller.loadProducts(baseParams);
              }
            },
            child: Row(
              children: [
                Text(
                  AppStrings.app_sort_by.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "nunito",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.swap_vert, color: Colors.white, size: 18),
              ],
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.white54,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Get.to(
                () => FilterScreen(
                  categoryId: categoryId,
                  brandId: brandId,
                  shopId: '',
                  keyword: '',
                  featured: '',
                  topProducts: '',
                ),
              );
              if (result != null) {
                if (result["categoryIds"]?.toString() != "[]") {
                  baseParams["prodcat"] = result["categoryIds"].toString();
                }
                if (result["categoryIds"]?.toString() == "[]") {
                  baseParams["prodcat"] = categoryId;
                }

                if (result["brandIds"]?.toString() != "[]") {
                  baseParams["brand"] = result["brandIds"].toString();
                }
                if (result["optionvalue"]?.toString() != "[]") {
                  baseParams["optionvalue"] = result["optionvalue"].toString();
                }
                baseParams["productVideoAvailable"] = "0";
                if (result["conditionIds"]?.toString() != "[]") {
                  baseParams["condition"] = result["conditionIds"].toString();
                }
                if ((result["priceMinRange"]?.toString().isNotEmpty ?? false) &&
                    (result["priceMaxRange"]?.toString().isNotEmpty ?? false)) {
                  baseParams["price-min-range"] = result["priceMinRange"];
                  baseParams["price-max-range"] = result["priceMaxRange"];
                }
                controller.loadProducts(baseParams);
              }
            },
            child: Row(
              children: [
                Text(
                  AppStrings.app_filter.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "nunito",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.filter_alt_outlined, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
