import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tajer/app/modules/product_detail/search_view/search_controller.dart';
import 'package:tajer/utils/app_strings.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final SearchViewController controller = Get.put(SearchViewController());
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ImagePicker _picker = ImagePicker();

  // Rx states
  final RxBool isListening = false.obs;
  final Rx<XFile?> _pickedImage = Rx<XFile?>(null);

  /// Start voice input
  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          _searchController.text = result.recognizedWords;
          controller.onSearchChanged(_searchController.text);
        },
      );
    }
  }

  /// Stop voice input
  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        _pickedImage.value = image;
         controller.loadRecordIdFromImage(File(image.path));
      }
    } catch (e) {
      // handle errors if needed
      debugPrint('Image pick error: $e');
    }
  }

  void _removePickedImage() {
    final XFile? current = _pickedImage.value;
    if (current != null) {
      _pickedImage.value = null;
      // Optionally clear search results if you want
      controller.products.clear();
      // If you also want to cancel any in-flight image search, you could add that here.
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              // Show Remove option only when an image is already picked
              Obx(() {
                if (_pickedImage.value != null) {
                  return ListTile(
                    leading: const Icon(Icons.delete_forever),
                    title: const Text('Remove photo'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _removePickedImage();
                    },
                  );
                }

                return const SizedBox.shrink();
              }),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Section header widget ────────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      width: double.infinity,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.black45,
          fontFamily: "Nunito",
        ),
      ),
    );
  }

  // ─── 2-liner list tile ────────────────────────────────────────────────────
  Widget _twoLinerTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    int titleMaxLines = 1,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black45),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: "Nunito",
                    ),
                    maxLines: titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                      fontFamily: "Nunito",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  // ─── Build the unified results list ─────────────────────────────────────
  List<Widget> _buildResultItems() {
    final items = <Widget>[];

    // ── Brands ──────────────────────────────────────────────────────────────
    if (controller.brands.isNotEmpty) {
      items.add(_sectionHeader('Brands'));
      for (int i = 0; i < controller.brands.length; i++) {
        final brand = controller.brands[i];
        items.add(_twoLinerTile(
          title: brand.brandName ?? 'Unknown Brand',
          subtitle: 'Brand',
          icon: Icons.label_outline,
          onTap: () => controller.goToBrandProductListing(
            brand.brandId ?? '',
            brand.brandName ?? '',
          ),
        ));
        if (i < controller.brands.length - 1) {
          items.add(const Divider(height: 1, color: Colors.black12, indent: 48));
        }
      }
    }

    // ── Shops ───────────────────────────────────────────────────────────────
    if (controller.shops.isNotEmpty) {
      items.add(_sectionHeader('Shops'));
      for (int i = 0; i < controller.shops.length; i++) {
        final shop = controller.shops[i];
        final city = shop.shopCity?.isNotEmpty == true ? shop.shopCity! : 'Shop';
        items.add(_twoLinerTile(
          title: shop.shopName ?? 'Unknown Shop',
          subtitle: city,
          icon: Icons.storefront_outlined,
          onTap: () => controller.goToShopDetail(
            shop.shopId ?? '',
            shop.shopUserId ?? '',
          ),
        ));
        if (i < controller.shops.length - 1) {
          items.add(const Divider(height: 1, color: Colors.black12, indent: 48));
        }
      }
    }

    // ── Categories ──────────────────────────────────────────────────────────
    if (controller.categories.isNotEmpty) {
      items.add(_sectionHeader('Categories'));
      for (int i = 0; i < controller.categories.length; i++) {
        final cat = controller.categories[i];
        items.add(_twoLinerTile(
          title: cat.categoryName ?? 'Unknown Category',
          subtitle: 'Category',
          icon: Icons.grid_view_outlined,
          onTap: () => controller.goToCategoryProductListing(
            cat.categoryId ?? '',
            cat.categoryName ?? '',
          ),
        ));
        if (i < controller.categories.length - 1) {
          items.add(const Divider(height: 1, color: Colors.black12, indent: 48));
        }
      }
    }

    // ── Products (tags take priority over raw products) ──────────────────────
    final bool showTags = controller.productsTags.isNotEmpty;
    final bool hasProducts = showTags
        ? controller.productsTags.isNotEmpty
        : controller.products.isNotEmpty;

    if (hasProducts) {
      items.add(_sectionHeader('Products'));

      if (showTags) {
        for (int i = 0; i < controller.productsTags.length; i++) {
          final tag = controller.productsTags[i];
          final tagName = tag.tagName ?? 'Unknown';
          items.add(_twoLinerTile(
            title: tagName,
            subtitle: '${tag.prodCount ?? "0"} products',
            icon: Icons.search,
            titleMaxLines: 2,
            onTap: () =>
                controller.goToProductListing(tag.tagId ?? '', '', tagName),
          ));
          if (i < controller.productsTags.length - 1) {
            items.add(const Divider(height: 1, color: Colors.black12, indent: 48));
          }
        }
      } else {
        for (int i = 0; i < controller.products.length; i++) {
          final product = controller.products[i];
          final title = product.selprodTitle ?? 'Unknown';
          final subtitle = product.prodcatName ?? 'Product';
          items.add(_twoLinerTile(
            title: title,
            subtitle: subtitle,
            icon: Icons.inventory_2_outlined,
            titleMaxLines: 2,
            onTap: () => controller.goToProductDetailView(
              product.selprodId ?? '',
              title,
            ),
          ));
          if (i < controller.products.length - 1) {
            items.add(const Divider(height: 1, color: Colors.black12, indent: 48));
          }
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Get.delete<SearchViewController>(force: true);
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppStrings.appSearch.toUpperCase().tr,
          style: const TextStyle(
            color: Colors.black,       fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: "Nunito",
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Obx(() {
              return TextField(
                controller: _searchController,
                onChanged: controller.onSearchChanged,

                // 🔹 Triggered when user taps "Search" on keyboard
                onSubmitted: (value) {
                  controller.keyword.value=value;
                  controller.onKeyboardSearchButton(value);
                },

                // 🔹 Show "Search" button on keyboard
                textInputAction: TextInputAction.search,

                decoration: InputDecoration(
                  hintText: AppStrings.appIAmLookingFor.tr,
                  hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,fontFamily: 'Nunito'),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: SizedBox(
                    width: 110,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Mic
                        GestureDetector(
                          onTap: () =>
                          isListening.value ? stopListening() : startListening(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(
                              isListening.value ? Icons.mic : Icons.mic_none,
                              color: isListening.value ? Colors.red : Colors.green,
                            ),
                          ),
                        ),

                        // Container(
                        //   width: 1,
                        //   height: 24,
                        //   color: Colors.black12,
                        //   margin: const EdgeInsets.symmetric(horizontal: 6),
                        // ),

                        // Image picker
                        // GestureDetector(
                        //   onTap: () => _showImageSourceSheet(context),
                        //   child: Obx(() {
                        //     final XFile? picked = _pickedImage.value;
                        //     if (picked != null) {
                        //       return Padding(
                        //         padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(20),
                        //           child: Image.file(
                        //             File(picked.path),
                        //             width: 36,
                        //             height: 36,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //
                        //     return const Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 6.0),
                        //       child: Icon(Icons.camera_alt, color: Colors.black54),
                        //     );
                        //   }),
                        // ),
                      ],
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),

                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.none,
              );

            }),
          ),

          const Divider(height: 1, thickness: 1, color: Colors.black12),

          /// Search result list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              }

              if (!controller.hasAnyResults) {
                return Center(
                  child: Text(
                    AppStrings.appNoDataFound.tr,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: "Nunito",
                    ),
                  ),
                );
              }

              final resultItems = _buildResultItems();

              return ListView.builder(
                itemCount: resultItems.length,
                itemBuilder: (context, index) => resultItems[index],
              );
            }),
          ),
        ],
      ),
    );
  }
}
