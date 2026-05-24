import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import '../header_view/header_view.dart';
import '../home_model.dart';

class FavoriteBrandCellView extends StatefulWidget {
  final List<HomeBrand>? brands;
  final String? titleHeader;
  final Collection collection;

  const FavoriteBrandCellView({
    super.key,
    this.brands,
    this.titleHeader,
    required this.collection,
  });

  @override
  State<FavoriteBrandCellView> createState() => _FavoriteBrandCellViewState();
}

class _FavoriteBrandCellViewState extends State<FavoriteBrandCellView> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'favorite_brand_section',
      child: SizedBox(
        key: const Key('favorite_brand_root'),
        height: 260,
        child: Column(
          key: const Key('favorite_brand_column'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderView(
              key: const Key('favorite_brand_header'),
              titleHeader: widget.titleHeader ?? "",
              collection: widget.collection,
            ),
            SizedBox(height: 10,key: Key('favorite_brand_spacing_header'),),
            Container(
              key: const Key('favorite_brand_container'),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                key: const Key('favorite_brand_grid_wrapper'),
                height: 260, // fix the GridView height
                child: GridView.builder(
                  key: const Key('favorite_brand_grid'),
                  cacheExtent: 200,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 rows
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1, // keep square
                  ),
                  itemCount: (widget.brands?.length ?? 0) > 10
                      ? 10
                      : (widget.brands?.length ?? 0),
                  itemBuilder: (context, index) {
                    final provider = CachedNetworkImage(
                      imageUrl: widget.brands?[index].brandImage ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 1.2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    )
                    // NetworkImage(widget.brands?[index].brandImage ?? "")
                    ;
                    debugPrint(
                      "-----------------------$provider.url------------------------",
                    );
                    return Semantics(
                      label:
                      'favorite_brand_item_${widget.brands?[index].brandName}_$index',
                      button: true,
                      child: SizedBox(
                        key: Key('favorite_brand_item_$index'),
                        width: 150, // 👈 give each child a fixed width
                        child: GestureDetector(
                          key: Key('favorite_brand_tap_$index'),
                          onTap: () {
                            AppRoutes.goToProductListPage(
                              brandId: widget.brands?[index].brandId ?? "",
                              productVideoAvailable: "0",
                              titleHeader: widget.brands?[index].brandName ?? "",
                              prodCatId: "",
                              condition: "",
                            );
                          },
                          child: Container(
                            key: Key('favorite_brand_card_$index'),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              key: Key(
                                  'favorite_brand_padding_$index'),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Semantics(
                                  label:
                                  'favorite_brand_image_${widget.brands?[index].brandName}_$index',
                                  image: true,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    // 👈 set your radius here
                                    child: provider,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
