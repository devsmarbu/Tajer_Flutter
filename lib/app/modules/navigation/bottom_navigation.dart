import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../modules/Account/account_screen.dart';
import '../../modules/categories/categories_screen.dart';
import '../../modules/home/home_view.dart';
import '../wish_list/wish_list_view.dart';
import '../Cart/MainCartView.dart';
import '../../modules/authentication/splash/controller/splash_controller.dart';

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
    final splashController = Get.find<SplashController>();
    final campaign = splashController.splashDataStatus.value?.floatingCampaign;
    final bool hasCampaign = campaign != null &&
        campaign.prodcatId != null &&
        campaign.prodcatId!.trim().isNotEmpty &&
        campaign.name != null &&
        campaign.name!.trim().isNotEmpty;

    return Obx(
            () {
              final currentIndex = bottomNav.currentIndex.value;
              final navKey = bottomNav.navRefreshKey.value; // subscribe so Obx rebuilds on refreshNav()
              return PopScope(
                canPop: currentIndex == 0,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;

                  if (currentIndex != 0) {
                    bottomNav.changeTab(0); // Navigate to Home tab
                  }
                },
                child: Scaffold(
                  body: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _screens[currentIndex],
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: PointerInterceptor(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                GlassTabBar.bottom(
                                  key: ValueKey('glasstabbar_$navKey'),
                                  selectedIndex: currentIndex,
                                  settings: const LiquidGlassSettings(
                                    glassColor: Colors.white,
                                  ),
                                  onTabSelected: (index) {
                                    if (index == 2 && hasCampaign) {
                                      AppRoutes.goToProductListPage(
                                        brandId: '',
                                        prodCatId: campaign.prodcatId ?? '',
                                        productVideoAvailable: '0',
                                        titleHeader: campaign.name ?? '',
                                      );
                                    } else {
                                      bottomNav.changeTab(index);
                                    }
                                  },
                                  tabs: [
                                    GlassTab(
                                      label: 'APP_HOME'.tr,
                                      icon: const Icon(CupertinoIcons.house),
                                      activeIcon: const Icon(CupertinoIcons.house_fill),
                                    ),
                                    GlassTab(
                                      label: 'APP_CATEGORY'.tr,
                                      icon: const Icon(CupertinoIcons.square_grid_2x2),
                                      activeIcon: const Icon(CupertinoIcons.square_grid_2x2_fill),
                                    ),
                                    if (hasCampaign)
                                      const GlassTab(
                                        label: '',
                                        icon: SizedBox(width: 24, height: 24),
                                      )
                                    else
                                      GlassTab(
                                        label: 'APP_WISHLIST'.tr,
                                        icon: const Icon(CupertinoIcons.heart),
                                        activeIcon: const Icon(CupertinoIcons.heart_fill),
                                      ),
                                    GlassTab(
                                      label: 'APP_CART'.tr,
                                      icon: const Icon(CupertinoIcons.cart),
                                      activeIcon: const Icon(CupertinoIcons.cart_fill),
                                    ),
                                    GlassTab(
                                      label: 'APP_ACCOUNT'.tr,
                                      icon: const Icon(CupertinoIcons.person),
                                      activeIcon: const Icon(CupertinoIcons.person_fill),
                                    ),
                                  ],
                                ),
                                if (hasCampaign)
                                  Positioned(
                                    bottom: 15,
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoutes.goToProductListPage(
                                          brandId: '',
                                          prodCatId: campaign.prodcatId ?? '',
                                          productVideoAvailable: '0',
                                          titleHeader: campaign.name ?? '',
                                        );
                                      },
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFFCD846),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: ClipOval(
                                          child: (campaign.image != null && campaign.image!.isNotEmpty)
                                              ? Image.network(
                                                  campaign.image!,
                                                  width: 75,
                                                  height: 75,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => const Center(),
                                                )
                                              : const Center(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}



class BottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt navRefreshKey = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Force-recreate the native CNTabBar by changing its Key.
  /// This mimics a hot reload for the tab bar, fixing the iOS frozen state
  /// after returning from a pushed route like PaymentWebProcessPage.
  void refreshNav() {
    navRefreshKey.value++;
  }
}