import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        // Navigate to your search results screen
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: IgnorePointer(
          // Prevents keyboard focus in this screen
          child: TextField(
            decoration: InputDecoration(
              hintText: "app_search_for_brands_products".toUpperCase().tr,
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