import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../header_view/header_view.dart';
import '../home_model.dart';
import '../reel_page_view/reel_page_view.dart';

class ReelView extends StatefulWidget {
  final List<HomeProduct> products;
  final Collection? collection;

  const ReelView({super.key, required this.products, required this.collection});

  @override
  State<ReelView> createState() => _ReelViewState();
}

class _ReelViewState extends State<ReelView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Semantics(
      label: 'reel_section',
      child: Column(
        key: const Key('reel_root'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(
            key: const Key('reel_header'),
            titleHeader: widget.collection?.collectionName ?? "",
            collection: widget.collection,
          ),
          const SizedBox(height: 10, key: Key('reel_spacing_header'),),
          SizedBox(height: 220, key: Key('reel_list_container'),child: _buildHorizontalGifs()),
        ],
      ),
    );
  }

  /// Horizontal scrolling GIF items
  Widget _buildHorizontalGifs() {
    if (widget.products.isEmpty) {
      return const Center(
        key: Key('reel_empty_view'),
        child: Text(
          "No reels available",
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return ListView(
      key: const Key('reel_list'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: widget.products.map((product) {
        final url = product.product_video_gif_url ?? "";

        if (url.isEmpty) {
          return Semantics(
            label:
            'reel_item_empty_${product.productName}',
            child: Container(
              key: Key(
                  'reel_item_empty_${product.productId}'),
              width: 120,
              margin: const EdgeInsets.all(6),
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image_not_supported)),
            ),
          );
        }

        return Semantics(
          label:
          'reel_item_${product.productName}',
          button: true,
          child: GestureDetector(
            key: Key(
                'reel_item_tap_${product.productId}'),
            onTap: () {
              final productIdsString =
                  "[${widget.products.map((p) => p.productId).join(',')}]";

              Get.to(
                    () => ReelPage(products: [product]),
                arguments: {
                  "productVideoAvailable": "1",
                  "productIds": productIdsString,
                  "indexToPlayVideoFirst": 0,
                },
              );
            },
            child: Container(
              key: Key(
                  'reel_item_container_${product.productId}'),
              width: 120,
              margin: const EdgeInsets.all(6),

              /// SAME CONTAINER SHAPE
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: GifItem(imageUrl: url,key: Key(
                  'reel_gif_${product.productId}'),),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class GifItem extends StatefulWidget {
  final String imageUrl;

  const GifItem({super.key, required this.imageUrl});

  @override
  State<GifItem> createState() => _GifItemState();
}

class _GifItemState extends State<GifItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Semantics(
      label: 'reel_gif_image',
      image: true,
      child: CachedNetworkImage(
        key: const Key('reel_cached_image'),
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        // optional performance optimization
        memCacheWidth: 300,
        maxWidthDiskCache: 300,

        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),

        errorWidget: (context, url, error) => Container(
          key: const Key('reel_gif_error'),
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
