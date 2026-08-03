import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/main_extension.dart';
import '../../../Extensions/image_color_utils.dart';
import '../../../../utils/app_colors.dart';
import '../home_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerPageView extends StatefulWidget {
  final Function(Color) onColorChanged;
  final bool pageControllerHide;
  final bool addPadding;
  final List<Slide>? slides;
  final String? bannerImage;
  final String? bannerTitle;
  final String? bannerURLType;
  final String? bannerUrlOrId;
  final Collection collection;

  const BannerPageView({
    super.key,
    required this.onColorChanged,
    this.pageControllerHide = false,
    this.addPadding = false,
    this.slides,
    this.bannerImage,
    this.bannerTitle,
    this.bannerURLType,
    this.bannerUrlOrId,
    required this.collection,
  });

  @override
  State<BannerPageView> createState() => _BannerPageViewState();
}

class _BannerPageViewState extends State<BannerPageView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _firstColorExtracted = false;
  Timer? _autoScrollTimer;

  bool get hasSlides => (widget.slides?.isNotEmpty ?? false);

  bool get hasBannerImage =>
      (widget.bannerImage != null && widget.bannerImage!.isNotEmpty);

  @override
  void initState() {
    super.initState();
    if (hasSlides) _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!hasSlides || _controller.positions.isEmpty) return;
      final nextPage = (_currentIndex + 1) % (widget.slides!.length);
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    /// ✅ Decide which content to show
    Widget bannerContent;
    if (hasSlides) {
      bannerContent = _buildSlidesView(screenSize);
    } else if (hasBannerImage) {
      bannerContent = _buildSingleBanner(screenSize);
    } else {
      bannerContent = const Center(child: Text("No banner available"));
    }

    return Semantics(
      label: 'banner_section',
      child: Padding(
        key: const Key('banner_padding'),
        padding: widget.addPadding
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : EdgeInsets.zero,
        child: SizedBox(
          height: 200,
          key: const Key('banner_container'),
          width: screenSize,
          child: bannerContent,
        ),
      ),
    );
  }

  /// ✅ Build slider from slides
  Widget _buildSlidesView(double screenSize) {
    return Stack(
      key: const Key('banner_stack'),
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          key: const Key('banner_page_view'),
          controller: _controller,
          itemCount: widget.slides!.length,
          onPageChanged: (index) async {
            setState(() => _currentIndex = index);
            final imageUrl = widget.slides![index].slideImageUrl ?? "";
            _extractColor(NetworkImage(imageUrl));

            // ✅ Restart auto-scroll timer when user manually changes page
            _autoScrollTimer?.cancel();
            _startAutoScroll();
          },
          itemBuilder: (context, index) {
            final imageUrl = widget.slides![index].slideImageUrl ?? "";
            final provider = NetworkImage(imageUrl);

            return Semantics(
              label:
                  'banner_item_${widget.slides![index].slideUrlTitle}_$index',
              button: true,
              child: GestureDetector(
                key: Key('banner_item_tap_$index'),
                onTap: () {
                  handleSlideNavigation(
                    context,
                    widget.slides![index].slideUrlType ?? "",
                    widget.slides![index].slideUrl ?? "",
                    widget.slides![index].slideUrlTitle ?? "",
                  );
                },
                onPanDown: (_) {
                  // ✅ Pause auto-scroll while user is dragging
                  _autoScrollTimer?.cancel();
                },
                onPanEnd: (_) {
                  // ✅ Resume timer after user stops interaction
                  _startAutoScroll();
                },
                child: ClipRRect(
                  borderRadius: widget.addPadding
                      ? BorderRadius.circular(12)
                      : BorderRadius.zero,
                  child: Container(
                    key: Key('banner_item_container_$index'),
                    color: Colors.grey.withValues(alpha: 0.1),
                    width: screenSize,
                    child: Image(
                      key: Key('banner_image_$index'),
                      image: provider,
                      fit: BoxFit.cover,
                      width: screenSize,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null &&
                            index == 0 &&
                            !_firstColorExtracted) {
                          _firstColorExtracted = true;
                          _extractColor(provider);
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          key: Key('banner_image_error_$index'),
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (!widget.pageControllerHide)
          Positioned(
            key: const Key('banner_indicator_positioned'),
            bottom: 8,
            child: Semantics(
              label: 'banner_page_indicator',
              child: SmoothPageIndicator(
                key: const Key('banner_indicator'),
                controller: _controller,
                count: widget.slides!.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.black54,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// ✅ Build single static banner
  Widget _buildSingleBanner(double screenSize) {
    final provider = NetworkImage(widget.bannerImage!);
    _extractColor(provider);

    return Semantics(
      label: 'single_banner',
      button: true,
      child: ClipRRect(
        borderRadius: widget.addPadding
            ? BorderRadius.circular(12)
            : BorderRadius.zero,
        child: Container(
          key: const Key('single_banner_container'),
          color: Colors.grey.withValues(alpha: 0.1),
          // 👈 Background color while image loads or fails
          width: screenSize,
          child: GestureDetector(
            key: const Key('single_banner_tap'),
            onTap: () {
              debugPrint("debug print ");
              debugPrint(widget.bannerURLType ?? "");
              debugPrint(widget.bannerImage ?? "");
              debugPrint(widget.bannerTitle ?? "");
              handleSlideNavigation(
                context,
                widget.bannerURLType ?? "",
                widget.bannerUrlOrId ?? "",
                widget.bannerTitle ?? "",
              );
            },
            child: Image.network(
              key: const Key('single_banner_image'),
              widget.bannerImage ?? "",
              fit: BoxFit.fitWidth,
              width: screenSize,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                key: const Key('single_banner_error'),
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Text(
                  "Failed to load banner",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _extractColor(ImageProvider provider) async {
    try {
      final color = await getPixelFromImageProvider(provider, 10, 10);
      if (color != null && mounted) widget.onColorChanged(color);
    } catch (e) {
      debugPrint("⚠️ Color extraction failed: $e");
    }
  }

  void handleSlideNavigation(
    BuildContext context,
    String slideUrlType,
    String slideUrl,
    String slideUrlTitle,
  ) {
    switch (slideUrlType) {
      case "1":
        openUrl(slideUrl, title: slideUrlTitle);

        break;

      case "2":
        Get.toNamed(
          AppRoutes.shopDetailView,
          arguments: {"shopId": slideUrl, "shopUserId": ""},
        );
        break;

      case "3":
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {'productId': slideUrl, 'productName': slideUrlTitle},
        );
        break;

      case "4":
        AppRoutes.goToProductListPage(
          brandId: "",
          productVideoAvailable: "0",
          titleHeader: slideUrlTitle,
          prodCatId: slideUrl,
          condition: "",
        );
        break;

      case "5":
        AppRoutes.goToProductListPage(
          brandId: slideUrl,
          productVideoAvailable: "0",
          titleHeader: slideUrlTitle,
          prodCatId: '',
          condition: "",
        );
        break;
    }
  }

  static void openUrl(String? urlString, {String title = ''}) {
    if (urlString == null || urlString.isEmpty) return;

    // ✅ Navigate to the in-app WebView screen which has a title bar,
    // back button (page history) and a close (✕) button to dismiss.
    // This does NOT trigger Android App Links / splash re-initialization.
    Get.toNamed(
      AppRoutes.webViewScreen,
      arguments: {
        AppParams.title: title,
        AppParams.webViewUrl: urlString,
      },
    );
  }
}
