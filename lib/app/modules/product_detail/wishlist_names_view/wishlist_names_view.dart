import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wish_list/wish_list_controller.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';
import 'package:tajer/utils/app_strings.dart';

import 'create_wishlist_view/create_wishlist_view.dart';

class WishlistNamesViewPopOver extends StatefulWidget {
  final String productId;
  const WishlistNamesViewPopOver({super.key,required this.productId});

@override
  State<WishlistNamesViewPopOver> createState() => _WishlistNamesViewPopOverState();
}

class _WishlistNamesViewPopOverState extends State<WishlistNamesViewPopOver> {
  final controller = Get.put(WishListController());

  @override void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchWishLists();
  }

  @override
  Widget build(BuildContext context) {

    // ✅ Call API when popover opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.products.clear();
      controller.fetchWishListItems(); // <-- your API call method
    });

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      // transparent overlay
      body: Obx(() {
        return Stack(
          children: [
            // Background tap to close
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),

            // Bottom popover
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Wishlist",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Nunito",
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                backgroundColor: Colors.grey[150],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ), // round corner radius
                                ),
                              ),
                              child: TextButton.icon(
                                onPressed: () async {
                                  final name = await showGeneralDialog<String>(
                                    context: context,
                                    barrierLabel: AppStrings.appCreateWishlist.toUpperCase().tr,
                                    barrierDismissible: true,
                                    barrierColor: Colors.black.withValues(
                                      alpha: 0.4,
                                    ),
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder: (_, __, ___) =>
                                        CreateWishlistPopover(),
                                    transitionBuilder: (_, anim, __, child) {
                                      return SlideTransition(
                                        position:
                                            Tween(
                                              begin: const Offset(0, 1),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: anim,
                                                curve: Curves.easeOut,
                                              ),
                                            ),
                                        child: child,
                                      );
                                    },
                                  );
                                  // ✅ Handle the result
                                  if (name != null && name.trim().isNotEmpty) {
                                    debugPrint("New wishlist created: $name");
                                    controller.createWishlist(name);
                                  }
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                label: const Text(
                                  "Create new",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Nunito",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add this item in following list",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ✅ Dynamic List of Wishlists
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: (controller.wishList.length >= 5)
                              ? 5 * 55
                              : controller.wishList.length *
                                    55, // limit height if many items
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: controller.wishList.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 5),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                // Handle add to this wishlist
                                final isInAnyWishlist = await  controller.addRemoveToWishlist(
                                  widget.productId,
                                  controller.wishList[index].uwlistId ?? "",
                                  "1",
                                );
                                Get.back(result: isInAnyWishlist);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  controller.wishList[index].uwlistTitle ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
