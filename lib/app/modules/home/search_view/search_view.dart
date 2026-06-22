import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../product_detail/search_view/search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchView(), // Your dynamic search page
          ),
        );
      },
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffE5E5E5), // border color
            width: 1, // border width
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 6,
          //     offset: Offset(2, 2),
          //   ),
          // ],
        ),
        child: IgnorePointer(
          // Prevents keyboard focus in this screen
          child: TextField(
            decoration: InputDecoration(
              hintText: AppStrings.appSearch.toUpperCase().tr,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  "assets/icons/ic_search_new.svg",
                  height: 20,
                  width: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              suffixIcon: IconButton(
                onPressed: () {
                  print("Mic button pressed");
                },
                icon: Image.asset(
                  "assets/images/mic.png",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontFamily: "Nunito",
            ),
          ),
        ),
      ),
    );
  }
}