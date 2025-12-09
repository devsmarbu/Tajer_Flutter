import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/product_detail/product_images/product_images.dart';

import '../product_detail_model.dart';

class FullScreenProductImagesView extends StatelessWidget {
  final List<ProductImages> images;
  final bool isFullScreen;

  const FullScreenProductImagesView({super.key, required this.images, required this.isFullScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// ✅ Constrain and center image viewer
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ProductImagesView(
                images: images,
                onColorChanged: (color) {},
                isFullScreen: isFullScreen,
              ),
            ),
          ),

          /// Close Button
          Positioned(
            right: 16,
            top: 80,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SizeChartOverlay extends StatelessWidget {
  final String imageUrl;

  const SizeChartOverlay({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero, // fullscreen
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          /// Scrollable zoomable image
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  clipBehavior: Clip.none,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress == null
                          ? child
                          : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          /// Close Button (Top Right)
          Positioned(
            right: 16,
            top: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}