import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/home/reel_page_view/reel_page_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../core/routes/app_routes.dart';
import '../../product_detail/select_size/select_size_controller.dart';
import '../../product_detail/select_size/select_size_view.dart';
import '../../product_detail/share_activity/share_activity_view.dart';
import '../home_model.dart';

// ---------------- REEL PAGE ----------------
class ReelPage extends StatefulWidget {
  final List<HomeProduct> products;

  const ReelPage({super.key, required this.products});

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  final PageController _pageController = PageController();
  final Map<String, VideoPlayerController> _playerCache = {};
  final Map<String, Future<void>> _initializationFutures = {};

  final _controller = Get.put(ReelPageController());

  int currentIndex = 0;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Show the tapped product immediately
    _controller.setInitialProducts(widget.products);

    // 2️⃣ Play it instantly
    if (_controller.products.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _playInitialVideo();
          _preloadNext();
        }
      });
    }

    // 3️⃣ Fetch more products AFTER first frame is rendered
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.loadProducts();
    });
  }

  void _playInitialVideo() {
    final url = _controller.products[0].productVideoUrl ?? "";
    final controller = _getController(url);

    // Add listener to wait for initialization before playing
    void listener() {
      if (controller.value.isInitialized) {
        controller.setLooping(true);
        controller.setVolume(isMuted ? 0 : 1);
        controller.seekTo(const Duration());
        controller.play();
        controller.removeListener(listener);
        if (mounted) setState(() {});
      }
    }

    controller.addListener(listener);
  }

  void _preloadNext() {
    final nextIndex = currentIndex + 1;
    if (nextIndex < _controller.products.length) {
      final nextUrl = _controller.products[nextIndex].productVideoUrl ?? "";
      _getController(nextUrl, notifyOnInit: false);
    }
  }

  Future<void> _initializeController(
      VideoPlayerController controller,
      String url,
      bool notifyOnInit,
      ) async {
    if (_initializationFutures.containsKey(url)) {
      return _initializationFutures[url];
    }

    final completer = Completer<void>();
    _initializationFutures[url] = completer.future;

    controller
        .initialize()
        .then((_) {
      controller
        ..setLooping(true)
        ..setVolume(isMuted ? 0 : 1);
      if (notifyOnInit && mounted) setState(() {});
      completer.complete();
    })
        .catchError((error) {
      debugPrint("⚠️ Error initializing video for $url: $error");
      if (!completer.isCompleted) completer.completeError(error);
    })
        .whenComplete(() {
      _initializationFutures.remove(url);
    });

    return completer.future;
  }

  VideoPlayerController _getController(String url, {bool notifyOnInit = true}) {
    if (_playerCache.containsKey(url)) {
      // Cache hit: Reuse existing controller (already initialized or initializing)
      // This ensures instant playback for repeated URLs without reinitialization
      final controller = _playerCache[url]!;
      if (!controller.value.isInitialized &&
          !_initializationFutures.containsKey(url)) {
        _initializeController(controller, url, notifyOnInit);
      }
      return controller;
    } else {
      // Cache miss: Create new controller and initialize
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _playerCache[url] = controller;
      _initializeController(controller, url, notifyOnInit);
      return controller;
    }
  }

  void _pauseAndResetOthers(String currentUrl) {
    _playerCache.forEach((url, controller) {
      if (url != currentUrl) {
        if (controller.value.isInitialized) {
          controller.pause();
          controller.seekTo(const Duration());
        }
      }
    });
  }

  Future<void> _playCurrentVideo(String currentUrl) async {
    final controller = _getController(currentUrl);

    // Wait for initialization if not already done (for new caches)
    // For cached/reused URLs, this is instant since already initialized
    if (!controller.value.isInitialized) {
      await controller.initialize();
    }

    // Now safe to seek and play (instant for cached videos)
    await controller.seekTo(const Duration());
    controller.setLooping(true);
    controller.setVolume(isMuted ? 0 : 1);
    controller.play();
  }

  @override
  void dispose() {
    for (final controller in _playerCache.values) {
      controller.dispose();
    }
    _playerCache.clear();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final products = _controller.products;

        if (products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return PageView.builder(
          key: ValueKey(products.length),
          // 👈 rebuilds safely when count changes
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: products.length,
          onPageChanged: (index) async {
            setState(() => currentIndex = index);
            final currentUrl = products[index].productVideoUrl ?? "";

            // Pause and reset others
            _pauseAndResetOthers(currentUrl);

            // Play current one
            unawaited(_playCurrentVideo(currentUrl));

            // Preload next video early
            _preloadNext();

            debugPrint("page changing :- $index");
            debugPrint("product length :- ${products.length}");
            debugPrint("hasMore value :- ${_controller.hasMore.value}");
            // debugPrint("isLoading value :- ${_controller.isLoading.value}");
            // ✅ Safe auto-load trigger
            if (
            _controller.hasMore.value &&
                index >= products.length - 1) {
              debugPrint("📥 Auto-loading more reels...");
              unawaited(_controller.loadMoreProducts());
            }
          },
          itemBuilder: (context, index) {
            final product = products[index];
            final controller = _getController(product.productVideoUrl ?? "");

            return ReelCell(
              product: product,
              controller: controller,
              isMuted: isMuted,
              onMuteChanged: (muted) {
                setState(() => isMuted = muted);
                for (final c in _playerCache.values) {
                  if (c.value.isInitialized) {
                    c.setVolume(muted ? 0 : 1);
                  }
                }
              },
            );
          },
        );
      }),
    );
  }
}

