import 'package:flutter/material.dart';

class CommonLoader extends StatelessWidget {
  final bool isLoading;
  final Color backgroundColor;
  final Color loaderColor;

  const CommonLoader({
    super.key,
    required this.isLoading,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0.4),
    this.loaderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        /// Semi-transparent dark overlay
        Positioned.fill(
          child: Container(
            color: backgroundColor,
          ),
        ),

        /// Centered loader
        const Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      ],
    );
  }
}
