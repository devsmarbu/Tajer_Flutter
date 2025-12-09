import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tajer/app/modules/product_detail/search_view/search_controller.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
import 'package:tajer/utils/app_strings.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final SearchViewController controller = Get.put(SearchViewController());
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.appSearch.toUpperCase().tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
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
                decoration: InputDecoration(
                  hintText: AppStrings.appIAmLookingFor.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                    isListening.value ? stopListening() : startListening(),
                    child: Icon(
                      isListening.value ? Icons.mic : Icons.mic_none,
                      color: isListening.value ? Colors.red : Colors.green,
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
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: "Nunito",
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: controller.products.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  final product = controller.products[index];

                  return ListTile(
                    onTap: () => controller.goToProductDetailView(
                      product.selprodId ?? "",
                      product.selprodTitle ?? "",
                    ),
                    title: Text(
                      product.selprodTitle ?? "Unknown Product",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Nunito",
                      ),
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