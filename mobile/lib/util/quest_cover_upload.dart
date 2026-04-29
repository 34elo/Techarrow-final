
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Server / reverse-proxy multipart limits (~1 MiB) often trigger HTTP 413.
/// Decodes cover art, optionally downscales, re-encodes as JPEG - safe to run in an isolate ([compute]).
Uint8List prepareQuestCoverUploadBytesSync(Uint8List raw) {
  if (raw.isEmpty) return raw;

  // Already small and likely acceptable for gateways.
  if (raw.length < 96 * 1024) {
    return raw;
  }

  final decoded = img.decodeImage(raw);
  if (decoded == null) {
    return raw;
  }

  const maxSide = 1920;
  const targetBytes = 750000;

  var work = decoded;
  if (work.width > maxSide || work.height > maxSide) {
    if (work.width >= work.height) {
      work = img.copyResize(
        work,
        width: maxSide,
        interpolation: img.Interpolation.linear,
      );
    } else {
      work = img.copyResize(
        work,
        height: maxSide,
        interpolation: img.Interpolation.linear,
      );
    }
  }

  var q = 88;
  var out = img.encodeJpg(work, quality: q);

  while (out.length > targetBytes && q >= 52) {
    q -= 6;
    out = img.encodeJpg(work, quality: q);
  }

  var scalePasses = 0;
  while (out.length > targetBytes && scalePasses < 5 && work.width > 440) {
    scalePasses++;
    final nw = (work.width * 0.74).round().clamp(1, 8192);
    final nh = (work.height * 0.74).round().clamp(1, 8192);
    work = img.copyResize(
      work,
      width: nw,
      height: nh,
      interpolation: img.Interpolation.average,
    );
    q = 78;
    out = img.encodeJpg(work, quality: q);
    while (out.length > targetBytes && q >= 52) {
      q -= 6;
      out = img.encodeJpg(work, quality: q);
    }
  }

  return Uint8List.fromList(out);
}

Future<Uint8List?> prepareQuestCoverForUpload(Uint8List? raw) async {
  if (raw == null || raw.isEmpty) return raw;
  if (raw.length < 96 * 1024) {
    return raw;
  }
  return compute(prepareQuestCoverUploadBytesSync, raw);
}
