import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/modules/home/header_view/header_view_extension.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

class HeaderView extends StatelessWidget {
  final String titleHeader;
  final bool hideSeeAll;
  final bool isHomeHeader;
  final String? prodCatId;
  final String? productVideoAvailable;
  final Collection? collection;
  final String? currencySymbol;

  const HeaderView({
    super.key,
    this.titleHeader = "Default Title",
    this.hideSeeAll = false,
    this.isHomeHeader = true,
    this.prodCatId,
    this.productVideoAvailable,
    this.collection, this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 50,
      child: Padding(
        padding: EdgeInsets.only(left: (isHomeHeader == false) ? 10 : 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isHomeHeader == true)
              SizedBox(
                height: 30,
                width: 2,
                child: Container(color: Colors.black87),
              ),
            (isHomeHeader == true)
                ? const SizedBox(width: 10)
                : const SizedBox(width: 5),
            Text(
              titleHeader,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "Nunito",
              ),
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            if (hideSeeAll == false)
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    // Get.toNamed(
                    //   AppRoutes.productListPage,
                    //   parameters: {
                    //     "prodCatId": prodCatId ?? "",
                    //     "productVideoAvailable": productVideoAvailable ?? "0",
                    //   },
                    // );
                    HeaderViewHelper.seeAllButton(context,collection,currencySymbol);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      // 👈 background color
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // 👈 corner radius
                    ),
                    child: Text(
                      AppStrings.appSeeAll.toUpperCase().tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
