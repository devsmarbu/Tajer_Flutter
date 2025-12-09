import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/address/addAddress/models/country_item.dart';
import 'package:tajer/app/modules/address/addAddress/models/state_item.dart';
import '../../../utils/app_colors.dart';

class CommonDropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final List<CountryItem> countryList;
  final List<StateItem> stateList;
  final dynamic value;
  final String? errorText;
  final ValueChanged<dynamic>? onChanged;
  final Color? backgroundColor;
  final Widget? suffixIcon;

  const CommonDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.countryList,
    required this.stateList,
    this.value,
    this.errorText,
    this.onChanged,
    this.backgroundColor,
    this.suffixIcon,
  });

  @override
  State<CommonDropdownField> createState() => _CommonDropdownFieldState();
}

class _CommonDropdownFieldState extends State<CommonDropdownField> {
  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final isCountryDropdown = widget.countryList.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        GestureDetector(
          onTap: () => _openSearchModal(context, isCountryDropdown),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasError ? AppColors.redColor1 : AppColors.dashboardBgd,
                width: 1,
              ),
              color: widget.backgroundColor ?? Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? (isCountryDropdown
                        ? widget.value.name ?? ""
                        : widget.value.name ?? "")
                        : widget.hint,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.value == null
                          ? AppColors.offWhite2
                          : Colors.black,
                    ),
                  ),
                ),
                widget.suffixIcon ??
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey),
              ],
            ),
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontFamily: "Nunito",
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // -----------------------------------------------------
  // SEARCH MODAL BOTTOM SHEET
  // -----------------------------------------------------
  void _openSearchModal(BuildContext context, bool isCountry) {
    List<dynamic> list = isCountry ? widget.countryList : widget.stateList;
    List<dynamic> filteredList = List.from(list);

    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  // SEARCH FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "APP_SEARCH".tr,
                        prefixIcon: Icon(Icons.search),
                        // Default state
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // Focused state
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // Error state (optional)
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filteredList = list
                              .where((item) => item.name!
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // LIST VIEW
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (_, index) {
                        final item = filteredList[index];

                        return ListTile(
                          title: Text(item.name ?? ""),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onChanged?.call(item);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}