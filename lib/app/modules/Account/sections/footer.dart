import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';

/// Footer section
class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   "Version 7.4.2",
        //   style: TextStyle(color: Colors.grey, fontSize: 12),
        // ),
        SizedBox(height: 4),
        Text(
          AppStrings.app_tajer_com_all_rights_reserved.toUpperCase().tr,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

}