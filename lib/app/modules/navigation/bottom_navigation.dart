import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/utils/app_dialog.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../main_extension.dart';
import '../../modules/Account/account_screen.dart';
import '../../modules/Cart/order_success_page/order_success_page.dart';
import '../../modules/categories/categories_screen.dart';
import '../../modules/home/home_view.dart';
import '../../modules/product_detail/wishlist_names_view/wishlist_names_view.dart';
import '../../../utils/app_colors.dart';
import '../Cart/MainCartView.dart';
import '../wish_list/wish_list_view.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavController bottomNav = Get.put(BottomNavController(), permanent: true);
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    _screens.addAll([
      HomeView(onCartTap: () => Get.find<BottomNavController>().changeTab(3)),
      CategoriesScreen(),
      const WishlistNamesView(),
      const MainCartView(),
      AccountScreen(onCartTap: () => Get.find<BottomNavController>().changeTab(2)),
    ]);

    final args = Get.arguments;

    if (args != null && args is Map && args["tab"] != null) {
      final tabIndex = args["tab"];

      if (tabIndex is int) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bottomNav.changeTab(tabIndex);
        });
      }
    }

    //
    if (args != null &&
        args is Map &&
        args["msg"] != null &&
        args["msg"].toString().trim().isNotEmpty) {

      debugPrint(" Work Email Msg: ${args["msg"].toString()}");


      Future.delayed(const Duration(milliseconds: 500), () {
        Get.snackbar(
          AppStrings.APP_ERROR.tr,
          args["msg"].toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNav = Get.find<BottomNavController>();

    return Obx(
            () => PopScope(
                canPop: bottomNav.currentIndex.value == 0,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;

                  if (bottomNav.currentIndex.value != 0) {
                    bottomNav.changeTab(0); // Navigate to Home tab
                  }
                },
                child: AdaptiveScaffold(
      minimizeBehavior: TabBarMinimizeBehavior.never,
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        items: [
          // HOME
          AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS26OrHigher()
                ? "house"
                : PlatformInfo.isIOS
                ? CupertinoIcons.home
                : Icons.home_outlined,
            selectedIcon: PlatformInfo.isIOS26OrHigher()
                ? "house.fill"
                : PlatformInfo.isIOS
                ? CupertinoIcons.home
                : Icons.home,
            label: 'APP_HOME'.tr,
          ),

          // CATEGORIES
          AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS26OrHigher()
                ? "square.grid.2x2"
                : PlatformInfo.isIOS
                ? CupertinoIcons.square_grid_2x2
                : Icons.grid_view_outlined,
            selectedIcon: PlatformInfo.isIOS26OrHigher()
                ? "square.grid.2x2.fill"
                : PlatformInfo.isIOS
                ? CupertinoIcons.square_grid_2x2_fill
                : Icons.grid_view_sharp,
            label: 'APP_CATEGORY'.tr,
          ),

          // WISHLIST
          AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS26OrHigher()
                ? "heart"
                : PlatformInfo.isIOS
                ? CupertinoIcons.heart
                : Icons.favorite_border,
            selectedIcon: PlatformInfo.isIOS26OrHigher()
                ? "heart.fill"
                : PlatformInfo.isIOS
                ? CupertinoIcons.heart_fill
                : Icons.favorite,
            label: 'APP_WISHLIST'.tr,
          ),

          // CART
          AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS26OrHigher()
                ? "cart"
                : PlatformInfo.isIOS
                ? CupertinoIcons.cart
                : Icons.shopping_cart_outlined,
            selectedIcon: PlatformInfo.isIOS26OrHigher()
                ? "cart.fill"
                : PlatformInfo.isIOS
                ? CupertinoIcons.cart_fill
                : Icons.shopping_cart,
            label: 'APP_CART'.tr,
          ),

          // ACCOUNT
          AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS26OrHigher()
                ? "person"
                : PlatformInfo.isIOS
                ? CupertinoIcons.person
                : Icons.person_outline,
            selectedIcon: PlatformInfo.isIOS26OrHigher()
                ? "person"
                : PlatformInfo.isIOS
                ? CupertinoIcons.person
                : Icons.person_sharp,
            label: 'APP_ACCOUNT'.tr,
          ),
        ],
        selectedItemColor: (Platform.isAndroid || !(PlatformInfo.isIOS26OrHigher())) ? (Platform.isAndroid ? Colors.black.withValues(alpha: 0)  : Colors.black) : Colors.black,
        selectedIndex: bottomNav.currentIndex.value,
        onTap: (index) {
          setState(() {
            bottomNav.changeTab(index);
          });
        },

        useNativeBottomBar: PlatformInfo.isIOS26OrHigher(),
      ),
      body: _screens[bottomNav.currentIndex.value],
    )));
  }
}



class BottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}