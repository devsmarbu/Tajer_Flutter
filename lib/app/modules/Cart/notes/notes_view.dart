import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../home/header_view/header_view.dart';

class NotesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Column(
          spacing: 0,
          children: [
        HeaderView(titleHeader: AppStrings.appNotes.toUpperCase().tr,hideSeeAll: true,isHomeHeader: false),
        Padding(padding: EdgeInsets.fromLTRB(18, 0, 15, 0)
        ,child:
            Text(
              AppStrings.appCartNote.toUpperCase().tr,
              style: TextStyle(fontSize: 12, color: Colors.black.withValues(alpha: 0.75),fontFamily: "Nunito"),
              maxLines: null,         // Allows unlimited lines
              softWrap: true,        // Wrap text if needed
            )
        ),
        SizedBox(height: 20)
      ]);
  }
}