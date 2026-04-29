
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Downscale + JPEG so the part is always valid `image/jpeg` for [MultipartFile].
Uint8List _encodeCoverJpeg(img.Image work) {
  const maxSide = 1920;
  const targetBytes = 750000;

  var scaled = work;
  if (scaled.width > maxSide || scaled.height > maxSide) {
    if (scaled.width >= scaled.height) {
      scaled = img.copyResize(
        scaled,
        width: maxSide,
        interpolation: img.Interpolation.linear,
      );
    } else {
      scaled = img.copyResize(
        scaled,
        height: maxSide,
        interpolation: img.Interpolation.linear,
      );
    }
  }

  var q = 88;
  var out = img.encodeJpg(scaled, quality: q);

  while (out.length > targetBytes && q >= 52) {
    q -= 6;
    out = img.encodeJpg(scaled, quality: q);
  }

  var scalePasses = 0;
  while (out.length > targetBytes && scalePasses < 5 && scaled.width > 440) {
    scalePasses++;
    final nw = (scaled.width * 0.74).round().clamp(1, 8192);
    final nh = (scaled.height * 0.74).round().clamp(1, 8192);
    scaled = img.copyResize(
      scaled,
      width: nw,
      height: nh,
      interpolation: img.Interpolation.average,
    );
    q = 78;
    out = img.encodeJpg(scaled, quality: q);
    while (out.length > targetBytes && q >= 52) {
      q -= 6;
      out = img.encodeJpg(scaled, quality: q);
    }
  }

  return Uint8List.fromList(out);
}

Future<img.Image?> _decodeWithFlutterUi(Uint8List raw) async {
  try {
    final codec = await ui.instantiateImageCodec(raw);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;
    try {
      final w = uiImage.width;
      final h = uiImage.height;
      final bd = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (bd == null || w <= 0 || h <= 0) return null;
      final expected = w * h * 4;
      if (bd.lengthInBytes < bd.offsetInBytes + expected) return null;
      return img.Image.fromBytes(
        width: w,
        height: h,
        bytes: bd.buffer,
        bytesOffset: bd.offsetInBytes,
        numChannels: 4,
        order: img.ChannelOrder.rgba,
        rowStride: w * 4,
      );
    } finally {
      uiImage.dispose();
    }
  } catch (e, st) {
    assert(() {
      debugPrint('quest cover ui decode: $e\n$st');
      return true;
    }());
    return null;
  }
}

/// Normalizes cover bytes to JPEG for upload (server / proxies expect real JPEG).
///
/// Uses the `image` package when possible; falls back to Flutter's codec (e.g. HEIC
/// on iOS) when [img.decodeImage] returns null. Always re-encodes so the file
/// matches declared `contentType: image/jpeg`.
Future<Uint8List?> prepareQuestCoverForUpload(Uint8List? raw) async {
  if (raw == null || raw.isEmpty) return raw;

  final decoded = img.decodeImage(raw) ?? await _decodeWithFlutterUi(raw);

  if (decoded == null) {
    assert(() {
      debugPrint('quest cover: decode failed (${raw.length} bytes)');
      return true;
    }());
    return raw;
  }

  return _encodeCoverJpeg(decoded);
}
