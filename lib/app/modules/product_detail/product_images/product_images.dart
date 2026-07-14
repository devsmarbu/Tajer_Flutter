import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../Extensions/image_color_utils.dart';
import '../product_detail_model.dart';

class ProductImagesView extends StatefulWidget {
  final List<ProductImages> images;
  final Function(Color) onColorChanged;
  final bool pageControllerHide;
  final String bannerImage;
  final bool isFullScreen;
  final bool showIndicator;
  final ValueChanged<int>? onPageChanged;

  const ProductImagesView({
    super.key,
    this.pageControllerHide = false,
    this.bannerImage = "",
    this.isFullScreen = false,
    this.showIndicator = true,
    this.onPageChanged,
    required this.onColorChanged,
    required this.images,
  });

  @override
  State<ProductImagesView> createState() => _BannerPageViewState();
}

class _BannerPageViewState extends State<ProductImagesView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _firstColorExtracted = false;

  /// ✅ NEW — for pinch zoom toggle UI
  bool _isZooming = false;

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;

    return widget.isFullScreen
        ? Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 100),
      child: _buildImageContent(screenSize, expanded: true),
    )
        : _buildImageContent(screenSize, expanded: false);
  }

  Widget _buildImageContent(double screenWidth, {required bool expanded}) {
    final imageWidget = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.pageControllerHide
            ? Image(
          image: NetworkImage(widget.bannerImage),
          fit: BoxFit.fitWidth,
          width: screenWidth,
        )
            : PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            final provider = NetworkImage(widget.images[index].productImageUrl ?? "");

            return Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                panEnabled: true,
                minScale: 1,
                maxScale: 4,            // ✅ Zoom allowed up to 4x
                onInteractionStart: (_) {
                  setState(() => _isZooming = true);   // ✅ hide UI
                },
                onInteractionEnd: (_) {
                  setState(() => _isZooming = false);  // ✅ show UI again
                },
                child: Image(
                  image: provider,
                  fit: BoxFit.contain,
                  width: screenWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      if (index == 0 && !_firstColorExtracted) {
                        _firstColorExtracted = true;
                        _extractColor(provider);
                      }
                    }
                    return child;
                  },
                ),
              ),
            );
          },
          onPageChanged: (index) {
            _currentIndex = index;
            widget.onPageChanged?.call(index);
            final provider = NetworkImage(widget.images[index].productImageUrl ?? "");
            _extractColor(provider);
          },
        ),
      ),
    );

    return Column(
      children: [
        SizedBox(height: 10),
        expanded
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: imageWidget,
                ),
              )
            : SizedBox(
                height: 395,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: imageWidget,
                ),
              ),

        if (!widget.pageControllerHide && !_isZooming && widget.showIndicator)   // ✅ hide on zoom or when external indicator
          const SizedBox(height: 12),

        if (!widget.pageControllerHide && !_isZooming && widget.showIndicator)   // ✅ hide on zoom or when external indicator
          SmoothPageIndicator(
            controller: _controller,
            count: widget.images.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor:
              widget.isFullScreen ? Colors.purple : Colors.black,
              dotColor: Colors.grey,
            ),
          ),
      ],
    );
  }

  Future<void> _extractColor(ImageProvider provider) async {
    Color? color = await getPixelFromImageProvider(provider, 10, 10);
    if (color != null) widget.onColorChanged(color);
  }
}