import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

/// Displays parent categories (e.g. Women, Men, Kids, Makeup, Toys)
/// as a horizontally scrollable row of circular icons with labels.
///
/// This widget is used for `CollectionLayoutType.parentCategory` (value '26').
class ParentCategoryView extends StatelessWidget {
  final List<CategoryModelNew> categoryList;

  const ParentCategoryView({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    if (categoryList.isEmpty) return const SizedBox.shrink();

    return Semantics(
      label: 'parent_category_view_list',
      child: SizedBox(
        key: const Key('parent_category_view'),
        child: ListView.builder(
          key: const Key('parent_category_list_view'),
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            final category = categoryList[index];
            final imageUrl = category.categoryImageUrl;

            return Semantics(
              label: 'parent_category_item_$index',
              child: GestureDetector(
                key: Key('parent_category_tap_$index'),
                onTap: () {
                  AppRoutes.goToProductListPage(
                    brandId: "",
                    productVideoAvailable: "0",
                    titleHeader: category.prodcatName,
                    prodCatId: category.prodcatId,
                    condition: "",
                  );
                },
                child: Container(
                  key: Key('parent_category_container_$index'),
                  width: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    key: Key('parent_category_column_$index'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular category image
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'parent_category_image_${category.categoryImageUrl}_$index',
                        image: true,
                        child: Container(
                          key: Key('parent_category_image_border_$index'),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              key: Key('parent_category_image_container_$index'),
                              color: Colors.grey.withValues(alpha: 0.1),
                              height: 70,
                              width: 70,
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      key: Key('parent_category_image_$index'),
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width: 70,
                                      errorBuilder: (context, error, stackTrace) =>
                                          _buildPlaceholder(index),
                                    )
                                  : _buildPlaceholder(index),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Category label
                      Padding(
                        key: Key('parent_category_title_padding_$index'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Semantics(
                          label: 'parent_category_title_${category.prodcatName}_$index',
                          child: Text(
                            key: Key('parent_category_title_text_$index'),
                            category.prodcatName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: "Nunito",
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder(int index) {
    return Container(
      key: Key('parent_category_image_placeholder_$index'),
      color: Colors.grey[200],
      child: const Icon(
        Icons.category_outlined,
        color: Colors.grey,
        size: 28,
      ),
    );
  }

  void _handleNavigation(
    BuildContext context,
    String urlType,
    String url,
    String urlTitle,
  ) {
    switch (urlType) {
      case "1":
        _openUrl(url);
        break;

      case "2":
        Get.toNamed(
          AppRoutes.shopDetailView,
          arguments: {"shopId": url, "shopUserId": ""},
        );
        break;

      case "3":
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {'productId': url, 'productName': urlTitle},
        );
        break;

      case "4":
        AppRoutes.goToProductListPage(
          brandId: "",
          productVideoAvailable: "0",
          titleHeader: urlTitle,
          prodCatId: url,
          condition: "",
        );
        break;

      case "5":
        AppRoutes.goToProductListPage(
          brandId: url,
          productVideoAvailable: "0",
          titleHeader: urlTitle,
          prodCatId: '',
          condition: "",
        );
        break;
    }
  }

  static Future<void> _openUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;

    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Cannot open URL: $urlString');
    }
  }
}
