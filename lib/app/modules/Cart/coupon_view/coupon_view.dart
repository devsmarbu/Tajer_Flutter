import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/apply_coupon_model.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../home/header_view/header_view.dart';

class CouponInput extends StatefulWidget {
  final String couponCode;
  final Function(String) onApplyingCoupon;
  final Function() onRemovingCoupon;

  const CouponInput({
    super.key,
    required this.onApplyingCoupon,
    required this.onRemovingCoupon,
    required this.couponCode,
  });

  @override
  _CouponInputState createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final TextEditingController _controller = TextEditingController();
  bool showApply = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill text if coupon already applied

    _controller.text = widget.couponCode;
    _controller.addListener(() {
      setState(() {
        showApply = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CouponInput oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    final newCode = widget.couponCode;
    debugPrint("-----$newCode--------");
    if (_controller.text != newCode) {
      _controller.text = newCode;
      setState(() {
        showApply = newCode.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderView(
          titleHeader: AppStrings.appApplyCouponCode.toUpperCase().tr,
          hideSeeAll: true,
          isHomeHeader: false,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              controller: _controller,
              readOnly:
                  widget.couponCode.isNotEmpty ==
                  true,
              style: TextStyle(
                color: Colors.black, // Your normal text color
                fontSize: 14,
                fontFamily: "Nunito",
                fontWeight:
                    (widget.couponCode.isEmpty)
                    ? FontWeight.w400
                    : FontWeight.w600,
              ),

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: AppStrings.appEnterCouponCode.toUpperCase().tr,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "Nunito",
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.confirmation_num_outlined,
                  color: Colors.grey.shade800,
                ),
                suffixIcon: showApply
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () {
                            // 🔹 Your Apply logic here
                            if (widget.couponCode.isNotEmpty ==
                                true) {
                              widget.onRemovingCoupon();
                            } else {
                              widget.onApplyingCoupon(_controller.text);
                            }
                            // debugPrint("Apply button tapped: ${_controller.text}");
                          },
                          child: Text(
                            (widget.couponCode.isNotEmpty ==
                                    true)
                                ? AppStrings.appRemove.toUpperCase().tr
                                : AppStrings.appApply.toUpperCase().tr,
                            style: TextStyle(
                              color:
                                  (widget.couponCode.isEmpty ==
                                      true)
                                  ? Colors.red
                                  : Colors.black,
                              fontFamily: "Nunito",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 15.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
