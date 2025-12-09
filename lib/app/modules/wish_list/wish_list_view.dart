import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/product_detail/wishlist_names_view/create_wishlist_view/create_wishlist_view.dart';
import '../../modules/wish_list/wish_list_controller.dart';

class WishlistNamesView extends StatefulWidget {
  const WishlistNamesView({super.key});

  @override
  State<WishlistNamesView> createState() => _WishListNamesViewState();
}

class _WishListNamesViewState extends State<WishlistNamesView> {
  late WishListController controller;
  String userToken = "";

  @override
  void initState() {
    super.initState();

    /// Load token
    userToken = PrefStore().loadString(AppConstants.sessionToken) ?? "";

    /// If logged in → create controller + fetch lists
    if (userToken.isNotEmpty) {
      controller = Get.put(WishListController(), tag: UniqueKey().toString());
      controller.fetchWishListItems();
      controller.fetchWishLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.appWishlist.toUpperCase().tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "Nunito",
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),

      backgroundColor: Colors.white,

      /// 🔥 If not logged in → show login UI
      body: userToken.isEmpty
          ? _buildLoginRequiredUI()
          : _buildWishlistBody(),

      /// 🔥 FAB hidden when logged out
      floatingActionButton: userToken.isEmpty ? null : _buildFAB(),
    );
  }

  // -------------------------------------------------------------
  // LOGIN REQUIRED UI
  // -------------------------------------------------------------
  Widget _buildLoginRequiredUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "APP_PLEASE_SIGNIN_FOR_MORE_OPTIONS".tr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: "Nunito",
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "APP_LOGIN".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Nunito",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // WISHLIST BODY (only when logged in)
  // -------------------------------------------------------------
  Widget _buildWishlistBody() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.wishList.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.appNoDataFound.tr,
                  style: TextStyle(fontFamily: "Nunito"),
                ),
              );
            }

            return _buildWishlistListView();
          }),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // LIST VIEW
  // -------------------------------------------------------------
  Widget _buildWishlistListView() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: controller.wishList.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        final item = controller.wishList[index];

        return InkWell(
          onTap: () {
            controller.goToWishListItemView(
              item.uwlistId ?? "",
              item.uwlistTitle ?? "",
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// title + count
                Expanded(
                  child: Row(
                    spacing: 5,
                    children: [
                      Text(
                        item.uwlistTitle ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "(${item.products?.length ?? 0})",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                /// delete only if allowed
                if (item.uwlistType != "3")
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      showAlertMessage(
                        context,
                        title: AppStrings.appName.tr,
                        message: AppStrings.appRemoveCartItemLabel.toUpperCase().tr,
                        onOk: () {
                          controller.deleteWishlist(item.uwlistId ?? "");
                        },
                      );
                    },
                  )
                else
                  const SizedBox(width: 48), // reserve space
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // FAB BUTTON
  // -------------------------------------------------------------
  Widget _buildFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        onPressed: () async {
          final name = await showGeneralDialog<String>(
            context: context,
            barrierLabel: AppStrings.appCreateWishlist.toUpperCase().tr,
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.4),
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => CreateWishlistPopover(),
            transitionBuilder: (_, anim, __, child) {
              return SlideTransition(
                position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              );
            },
          );

          if (name != null && name.trim().isNotEmpty) {
            controller.createWishlist(name);
          }
        },
        child: Image.asset(
          "assets/images/plus.png",
          color: Colors.black,
          width: 70,
          height: 70,
        ),
      ),
    );
  }
}