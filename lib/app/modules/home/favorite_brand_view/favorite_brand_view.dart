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
    return SizedBox(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(
            titleHeader: widget.titleHeader ?? "",
            collection: widget.collection,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox(
              height: 260, // 👈 fix the GridView height
              child: GridView.builder(
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
                  return SizedBox(
                    width: 150, // 👈 give each child a fixed width
                    child: GestureDetector(
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
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              // 👈 set your radius here
                              child: provider,
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
    );
  }
}
