import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/apply_coupon_model.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../home/header_view/header_view.dart';

class CouponInput extends StatefulWidget {
  final String couponCode;
  final String errorMessage;
  final Function(String) onApplyingCoupon;
  final Function()? onTextChanged;
  final Function() onRemovingCoupon;
  final bool isLoading;

  const CouponInput({
    super.key,
    required this.onApplyingCoupon,
    required this.onRemovingCoupon,
    required this.couponCode,
    required this.errorMessage,
    required this.onTextChanged,
    required this.isLoading,
  });

  @override
  _CouponInputState createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final TextEditingController _controller = TextEditingController();
  bool showApply = false;
  bool isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill text if coupon already applied

    _controller.text = widget.couponCode;
    _controller.addListener(() {
      setState(() {
        showApply = _controller.text.isNotEmpty;
      });
      if (!isProgrammaticChange) {
        widget.onTextChanged?.call();
      } // clear error while typing
    });
  }

  @override
  void didUpdateWidget(covariant CouponInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newCode = widget.couponCode;

    if (_controller.text != newCode) {
      isProgrammaticChange = true;

      _controller.text = newCode;

      showApply = newCode.isNotEmpty;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        isProgrammaticChange = false;
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HeaderView(
          titleHeader: AppStrings.appApplyCouponCode.toUpperCase().tr,
          hideSeeAll: true,
          isHomeHeader: false,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _controller,
                  readOnly: widget.couponCode.isNotEmpty == true,
                  style: TextStyle(
                    color: widget.couponCode.isNotEmpty
                        ? Colors.green
                        : Colors.black,
                    fontSize: 14,
                    fontFamily: "Nunito",
                    fontWeight: (widget.couponCode.isEmpty)
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
                      color: widget.couponCode.isNotEmpty
                          ? Colors.green
                          : Colors.grey.shade800,
                    ),

                    suffixIcon: (_controller.text.isNotEmpty || widget.isLoading)
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextButton(
                              onPressed: widget.isLoading
                                  ? null
                                  : () {
                                      if (widget.couponCode.isNotEmpty ==
                                          true) {
                                        widget.onRemovingCoupon();
                                      } else {
                                        widget.onApplyingCoupon(
                                          _controller.text,
                                        );
                                      }
                                    },
                              child: widget.isLoading
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text(
                                      (widget.couponCode.isNotEmpty == true)
                                          ? AppStrings.appRemove
                                                .toUpperCase()
                                                .tr
                                          : AppStrings.appApply
                                                .toUpperCase()
                                                .tr,
                                      style: TextStyle(
                                        color:
                                            (widget.couponCode.isEmpty == true)
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

              if (widget.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    widget.errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
