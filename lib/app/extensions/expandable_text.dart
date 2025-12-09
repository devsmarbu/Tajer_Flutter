import 'package:flutter/material.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/utils/pref_store.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 4,
    this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🔹 Measure text overflow based on available width
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                widget.text,
                maxLines: widget.trimLines,
                overflow: TextOverflow.ellipsis,
                style: widget.style,
              ),
              secondChild: Text(widget.text, style: widget.style),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    (PrefStore().loadString(AppConstants.languageCode) ==
                        "AR") ?
                    (_isExpanded ? "انظر أقل" : "شاهد المزيد") :
                    (_isExpanded ? "See less" : "See more"),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Nunito",
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}