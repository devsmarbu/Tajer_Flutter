
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Extensions/image_color_utils.dart';


class PaddedBannerCellView extends StatefulWidget {
  final List<String> images;
  final Function(Color) onColorChanged;
  final bool pageControllerHide;
  final String bannerImage;

  const PaddedBannerCellView({
    super.key,
    this.pageControllerHide = false,
    this.bannerImage = "",
    required this.onColorChanged,
    this.images = const [
      "https://beta.cdn.tajershops.com/resized/640_360/2025_06_1750668638-07HomeLivingitemsen.webp",
      "https://beta.cdn.tajershops.com/resized/640_360/2025_03_1740887788-KITCHENWARE.webp",
    ],
  });

  @override
  State<PaddedBannerCellView> createState() => _PaddedBannerCellViewState();

}

class _PaddedBannerCellViewState extends State<PaddedBannerCellView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _firstColorExtracted = false;

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return  
    Container(
      child:
      Column(
        children: [
          SizedBox(
            height: 200,
            width: screenSize - 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // 👈 rounded corners
              child: widget.pageControllerHide
                  ? Image(
                image: NetworkImage(widget.bannerImage),
                fit: BoxFit.cover,
                width: screenSize,
              )
                  : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      final provider = NetworkImage(widget.images[index]);
                      return Image(
                        image: provider,
                        fit: BoxFit.cover,
                        width: screenSize,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            if (index == 0 && !_firstColorExtracted) {
                              _firstColorExtracted = true;
                              _extractColor(provider);
                            }
                            debugPrint("----------- index $index loaded ---------------");
                          }
                          return child;
                        },
                      );
                    },
                    onPageChanged: (index) async {
                      _currentIndex = index;
                      final provider = NetworkImage(widget.images[index]);
                      _extractColor(provider);
                    },
                  ),
                  if (!widget.pageControllerHide)
                    Positioned(
                      bottom: 8,
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: widget.images.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  Future<void> _extractColor(ImageProvider provider) async {
    Color? color = await getPixelFromImageProvider(provider, 10, 10);
    debugPrint("Pixel color: $color");
    if (color != null) {
      widget.onColorChanged(color);
    }
  }
}