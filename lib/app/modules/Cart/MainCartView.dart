import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/preorder_products/preorder_product_view.dart';
import 'package:tajer/marque_label.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../utils/pref_store.dart';
import '../../modules/Cart/cart_shipping/regular_products/regular_product_view.dart';

class MainCartView extends StatefulWidget {
  const MainCartView({super.key});

  @override
  State<MainCartView> createState() => _MainCartViewState();
}

class _MainCartViewState extends State<MainCartView> {
  // Control which top tab is selected
  int topTabIndex = 0;

  // Control which pill toggle is selected
  int pillToggleIndex = 1;
  int pillTopToggleIndex = 1;
  final List<Map<String, dynamic>> cartItems = [
    {
      "image": "https://via.placeholder.com/150",
      "title": "Sawary - Men’s Twill Jacket 100% Cotton - Beige",
      "size": "M",
      "seller": "Brazaria",
      "price": 185.0,
    },
    {
      "image": "https://via.placeholder.com/150",
      "title": "Sawary - Men’s Denim Jacket 100% Cotton - Blue",
      "size": "M",
      "seller": "Brazaria",
      "price": 195.0,
    },
    {
      "image": "https://via.placeholder.com/150",
      "title": "Sawary - Men’s Denim Jacket 100% Cotton - Blue",
      "size": "M",
      "seller": "Brazaria",
      "price": 195.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft, // 👈 left align
          child: Obx(
            () => Text(
                (cartItemCounts.value == '' || cartItemCounts.value == '0') ? AppStrings.appMyBag.toUpperCase().tr :
              "${AppStrings.appMyBag.toUpperCase().tr}(${cartItemCounts.value})",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Nunito",
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            /// 🔥 Marquee Label
            (PrefStore().loadString(AppConstants.promoBannerText)??'').marqueeLabel(),

            SizedBox(height: 10),
            Expanded(
              child: pillToggleIndex == 0
                  ? PreOrderCartPage(cartItems: cartItems)
                  : CartPage(cartItems: cartItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillButton(Text textWidget, int index, bool selected) {
    double screenSize = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          debugPrint(PrefStore().loadString(AppConstants.countryId));
          pillToggleIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: index == 0
              ? BorderRadius.only(
                  topLeft:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(0)
                      : Radius.circular(40),
                  bottomLeft:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(0)
                      : Radius.circular(40),
                  topRight:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(40)
                      : Radius.circular(0),
                  bottomRight:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(40)
                      : Radius.circular(0),
                )
              : BorderRadius.only(
                  topLeft:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(40)
                      : Radius.circular(0),
                  bottomLeft:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(40)
                      : Radius.circular(0),
                  topRight:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(0)
                      : Radius.circular(40),
                  bottomRight:
                      (PrefStore().loadString(AppConstants.languageCode) == "AR")
                      ? Radius.circular(0)
                      : Radius.circular(40),
                ),
        ),
        child: textWidget,
      ),
    );
  }

  Widget _buildTopPillButton(Text textWidget, int index, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          pillTopToggleIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: index == 0
              ? const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
        ),
        child: textWidget,
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  final String imagePath;
  final String message;
  final double imageSize;

  const EmptyCartWidget({
    super.key,
    required this.imagePath,
    required this.message,
    this.imageSize = 100, // default size
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: "Nunito",
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
