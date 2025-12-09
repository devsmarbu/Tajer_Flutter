import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../../common/widgets/restart_widget.dart';
import '../../AppStoreUpdate/AppStoreUpdate.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late VideoPlayerController _videoController;
  late SplashController controller;
  bool _videoFinished = false;

  @override
  void initState() {
    super.initState();

    controller = Get.put(SplashController(), permanent: true);
    controller.fromSplash.value = true;

    _videoController = VideoPlayerController.asset(
      'assets/videos/splash.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true), // 🔥 important !!
    )
      ..initialize().then((_) {
        _videoController.setVolume(0); // no audio conflict
        _videoController.play();
        _videoController.addListener(_checkVideoCompletion);
        setState(() {});
      });
  }

  void _checkVideoCompletion() {
    /// 🔥 STOP ALL LOGIC if force update is active
    if (AppUpdateService.instance.forceUpdateRequired.value) return;

    final v = _videoController.value;

    if (!_videoFinished && v.isInitialized) {
      final position = v.position;
      final duration = v.duration;

      if (duration != null &&
          position != null &&
          (position >= duration ||
              position >=
                  duration - const Duration(milliseconds: 200))) {
        _videoFinished = true;
        _videoController.removeListener(_checkVideoCompletion);

        /// Wait 2 sec then run APIs (if NOT force update)
        Future.delayed(const Duration(seconds: 2), () async {
          if (!AppUpdateService.instance.forceUpdateRequired.value) {
            await controller.startAllSplashApis();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    if (!_videoFinished) {
      try {
        _videoController.removeListener(_checkVideoCompletion);
      } catch (_) {}
    }
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        /// 🔥 OPTIONAL: show loader only if APIs running AND not force update
        if (!AppUpdateService.instance.forceUpdateRequired.value &&
            controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_videoController.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
        );
      }),
    );
  }
}