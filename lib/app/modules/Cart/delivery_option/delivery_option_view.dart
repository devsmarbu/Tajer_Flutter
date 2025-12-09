import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';

class ShippingPickerWidget extends StatefulWidget {
  final List<ShippingMethod> shippingMethods;
  final Function(ShippingMethod selectedMethod)? onSelected; // ✅ callback

  const ShippingPickerWidget({super.key, required this.shippingMethods, this.onSelected});

  @override
  _ShippingPickerWidgetState createState() => _ShippingPickerWidgetState();
}

class _ShippingPickerWidgetState extends State<ShippingPickerWidget> {
  int selectedIndex = 0;

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            children: [
              // Done button aligned right
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    "APP_DONE".tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    debugPrint("---------${widget.shippingMethods[selectedIndex]}----------");
                    widget.onSelected?.call(widget.shippingMethods[selectedIndex]);
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // The picker
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.grey[300],
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      debugPrint("sadfghj");
                      selectedIndex = index;
                    });
                  },
                  children: widget.shippingMethods.map((option) {
                    return Center(
                      child: Text(
                        option.title ?? "",
                        style: TextStyle(
                          color:
                              widget.shippingMethods.indexOf(option) == selectedIndex
                              ? Colors.black
                              : Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚨 If no shipping methods → show message instead of dropdown
    if (widget.shippingMethods.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), // ⬆ increased height
        margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Kindly verify the address entered, particularly the city and PIN code.",
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    // ✅ Normal dropdown UI
    return GestureDetector(
      onTap: _showPicker,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                child: Text(
                  widget.shippingMethods[selectedIndex].title ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 24),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
