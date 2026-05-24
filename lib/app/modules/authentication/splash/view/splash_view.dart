import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../../utils/app_loader.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../AppStoreUpdate/AppStoreUpdate.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  VideoPlayerController? _videoController; // ✅ nullable
  late SplashController controller;
  bool _videoFinished = false;

  @override
  void initState() {
    super.initState();

    GlobalLoader.disable = true;

    controller = Get.put(SplashController(), permanent: true);
    controller.fromSplash.value = true;

    ever(controller.shouldStopVideo, (value) {
      if (value == true) {
        stopVideo();
      }
    });

    debugPrint('AppState.isReady → ${AppState.isReady}');
    debugPrint('DeepLink → $deepLinkURL');

    /// ✅ If app already ready → skip splash completely
    if (AppState.isReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.bottomNavigation);
      });
      return;
    }

    /// ✅ Initialize video ONLY if needed
    _initVideo();

    /// ✅ Deep link special handling (Android)
    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (deepLinkURL.contains('/guest-user/user-check-email-verification') &&
            AppState.isReady) {
          Get.offAllNamed(AppRoutes.bottomNavigation);
        }
      });
    }
  }

  void _initVideo() {
    _videoController = VideoPlayerController.asset(
      'assets/videos/splash.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..initialize().then((_) {
        _videoController?.play();
        _videoController?.addListener(_checkVideoCompletion);
        if (mounted) setState(() {});
      });
  }

  void _checkVideoCompletion() {
    if (AppUpdateService.instance.forceUpdateRequired.value) return;

    final v = _videoController?.value;
    if (v == null || !v.isInitialized) return;

    final position = v.position;
    final duration = v.duration;

    if (!_videoFinished &&
        duration != null &&
        position != null &&
        (position >= duration ||
            position >= duration - const Duration(milliseconds: 200))) {
      _videoFinished = true;
      _videoController?.removeListener(_checkVideoCompletion);

      /// 👉 Call APIs or navigate
      //  controller.startAllSplashApis();
    }
  }

  void stopVideo() {
    if (_videoController?.value.isInitialized ?? false) {
      _videoController?.pause();
      _videoController?.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    GlobalLoader.disable = false;

    try {
      _videoController?.removeListener(_checkVideoCompletion);
      _videoController?.dispose();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ If video not initialized → show loader
    if (_videoController == null ||
        !(_videoController?.value.isInitialized ?? false)) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!AppUpdateService.instance.forceUpdateRequired.value &&
            controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
        );
      }),
    );
  }
}