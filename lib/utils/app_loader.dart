import 'package:flutter/material.dart';

import 'app_colors.dart';

mixin AppLoader {
  static bool _isDialogOpen = false;

  /// Show full screen loader
  void showLoader(BuildContext context, {String message = "Loading..."}) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent.withOpacity(0.4),
      builder: (_) => _AppLoaderDialog(message: message),
    );
  }

  /// Hide the loader
  void hideLoader(BuildContext context) {
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
                  CircularProgressIndicator(),
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
