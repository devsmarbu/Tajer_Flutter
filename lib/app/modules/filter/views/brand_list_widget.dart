import 'package:flutter/material.dart';
import '../../../../../utils/app_colors.dart';

class OptionsList {
  final String optionName;
  final String optionId;

  OptionsList({
    required this.optionName,
    required this.optionId,
  });
}

class BrandListWidget extends StatelessWidget {
  final List<OptionsList> items;
  final Map<String, bool> selectedItems;
  final Map<String, bool> selectedIds;
  final Function(String, bool) onChanged;
  final bool isMultipleSelection;

  const BrandListWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.selectedIds,
    required this.onChanged,
    this.isMultipleSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: items.map((item) {
          final isSelected = selectedItems[item.optionId] ?? false;

          return InkWell(
            onTap: () {
              onChanged(item.optionId, !isSelected);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Row(
                children: [
                  !isMultipleSelection
                      ? RadioGroup<String>(
                    groupValue: selectedItems.entries
                        .firstWhere(
                          (e) => e.value,
                      orElse: () => const MapEntry("", false),
                    )
                        .key,
                    onChanged: (selectedKey) {
                      onChanged(selectedKey!, true);
                    },
                    child: Radio(value: item.optionId),
                  )
                      : Checkbox(
                    value: isSelected,
                    onChanged: (val) =>
                        onChanged(item.optionId, val ?? false),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.optionName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.black1,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}