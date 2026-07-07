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
import '../../core/routes/app_routes.dart';
import '../../modules/Account/account_screen.dart';
import '../../modules/Cart/order_success_page/order_success_page.dart';
import '../../modules/categories/categories_screen.dart';
import '../../modules/home/home_view.dart';
import '../../modules/product_detail/wishlist_names_view/wishlist_names_view.dart';
import '../../../utils/app_colors.dart';
import '../Cart/MainCartView.dart';
import '../wish_list/wish_list_view.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
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
            () => PopScope(
                canPop: bottomNav.currentIndex.value == 0,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;

                  if (bottomNav.currentIndex.value != 0) {
                    bottomNav.changeTab(0); // Navigate to Home tab
                  }
                },
                child: PlatformInfo.isIOS26OrHigher()
                    ? Scaffold(
                        body: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _screens[bottomNav.currentIndex.value],
                             Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0), // Shift the entire bar slightly downwards
                                child: PointerInterceptor(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CNTabBar(
                                        items: [
                                          CNTabBarItem(
                                            label: 'APP_HOME'.tr,
                                            icon: CNSymbol('house'),
                                            activeIcon: CNSymbol('house.fill'),
                                          ),
                                          CNTabBarItem(
                                            label: 'APP_CATEGORY'.tr,
                                            icon: CNSymbol('square.grid.2x2'),
                                            activeIcon: CNSymbol('square.grid.2x2.fill'),
                                          ),
                                          // Blank spacer destination to reserve the center tab slot
                                          if (hasCampaign)
                                            const CNTabBarItem(
                                              label: '',
                                              icon: null,
                                            )
                                          else
                                            CNTabBarItem(
                                              label: 'APP_WISHLIST'.tr,
                                              icon: CNSymbol('heart'),
                                              activeIcon: CNSymbol('heart.fill'),
                                            ),
                                          CNTabBarItem(
                                            label: 'APP_CART'.tr,
                                            icon: CNSymbol('cart'),
                                            activeIcon: CNSymbol('cart.fill'),
                                          ),
                                          CNTabBarItem(
                                            label: 'APP_ACCOUNT'.tr,
                                            icon: CNSymbol('person'),
                                            activeIcon: CNSymbol('person.fill'),
                                          ),
                                        ],
                                        currentIndex: bottomNav.currentIndex.value,
                                        onTap: (index) {
                                          if (index == 2 && hasCampaign) {
                                            // Handle SUMMER PICKS navigation if user clicks the blank slot area
                                            Get.toNamed(
                                              AppRoutes.productListPage,
                                              parameters: {
                                                "prodCatId": campaign?.prodcatId ?? "",
                                                "productVideoAvailable": "0",
                                                "titleHeader": campaign?.name ?? "",
                                              },
                                            );
                                          } else {
                                            // Navigate normally to the selected tab
                                            bottomNav.changeTab(index);
                                          }
                                        },
                                         split: false,
                                         rightCount: 1, // Minimum package value
                                         iconSize: 15.0, // Decreased icon size by an additional 5 points (default is 25)
                                         tint: Colors.black, // Set selected tab accent/tint color to black
                                       ),
                                      // Floating SUMMER PICKS button slightly raised above the bar
                                      if (hasCampaign)
                                        Positioned(
                                          bottom: 15, // positioned relative to the padded container bottom
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                AppRoutes.productListPage,
                                                parameters: {
                                                  "prodCatId": campaign?.prodcatId ?? "",
                                                  //  "brandId": subCat. ?? "",
                                                  "productVideoAvailable": "0",
                                                  "titleHeader": campaign?.name ?? "",
                                                },
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
                                                    color: Colors.black.withOpacity(0.15),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.center,
                                              child: ClipOval(
                                                child: Image.network(
                                                        campaign.image!,
                                                        width: 75,
                                                        height: 75,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => const Center(
                                                        ),
                                                      )
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
                      )
                    : Scaffold(
                        body: _screens[bottomNav.currentIndex.value],
                        bottomNavigationBar: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              currentIndex: bottomNav.currentIndex.value,
                              selectedItemColor: Colors.black,
                              unselectedItemColor: Colors.grey,
                              onTap: (index) {
                                if (index == 2 && hasCampaign) {
                                  Get.toNamed(
                                    AppRoutes.productListPage,
                                    parameters: {
                                      "prodCatId": campaign?.prodcatId ?? "",
                                      "productVideoAvailable": "0",
                                      "titleHeader": campaign?.name ?? "",
                                    },
                                  );
                                } else {
                                  bottomNav.changeTab(index);
                                }
                              },
                              items: [
                                BottomNavigationBarItem(
                                  icon: const Icon(CupertinoIcons.home),
                                  activeIcon: const Icon(CupertinoIcons.house_fill),
                                  label: 'APP_HOME'.tr,
                                ),
                                BottomNavigationBarItem(
                                  icon: const Icon(CupertinoIcons.square_grid_2x2),
                                  activeIcon: const Icon(CupertinoIcons.square_grid_2x2_fill),
                                  label: 'APP_CATEGORY'.tr,
                                ),
                                if (hasCampaign)
                                  const BottomNavigationBarItem(
                                    icon: SizedBox(height: 24),
                                    label: '',
                                  )
                                else
                                  BottomNavigationBarItem(
                                    icon: const Icon(CupertinoIcons.heart),
                                    activeIcon: const Icon(CupertinoIcons.heart_fill),
                                    label: 'APP_WISHLIST'.tr,
                                  ),
                                BottomNavigationBarItem(
                                  icon: const Icon(CupertinoIcons.cart),
                                  activeIcon: const Icon(CupertinoIcons.cart_fill),
                                  label: 'APP_CART'.tr,
                                ),
                                BottomNavigationBarItem(
                                  icon: const Icon(CupertinoIcons.person),
                                  activeIcon: const Icon(CupertinoIcons.person_fill),
                                  label: 'APP_ACCOUNT'.tr,
                                ),
                              ],
                            ),
                             if (hasCampaign)
                               Positioned(
                                top: -20,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.productListPage,
                                      parameters: {
                                        "prodCatId": campaign?.prodcatId ?? "",
                                        "productVideoAvailable": "0",
                                        "titleHeader": campaign?.name ?? "",
                                      },
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
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: ClipOval(
                                      child: (campaign?.image != null && campaign!.image!.isNotEmpty)
                                          ? Image.network(
                                              campaign.image!,
                                              width: 75,
                                              height: 75,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "SUMMER\n",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "PICKS",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    height: 1.1,
                                                    fontFamily: "Nunito",
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const Center(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "SUMMER\n",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "PICKS",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  height: 1.1,
                                                  fontFamily: "Nunito",
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
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