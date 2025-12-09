import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/home/change_location_view/change_location_controller.dart';
import 'package:tajer/utils/pref_store.dart';

class CountrySelectDialog extends StatefulWidget {
  final String? selectedCountryName;

  const CountrySelectDialog({
    super.key,
    this.selectedCountryName,
  });

  @override
  State<CountrySelectDialog> createState() => _CountrySelectDialogState();
}

class _CountrySelectDialogState extends State<CountrySelectDialog> {
  final controller = Get.put(ChangeLocationController());
  late TextEditingController searchController;

  String? selectedCountry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Clear previous search
    controller.resetSearch();

    searchController = TextEditingController();

    debugPrint(widget.selectedCountryName);
    // Pre-selected country from parent
    selectedCountry = widget.selectedCountryName;
    // Set selected country in the textfield
    if (widget.selectedCountryName != null) {
      searchController.text = widget.selectedCountryName!;
      // controller.searchText.value = widget.selectedCountryName!; // trigger debounce search
    }

    selectedCountry = widget.selectedCountryName;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),

            const SizedBox(height: 5),

            /// TITLE
             Text(
              (PrefStore().loadString(AppConstants.languageCode) == "AR") ? "حدد بلد التسليم الخاص بك." :
              "Select your delivery country.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,fontFamily: "Nunito"),
            ),

            const SizedBox(height: 8),

             Text(
              (PrefStore().loadString(AppConstants.languageCode) == "AR") ? "يرجى تقديم بلد التسليم الخاص بك لرؤية المنتجات المتوفرة في بلدك" :
              "Please provide your delivery country to see products available for country",
              style: TextStyle(fontSize: 14, color: Colors.black54,fontFamily: "Nunito"),
            ),

            const SizedBox(height: 22),

            /// SEARCH FIELD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              TextField(
                style: TextStyle(fontSize: 15,height: 2,fontFamily: "Nunito",fontWeight: FontWeight.w500),
                controller: searchController,
                onChanged: (value) {
                  controller.searchText.value = value;

                  // refresh UI so suffixIcon updates (show/hide X button)
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: (PrefStore().loadString(AppConstants.languageCode) == "AR") ? "بحث عن البلد" : "Search country",
                  border: InputBorder.none,
                  suffixIcon: searchController.text.isNotEmpty
                      ? InkWell(
                    onTap: () {
                      searchController.clear();            // clear input text
                      controller.searchText.value = "";    // reset debounce
                      controller.resetSearch();            // clear search results

                      setState(() {});                     // hide X button
                    },
                    child: const Icon(Icons.close, size: 20),
                  )
                      : null, // <-- when blank, remove cross button
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// RESULTS LIST (from API)
            Obx(() {
              final results = controller.countryModel.value?.results ?? [];

              if (results.isEmpty) {
                return const SizedBox(); // No list until user types
              }

              /// Dynamic height (max 200px)
              double listHeight =
              (results.length * 50).clamp(0, 200).toDouble();

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: listHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final item = results[index];

                    return ListTile(
                      dense: true,
                      title: Text(item.text ?? ""),
                      trailing: (selectedCountry == item.text)
                          ? const Icon(Icons.check, color: Colors.black)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedCountry = item.text;
                        });
                        Navigator.pop(context, item); // return Result model
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}