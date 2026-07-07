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
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;

  final String? actionText;
  final VoidCallback? onActionTap;

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
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.actionText,
    this.onActionTap,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  TextEditingController? _controller;
  bool _ownsController = false;
  bool _isObscure = true; // 👈 ADD THIS

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // 👈 INIT FROM WIDGET
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
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      key: Key("common text field container"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (widget.actionText != null)
                  GestureDetector(
                    onTap: widget.onActionTap,
                    child: Text(
                      widget.actionText!,
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Input Field
        TextField(
          key: Key("common text field"),
          controller: _controller,
          obscureText: _isObscure,
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines ?? 1,
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          style: TextStyle(
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.normal,
            fontSize: widget.fontSize ?? 14.0,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.offWhite2,
              fontFamily: "Nunito",
              fontWeight: FontWeight.normal,
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

            // 👇 UPDATED LOGIC
            suffixIcon: hasError
                ? Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                "assets/icons/ic_error.svg",
                height: 16,
                width: 16,
              ),
            )
                : widget.obscureText
                ? IconButton(
              icon: Icon(
                _isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
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
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}