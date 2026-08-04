import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app_colors.dart';

mixin AppLoader {
  static bool _isDialogOpen = false;

  /// Show full screen loader
  void showLoader(BuildContext context, {String message = "Loading..."}) {
    showLoaderStatic(context, message: message);
  }

  /// Hide the loader
  void hideLoader(BuildContext context) {
    hideLoaderStatic(context);
  }

  /// Static show loader
  static void showLoaderStatic(BuildContext context, {String message = "Loading..."}) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent.withOpacity(0.4),
      builder: (_) => _AppLoaderDialog(message: message),
    );
  }

  /// Static hide loader
  static void hideLoaderStatic(BuildContext context) {
    if (_isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }
}

class _AppLoaderDialog extends StatelessWidget {
  final String message;

  const _AppLoaderDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.transparent,
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class OverlayLoader {
  static OverlayEntry? _overlayEntry;

  static void show() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      ),
    );

    Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}


class AppState {
  static bool isReady = false;
}
