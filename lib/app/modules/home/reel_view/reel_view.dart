import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../header_view/header_view.dart';
import '../home_model.dart';
import '../reel_page_view/reel_page_view.dart';

class ReelView extends StatefulWidget {
  final List<HomeProduct> products;
  final Collection? collection;

  const ReelView({super.key, required this.products, required this.collection});

  @override
  State<ReelView> createState() => _ReelViewState();
}

class _ReelViewState extends State<ReelView>
    with AutomaticKeepAliveClientMixin {
  final Map<String, VideoPlayerController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Initialize all video controllers + allow multiple videos to play
  void _initializeControllers() {
    for (var product in widget.products) {
      final url = product.productVideoUrl ?? "";

      if (url.isEmpty) continue;
      if (_controllers.containsKey(url)) continue;

      /// 🔥 FIX: required to play multiple videos simultaneously
      final controller = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      controller
          .initialize()
          .then((_) {
            controller
              ..setLooping(true)
              ..setVolume(0)
              ..play(); // auto play

            if (mounted) setState(() {});
          })
          .catchError((error) {
            debugPrint('Error initializing video $url: $error');
          });

      _controllers[url] = controller;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderView(
          titleHeader: widget.collection?.collectionName ?? "",
          collection: widget.collection,
        ),
        const SizedBox(height: 10),
        SizedBox(height: 220, child: _buildHorizontalVideos()),
      ],
    );
  }

  /// Horizontal scrolling video items
  Widget _buildHorizontalVideos() {
    if (_controllers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: widget.products.map((product) {
        final url = product.productVideoUrl ?? "";
        final controller = _controllers[url];

        if (controller == null) {
          return Container(
            width: 120,
            margin: const EdgeInsets.all(6),
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.videocam_off)),
          );
        }

        return GestureDetector(
          onTap: () {
            final productIdsString =
                "[${widget.products.map((p) => p.productId).join(',')}]";

            Get.to(
              () => ReelPage(products: [product]),
              arguments: {
                "productVideoAvailable": "1",
                "productIds": productIdsString,
                "indexToPlayVideoFirst": 0,
              },
            );
          },
          child: Container(
            width: 120,
            margin: const EdgeInsets.all(6),

            /// 🔥 RESTORED ORIGINAL ITEM SHAPE
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,

            child: VisibilityDetector(
              key: Key(url),
              onVisibilityChanged: (info) {
                final visibleFraction = info.visibleFraction;

                if (visibleFraction > 0.5) {
                  if (!controller.value.isPlaying) controller.play();
                } else {
                  if (controller.value.isPlaying) controller.pause();
                }
              },
              child: VideoItem(controller: controller),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Keeps video alive and visible
class VideoItem extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoItem({super.key, required this.controller});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller), // Texture → multi video OK
          )
        : const Center(child: CircularProgressIndicator());
  }
}
