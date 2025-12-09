import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/filter/controller/filter_controller.dart';
import 'package:tajer/app/modules/filter/views/price_range_widget.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import 'brand_list_widget.dart';

class FilterScreen extends StatefulWidget {
  final String? keyword;
  final String? categoryId;
  final String? brandId;
  final String? shopId;
  final String? featured;
  final String? topProducts;

  const FilterScreen({
    super.key,
    this.categoryId,
    this.brandId,
    this.shopId,
    this.keyword,
    this.featured,
    this.topProducts,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final controller = Get.put(FilterController());
  int selectedIndex = 0;
  Map<String, bool> selectedBrands = {};
  Map<String, bool> selectedOptionValue = {};
  Map<String, bool> selectedOptionValueIds = {};
  Map<String, bool> selectedSize = {};
  Map<String, bool> selectedCondition = {};
  Map<String, bool> selectedCategory = {};
  Map<String, bool> selectedBrandIds = {};
  Map<String, bool> selectedSizeIds = {};
  Map<String, bool> selectedConditionIds = {};
  Map<String, bool> selectedCategoryIds = {};
  String priceMinRange = "";
  String priceMaxRange = "";

  @override
  void initState() {
    super.initState();

    controller.getFilters(
      widget.keyword ?? "",
      widget.categoryId ?? "",
      widget.shopId ?? "",
      widget.featured ?? "",
      widget.topProducts ?? "",
      widget.brandId ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        // White background
        elevation: 0,
        // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.app_filter.tr,
          style: TextStyle(color: Colors.black), // Black text
        ),
        titleSpacing: 0,
        centerTitle: false,
        // ✅ Divider below AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: Container(
        color: AppColors.white,
        child: Row(
          children: [
            /// LEFT MENU
            Obx(() {
              final filters =
                  controller.productFilters.value?.data?.filters ?? [];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.only(top: 20),
                color: Colors.grey.shade200,
                child: ListView.builder(
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return InkWell(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade200,
                          borderRadius: isSelected
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    10,
                                  ), // rounded top-left
                                  bottomLeft: Radius.circular(
                                    10,
                                  ), // rounded bottom-left
                                )
                              : null,
                        ),
                        child: Text(
                          filters[index].title ?? "",
                          style: TextStyle(
                            fontFamily: "nunito",
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            /// RIGHT CONTENT
            Expanded(
              child: Obx(() {
                final filters =
                    controller.productFilters.value?.data?.filters ?? [];

                if (filters.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentFilter = filters[selectedIndex];

                /// Convert API data to common options list
                List<OptionsList> options = (currentFilter.data ?? []).map((e) {
                  return OptionsList(
                    optionName:
                        e.prodcatName ??
                        e.brandName ??
                        e.title ??
                        e.optionvalue_name ??
                        "",
                    optionId:
                        e.prodcatId ??
                        e.brandId ??
                        e.value ??
                        e.optionvalue_id ??
                        "",
                  );
                }).toList();

                return Column(
                  children: [
                    if (currentFilter.type == "2") ...[
                      /// 🔍 Search bar for brands
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.appSearch,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.black1,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.w300,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                                width: 0.7,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                                width: 0.7,
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            controller.brandSearchText.value = text;
                          },
                        ),
                      ),

                      /// ✅ Multiple selection for brand list
                      BrandListWidget(
                        items: controller.getFilteredBrands(options),
                        selectedItems: selectedBrands,
                        selectedIds: selectedBrandIds,
                        isMultipleSelection: true,
                        onChanged: (id, val) {
                          setState(() {
                            selectedBrands[id] = val;

                            if (val) {
                              selectedBrandIds[id] = true; // ✅ add selected ID
                            } else {
                              selectedBrandIds.remove(
                                id,
                              ); // ✅ remove when unchecked
                            }
                          });
                        },
                      ),
                    ],
                    if (currentFilter.type == "3") ...[
                      /// 🔍 Search bar for brands
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        )
                      ),

                      /// ✅ Multiple selection for brand list
                      BrandListWidget(
                        items: options,
                        selectedItems: selectedOptionValue,
                        selectedIds: selectedOptionValueIds,
                        isMultipleSelection: true,
                        onChanged: (id, val) {
                          setState(() {
                            selectedOptionValue[id] = val;

                            if (val) {
                              selectedOptionValueIds[id] = true; // ✅ add selected ID
                            } else {
                              selectedOptionValueIds.remove(
                                id,
                              ); // ✅ remove when unchecked
                            }
                          });
                        },
                      ),
                    ] else if (currentFilter.type == "1") ...[
                      /// ✅ Category - Single Selection
                      BrandListWidget(
                        items: options,
                        selectedItems: selectedCategory,
                        selectedIds: selectedCategoryIds,
                        isMultipleSelection: false,
                        onChanged: (id, val) {
                          setState(() {
                            selectedCategory.updateAll((key, value) => false);
                            selectedCategory[id] = true;

                            selectedCategoryIds.clear(); // ✅ only one allowed
                            selectedCategoryIds[id] = true;
                          });
                        },
                      ),
                    ] else if (currentFilter.type == "5") ...[
                      /// ✅ Price only widget
                      PriceRangeWidget(
                        minimumPriceRange:
                            currentFilter.data?.first.minPrice ?? "",
                        maximumPriceRange:
                            currentFilter.data?.first.maxPrice ?? "",
                        currencySymbol:
                            controller
                                .productFilters
                                .value
                                ?.data
                                ?.currencySymbol ??
                            "\$",
                        rangeValues: (RangeValues p1) {
                          priceMinRange = p1.start.toString();
                          priceMaxRange = p1.end.toString();
                        },
                      ),
                    ] else if (currentFilter.type == "6") ...[
                      /// ✅ Condition filter - MULTIPLE selection
                      BrandListWidget(
                        items: options,
                        selectedItems: selectedCondition,
                        selectedIds: selectedConditionIds,
                        isMultipleSelection: true,
                        onChanged: (id, val) {
                          setState(() {
                            selectedCondition[id] = val;

                            if (val) {
                              selectedConditionIds[id] =
                                  true; // ✅ add selected ID
                            } else {
                              selectedConditionIds.remove(
                                id,
                              ); // ✅ remove when unchecked
                            }
                          });
                        },
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),

      /// BOTTOM BUTTONS
      bottomNavigationBar: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Clear All Button (smaller weight)
              Expanded(
                flex: 4, // smaller weight
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: Colors.black, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        4,
                      ), // decreased corner radius
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedBrands.updateAll((key, value) => false);
                      selectedOptionValue.updateAll((key, value) => false);
                    });
                  },
                  child: Text(
                    AppStrings.app_clear_all.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Apply Button (larger weight)
              Expanded(
                flex: 6, // bigger weight
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        4,
                      ), // decreased corner radius
                    ),
                  ),
                  onPressed: () {
                    // Apply logic here
                    Navigator.pop(context, {
                      "brandIds": selectedBrandIds.keys.toList(),
                      "optionvalue": selectedOptionValueIds.keys.toList(),
                      "categoryIds": selectedCategoryIds.keys.toList(),
                      "conditionIds": selectedConditionIds.keys.toList(),
                      "priceMinRange": priceMinRange,
                      "priceMaxRange": priceMaxRange,
                    });
                  },
                  child: Text(
                    AppStrings.appApply.toUpperCase().tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
