import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tajer/app/modules/product_detail/search_view/search_controller.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
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

                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.black12,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),

                        // Image picker
                        GestureDetector(
                          onTap: () => _showImageSourceSheet(context),
                          child: Obx(() {
                            final XFile? picked = _pickedImage.value;
                            if (picked != null) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    File(picked.path),
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }

                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              child: Icon(Icons.camera_alt, color: Colors.black54),
                            );
                          }),
                        ),
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

                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
              );

            }),
          ),

          const Divider(height: 1, thickness: 1, color: Colors.black12),

          /// Search result list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.products.isEmpty) {
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
              final bool showTags = controller.productsTags.isNotEmpty;

              return ListView.separated(
                itemCount: showTags
                    ? controller.productsTags.length
                    : controller.products.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  late final String id;
                  late final String tagName;
                  late final String title;

                  if (showTags) {
                    final tag = controller.productsTags[index];
                    tagName= tag.tagName ?? "Unknown";
                    id = tag.tagId ?? "";
                    title = "$tagName(${tag.prodCount})";
                  } else {
                    final product = controller.products[index];
                    id = product.selprodId ?? "";
                    title = product.selprodTitle ?? "Unknown";
                  }

                  return ListTile(
                    onTap: () {
                      showTags
                          ? controller.goToProductListing(id, "",tagName)
                          : controller.goToProductDetailView(id, title);
                    },
                    title: Row(
                      children: [
                        if (showTags) ...[
                          Transform.rotate(
                            angle: 90 * 3.141592653589793 / 180, // 90 degrees
                            child: const Icon(
                              Icons.chevron_right_sharp,
                              size: 24,
                              color: Colors.black54,
                            ),
                          )
                          ,
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Nunito",
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  );
                },
              );

            }),
          ),
        ],
      ),
    );
  }
}
