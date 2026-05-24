import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../categories/category_controller.dart';
import '../../categories/models/category.dart';

class CategoryListView extends StatefulWidget {
  final NewCategory category;

  const CategoryListView({super.key, required this.category});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final ScrollController _scrollController = ScrollController();
  bool showScrollBtn = false;

  @override
  void initState() {
    super.initState();

    // Detect scroll to show button
    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !showScrollBtn) {
        setState(() => showScrollBtn = true);
      } else if (_scrollController.offset <= 400 && showScrollBtn) {
        setState(() => showScrollBtn = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find<CategoryController>();
    final category = widget.category;

    return Scaffold(
      /// 🔥 FLOATING SCROLL BUTTON HERE
      floatingActionButton: showScrollBtn
          ? Padding(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 0),
              child: FloatingActionButton.small(
                backgroundColor: Colors.black,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
          : null,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (category.children == null || category.children!.isEmpty) {
          return const Center(
            child: Text(
              "No categories available",
              style: TextStyle(fontFamily: "Nunito"),
            ),
          );
        }

        final List<NewCategory> subCategories = category.children!;

        return Container(
          color: AppColors.white,
          child: CustomScrollView(
            controller: _scrollController, // 🔥 REQUIRED FOR SCROLL FAB
            slivers: [
              // if (category.icon != null && category.icon!.isNotEmpty)
              //   SliverToBoxAdapter(
              //     child: GestureDetector(
              //       onTap: () {
              //         AppRoutes.goToProductListPage(
              //           brandId: "",
              //           productVideoAvailable: "",
              //           titleHeader: "APP_COMING_SOON".tr,
              //           condition: "4",
              //           prodCatId: '',
              //         );
              //       },
              //       child: ClipRRect(
              //         borderRadius: const BorderRadius.only(
              //           bottomLeft: Radius.circular(18),
              //         ),
              //         child: Image.asset(
              //           (PrefStore().loadString(AppConstants.languageCode) ==
              //                   "AR")
              //               ? "assets/images/coming_soon_banner_arabic.png"
              //               : "assets/images/coming_soon_banner.png",
              //           height: 95,
              //           width: double.infinity,
              //           fit: BoxFit.fill,
              //         ),
              //       ),
              //     ),
              //   ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              ...subCategories.expand((subCat) {
                final List<Widget> sliverGroup = [];

                sliverGroup.add(
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.productListPage,
                          parameters: {
                            "prodCatId": subCat.prodcatId ?? "",
                          //  "brandId": subCat. ?? "",
                            "productVideoAvailable": "0",
                            "titleHeader": subCat.prodcatName ?? "",
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          subCat.prodcatName ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                sliverGroup.add(
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                );
                final childrenCount = subCat.children?.length ?? 0;
                final width = MediaQuery.of(context).size.width;
                final bool isFolded = width <= 400;

                sliverGroup.add(
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverGrid(
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 8,
                            childAspectRatio: isFolded ? 0.6:0.7,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.productListPage,
                                parameters: {
                                  "prodCatId": subCat.prodcatId ?? "",
                                  "productVideoAvailable": "0",
                                  "titleHeader": subCat.prodcatName ?? "",
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/view_all.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "APP_VIEW_ALL".tr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final item = subCat.children![index - 1];

                        return GestureDetector(
                          onTap: () {
                            AppRoutes.goToProductListPage(
                              brandId: "",
                              productVideoAvailable: "0",
                              titleHeader: item.prodcatName ?? "",
                              prodCatId: item.prodcatId ?? "",
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Colors.white,
                                ),
                                child: ClipOval(
                                  child:
                                      (item.icon != null &&
                                          item.icon!.isNotEmpty)
                                      ? Image.network(
                                          item.icon!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.grid_view,
                                          color: Colors.black54,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.prodcatName ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: 1 + childrenCount),
                    ),
                  ),
                );

                sliverGroup.add(
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                );

                return sliverGroup;
              }),
              const SliverToBoxAdapter(
                child: SizedBox(height: 60), // footer spacing
              ),
            ],
          ),
        );
      }),
    );
  }
}
