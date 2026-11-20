import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

/// Custom section view for "White Friday Deals" (collection_id: 154).
/// Matches the promotional banner header with slanted neon lime badge
/// and flanking radiating sparkle rays, followed by the circular promo deal bags.
class WhiteFridayDealsView extends StatelessWidget {
  final Collection collection;

  const WhiteFridayDealsView({
    super.key,
    required this.collection,
  });

  static const Color neonLimeColor = Color(0xFFD2FA15);

  @override
  Widget build(BuildContext context) {
    final categories = collection.categories ?? <CategoryModelNew>[];
    final banners = collection.banners?.banners ?? <HomeBanner>[];

    final int itemCount = categories.isNotEmpty
        ? categories.length
        : banners.length;

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      color: collection.appColor,
      padding: const EdgeInsets.only(top: 14, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _buildHeaderTitle(),
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal Deals Bags List
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              clipBehavior: Clip.none,
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                if (categories.isNotEmpty) {
                  final category = categories[index];
                  return _buildCategoryItem(context, category, index);
                } else {
                  final banner = banners[index];
                  return _buildBannerItem(context, banner, index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the stylized "White Friday Deals" header with flanking burst rays
  Widget _buildHeaderTitle() {
    final String rawTitle = (collection.collectionName?.trim().isNotEmpty ?? false)
        ? collection.collectionName!.trim()
        : "White Friday Deals";

    String prefix = "White Friday";
    String highlight = "Deals";

    if (rawTitle.toLowerCase() == "white friday deals") {
      prefix = "White Friday";
      highlight = "Deals";
    } else {
      final parts = rawTitle.split(' ');
      if (parts.length > 1) {
        highlight = parts.last;
        prefix = parts.sublist(0, parts.length - 1).join(' ');
      } else {
        prefix = "";
        highlight = parts.first;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left radiating burst
        const CustomPaint(
          size: Size(24, 28),
          painter: _SparkleBurstPainter(isLeft: true, color: neonLimeColor),
        ),

        const SizedBox(width: 8),

        // Prefix text (e.g. "White Friday")
        if (prefix.isNotEmpty) ...[
          Text(
            "$prefix ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontFamily: "Nunito",
              letterSpacing: -0.5,
            ),
          ),
        ],

        // Highlighted text inside slanted lime tag (e.g. "Deals")
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Transform(
                transform: Matrix4.skewX(-0.22),
                child: Container(
                  decoration: BoxDecoration(
                    color: neonLimeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                highlight,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontFamily: "Nunito",
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),

        // Right radiating burst
        const CustomPaint(
          size: Size(24, 28),
          painter: _SparkleBurstPainter(isLeft: false, color: neonLimeColor),
        ),
      ],
    );
  }

  /// Builds a single deal bag item from CategoryModelNew
  Widget _buildCategoryItem(
    BuildContext context,
    CategoryModelNew category,
    int index,
  ) {
    return Semantics(
      label: 'white_friday_deal_item_$index',
      child: GestureDetector(
        key: Key('white_friday_deal_tap_$index'),
        onTap: () {
          AppRoutes.goToProductListPage(
            brandId: "",
            productVideoAvailable: "0",
            titleHeader: category.prodcatName,
            prodCatId: category.prodcatId,
            condition: "",
          );
        },
        child: Container(
          width: 110,
          height: 120,
          alignment: Alignment.center,
          child: _buildNetworkImage(
            imageUrl: category.categoryImageUrl,
            index: index,
          ),
        ),
      ),
    );
  }

  /// Builds a single deal bag item from HomeBanner
  Widget _buildBannerItem(
    BuildContext context,
    HomeBanner banner,
    int index,
  ) {
    return Semantics(
      label: 'white_friday_banner_item_$index',
      child: GestureDetector(
        key: Key('white_friday_banner_tap_$index'),
        onTap: () {
          _handleSlideNavigation(
            context,
            banner.bannerUrlType ?? "",
            banner.bannerUrl ?? "",
            banner.bannerUrlTitle ?? "",
          );
        },
        child: Container(
          width: 110,
          height: 120,
          alignment: Alignment.center,
          child: _buildNetworkImage(
            imageUrl: banner.bannerImage ?? "",
            index: index,
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage({required String imageUrl, required int index}) {
    if (imageUrl.isEmpty) {
      return _buildImagePlaceholder(index);
    }

    return Image.network(
      imageUrl,
      key: Key('white_friday_img_$index'),
      fit: BoxFit.contain,
      width: 110,
      height: 115,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey.shade400,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          _buildImagePlaceholder(index),
    );
  }

  Widget _buildImagePlaceholder(int index) {
    return Container(
      key: Key('white_friday_placeholder_$index'),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.grey,
        size: 36,
      ),
    );
  }

  void _handleSlideNavigation(
    BuildContext context,
    String urlType,
    String url,
    String urlTitle,
  ) {
    switch (urlType) {
      case "1":
        _openUrl(url);
        break;
      case "2":
        Get.toNamed(
          AppRoutes.shopDetailView,
          arguments: {"shopId": url, "shopUserId": ""},
        );
        break;
      case "3":
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {'productId': url, 'productName': urlTitle},
        );
        break;
      case "4":
        AppRoutes.goToProductListPage(
          brandId: "",
          productVideoAvailable: "0",
          titleHeader: urlTitle,
          prodCatId: url,
          condition: "",
        );
        break;
      case "5":
        AppRoutes.goToProductListPage(
          brandId: url,
          productVideoAvailable: "0",
          titleHeader: urlTitle,
          prodCatId: "",
          condition: "",
        );
        break;
      default:
        break;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }
}

/// CustomPainter to draw 3 radiating burst rays on left/right of the title
class _SparkleBurstPainter extends CustomPainter {
  final bool isLeft;
  final Color color;

  const _SparkleBurstPainter({required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double midY = size.height / 2;
    // For left burst, radiating center is on the right edge (towards text)
    // For right burst, radiating center is on the left edge (towards text)
    final double originX = isLeft ? size.width - 2 : 2;
    final double dir = isLeft ? -1.0 : 1.0;

    // Middle ray (horizontal)
    const double midLen = 14.0;
    canvas.drawLine(
      Offset(originX + dir * 3, midY),
      Offset(originX + dir * (3 + midLen), midY),
      paint,
    );

    // Top ray (angled ~35 degrees up)
    const double topAngle = 35 * math.pi / 180;
    const double topLen = 13.0;
    final double topStartX = originX + dir * 3;
    final double topStartY = midY - 6;
    canvas.drawLine(
      Offset(topStartX, topStartY),
      Offset(
        topStartX + dir * (topLen * math.cos(topAngle)),
        topStartY - (topLen * math.sin(topAngle)),
      ),
      paint,
    );

    // Bottom ray (angled ~35 degrees down)
    const double botAngle = 35 * math.pi / 180;
    const double botLen = 13.0;
    final double botStartX = originX + dir * 3;
    final double botStartY = midY + 6;
    canvas.drawLine(
      Offset(botStartX, botStartY),
      Offset(
        botStartX + dir * (botLen * math.cos(botAngle)),
        botStartY + (botLen * math.sin(botAngle)),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SparkleBurstPainter oldDelegate) =>
      oldDelegate.isLeft != isLeft || oldDelegate.color != color;
}

