import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/categories/brands_list/brands_list_view.dart';
import '../../modules/categories/category_list/category_list_view.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../home/search_view/search_view.dart';
import 'category_controller.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appAllCategories.toUpperCase().tr,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.colorAccountBackground,
        child: Column(
          children: [
            // 🔍 Search Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SearchPage(),
            ),

            // 🔹 Tabs: Categories / Brands / Shops
            Obx(() {
              return Row(
                children: [
                  const SizedBox(width: 12),
                  for (int i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () {
                        controller.selectedTab.value = i;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == i
                              ? AppColors.black1
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          [AppStrings.appCategories.toUpperCase().tr, AppStrings.appBrands.toUpperCase().tr, AppStrings.appShops.toUpperCase().tr][i],
                          style: TextStyle(
                            color: controller.selectedTab.value == i
                                ? AppColors.white
                                : AppColors.black1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: 12),

            // 🔹 Body
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.categories.isEmpty) {
                  return const Center(
                    child: Text(
                      "No categories found",
                      style: TextStyle(fontFamily: "Nunito"),
                    ),
                  );
                }

                // --- Active Tab ---
                switch (controller.selectedTab.value) {
                  case 0: // ✅ Categories tab
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT SIDE CATEGORY LIST
                        Container(
                          width: 120,
                          color: Colors.grey.shade100,
                          child: Obx(
                            () => ListView.builder(
                              padding: EdgeInsets.only(bottom: 80),
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];
                                return _CategoryItem(
                                  title: category.prodcatName ?? "",
                                  image: category.icon ?? "",
                                  selected:
                                      controller.selectedIndex.value == index,
                                  onTap: () {
                                    setState(
                                      () => controller.selectedIndex.value =
                                          index,
                                    );
                                  },
                                  index: index,
                                  selectedIndex: controller.selectedIndex.value,
                                );
                              },
                            ),
                          ),
                        ),

                        // RIGHT SIDE SUBCATEGORY CONTENT
                        Expanded(
                          child: CategoryListView(
                            // Pass selected category data
                            category: controller
                                .categories[controller.selectedIndex.value],
                          ),
                        ),
                      ],
                    );

                  case 1: // ✅ Brands tab
                    return BrandsListView(key: UniqueKey(), index: "1");

                  case 2: // ✅ Shops tab
                    return BrandsListView(key: UniqueKey(), index: "2");

                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchCategories();
  }
}

/// Left Category Item
class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool selected;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.image,
    required this.selected,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAboveSelected = index == selectedIndex - 1;
    final bool isBelowSelected = index == selectedIndex + 1;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 110,
        decoration: BoxDecoration(
          color: selected ? AppColors.white : AppColors.colorAccountBackground,
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          spacing: 0,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 6,
                height: 55,
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Image.network(
                        image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/images/placeholder_image.png",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