// ---------------- REEL CELL ----------------

class ReelCell extends StatefulWidget {
  final HomeProduct product;
  final VideoPlayerController controller;
  final bool isMuted;
  final Function(bool) onMuteChanged;

  const ReelCell({
    super.key,
    required this.product,
    required this.controller,
    required this.isMuted,
    required this.onMuteChanged,
  });

  @override
  State<ReelCell> createState() => _ReelCellState();
}

class _ReelCellState extends State<ReelCell> {
  bool _showVolumeIcon = false;
  late bool _isMuted;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _isMuted = widget.isMuted;
  }

  void _toggleVolume() {
    setState(() {
      _isMuted = !_isMuted;
      _showVolumeIcon = true;
    });

    // Apply volume change
    widget.controller.setVolume(_isMuted ? 0 : 1);
    widget.onMuteChanged(_isMuted);

    // Reset hide timer
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showVolumeIcon = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: _toggleVolume, // 👈 tap anywhere on video
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🎥 Background video
          ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, VideoPlayerValue value, child) {
              // final showLoader = !value.isInitialized || value.isBuffering;

              return Stack(
                fit: StackFit.expand,
                children: [
                  if (value.isInitialized)
                    AnimatedOpacity(
                      opacity: /*showLoader ? 0.0 :*/ 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: FittedBox(
                        fit: BoxFit.cover, // or BoxFit.contain for full video
                        child: SizedBox(
                          width: widget.controller.value.size.width,
                          height: widget.controller.value.size.height,
                          child: AspectRatio(
                            aspectRatio: widget.controller.value.aspectRatio,
                            child: VideoPlayer(widget.controller),
                          ),
                        ),
                      ),
                    ),
                  // if (showLoader)
                  //   const Center(
                  //     child: CircularProgressIndicator(color: Colors.white),
                  //   ),
                ],
              );
            },
          ),

          // 🧭 Top bar (Back + Title)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Row(
              children: [
                _glassButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: Text(
                      product.brandName ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // 🔇 Centered fade-in/fade-out volume icon
          if (_showVolumeIcon)
            Center(
              child: AnimatedOpacity(
                opacity: _showVolumeIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),

          // 🏪 Shop logo + name (above product card)
          Positioned(
            left: 16,
            bottom: 190,
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image(image: NetworkImage(product.shopLogoUrl ?? "")),
                ),
                const SizedBox(width: 10),
                Text(
                  product.shopName ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),

          // 🧾 Product info card (bottom)
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Product text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.productDetail,
                              arguments: {"productId": product.selprodId,"titleHeader": product.selprodTitle},
                            );
                          },
                          child: Text(
                            product.productName ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                              decoration: TextDecoration.underline, // optional styling
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.selprodPrice ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product.brandName ?? "",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product image + add button
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/placeholder_image.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        // Image.network(
                        //   product.imageUrl,
                        //   width: 60,
                        //   height: 60,
                        //   fit: BoxFit.cover,
                        // ),
                      ),

                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () {
                            // final productId = product.selprodId ?? "";
                            // final sizeController = Get.put(
                            //   SelectSizeController(productId),
                            // );
                            // sizeController.addToCart(productId);
                            final options = product.productOptions;
                            if (options != null && options.isNotEmpty) {
                              final firstOptionValues =
                                  options.first.values ?? [];
                              if (firstOptionValues.isNotEmpty) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => SelectSizeView(
                                    price: product.selprodPrice ?? "",
                                    productId: product.productId ?? "",
                                    productOptions: firstOptionValues,
                                    currencyCode: product.selprodPrice?.replaceAll(RegExp(r'[0-9.]'), '') ?? "\$",
                                  ),
                                );
                              } else {
                                final sizeController = Get.put(SelectSizeController(product.selprodId ?? ''));
                                sizeController.addToCart(product.selprodId ?? '');
                              }
                            } else {
                              final sizeController = Get.put(SelectSizeController(product.selprodId ?? ''));
                              sizeController.addToCart(product.selprodId ?? '');
                            }

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/AddToCart.png",
                              height: 25,
                              width: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 📤 Share button (bottom-right)
          Positioned(
            right: 16,
            bottom: 180,
            child: GestureDetector(
              onTap: ()  {
                debugPrint("Share: ${product.productDetailUrl}");
                ShareProductUtil.shareProduct(
                  context: context,
                  productUrl: product.productDetailUrl ?? "",
                  productTitle: product.selprodTitle ?? "",
                  // assetImagePath: "assets/images/app_logo.png",
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      "assets/images/shareIcon.png",
                      height: 22,
                      width: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Share",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glass-style back button
  Widget _glassButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
