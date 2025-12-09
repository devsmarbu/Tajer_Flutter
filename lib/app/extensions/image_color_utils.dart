import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<Color?> getPixelFromImageProvider(
    ImageProvider provider, int x, int y) async {
  final Completer<ImageInfo> completer = Completer();
  final ImageStream stream = provider.resolve(const ImageConfiguration());
  final listener = ImageStreamListener((ImageInfo info, _) {
    completer.complete(info);
  });

  stream.addListener(listener);
  final imageInfo = await completer.future;
  stream.removeListener(listener);

  final ui.Image image = imageInfo.image;

  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) return null;

  final int pixelOffset = (y * image.width + x) * 4;
  final r = byteData.getUint8(pixelOffset);
  final g = byteData.getUint8(pixelOffset + 1);
  final b = byteData.getUint8(pixelOffset + 2);
  final a = byteData.getUint8(pixelOffset + 3);

  return Color.fromARGB(a, r, g, b);
}

extension ImageErrorHandler on Image {
  /// 🧩 Adds a default errorBuilder to any Image.network
  Image withDefaultError() {
    return Image.network(
      (image as NetworkImage).url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}