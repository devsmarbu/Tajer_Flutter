import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';

import '../cart_shipping/apply_coupon_model.dart';

class RewardPointsView extends StatefulWidget {
  final ApplyCouponCartSummary? cartSummary;
  final String rewardPoints;
  final String canBeUseRP;
  final String usedRewardPoints;
  final Function(String rewardPoints) applyRewardPoints; // ✅ callback
  final Function() onRemovingCoupon;

  const RewardPointsView({
    super.key,
    required this.rewardPoints,
    required this.canBeUseRP,
    required this.applyRewardPoints,
    this.cartSummary,
    required this.onRemovingCoupon,
    required this.usedRewardPoints,
  });

  @override
  _RewardPointsViewState createState() => _RewardPointsViewState();
}

class _RewardPointsViewState extends State<RewardPointsView> {
  final TextEditingController _controller = TextEditingController();
  bool showApply = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill text if coupon already applied
    final code = widget.usedRewardPoints;

    if (code != "0") {
      _controller.text = code;
    }

    _controller.addListener(() {
      setState(() {
        final txt = _controller.text.trim();

        showApply = txt.isNotEmpty &&
            txt != "0" &&
            widget.usedRewardPoints == "0";
      });
    });

    debugPrint("this is the applied reward points :- ${widget.usedRewardPoints}");
    debugPrint("is controller text empty :- ${_controller.text.isNotEmpty}");
    debugPrint("controller text :- ${_controller.text}");
  }

  @override
  void didUpdateWidget(covariant RewardPointsView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    final newCode = widget.usedRewardPoints;
    if (_controller.text != newCode) {
      if (newCode != "0") {
        _controller.text = newCode;
      }
      setState(() {
        final txt = _controller.text.trim();

        showApply = txt.isNotEmpty &&
            txt != "0" &&
            newCode == "0";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              spacing: 15,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/gift.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppStrings.appRewardPoint.toUpperCase().tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.rewardPoints,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners here
                  ),
                  child: TextField(
                    controller: _controller,
                    readOnly: (widget.usedRewardPoints != "0"),
                    style: TextStyle(
                      color: Colors.black, // Your normal text color
                      fontSize: 14,
                      fontFamily: "Nunito",
                      fontWeight: (widget.usedRewardPoints == "0")
                          ? FontWeight.w400
                          : FontWeight.w600,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: AppStrings.appEnterPointsToRedeem.toUpperCase().tr,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "Nunito",
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.confirmation_num_outlined,
                        color: Colors.grey.shade800,
                      ),
                      suffixIcon: (widget.usedRewardPoints != "0")
                          ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: widget.onRemovingCoupon,
                          child: Text(
                            AppStrings.appRemove.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      )
                          : (_controller.text.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () =>
                              widget.applyRewardPoints(_controller.text),
                          child: Text(
                            AppStrings.appApply.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      )
                          : null),

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
                Text(
                  "You have total ${widget.rewardPoints} points but you can redeem ${widget.canBeUseRP} at one time",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
