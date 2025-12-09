import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_colors.dart';

class CommonTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;

  final String? initialValue;
  final String? errorText;
  final Function(String)? onChanged;
  final List<String>? autofillHints;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final int? maxLines;
  final double? fontSize;
  final Widget? suffixIcon;

  const CommonTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.initialValue,
    this.errorText,
    this.onChanged,
    this.obscureText = false,
    this.autofillHints,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.maxLines,
    this.fontSize,
    this.suffixIcon,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue ?? '');
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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

        // Input Field
        TextField(
          controller: _controller,
          obscureText: widget.obscureText,
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines ?? 1,
          style: TextStyle(
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontSize: widget.fontSize ?? 14.0,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.offWhite2,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500
            ),
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.redColor1 : AppColors.dashboardBgd,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.redColor1 : AppColors.dashboardBgd,
                width: 2,
              ),
            ),
            suffixIcon: hasError
                ? Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                "assets/icons/ic_error.svg",
                height: 16,
                width: 16,
              ),
            )
                : widget.suffixIcon,
          ),
        ),

        // Error message
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontFamily: "Nunito",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}