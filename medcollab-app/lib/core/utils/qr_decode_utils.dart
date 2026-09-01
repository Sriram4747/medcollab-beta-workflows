import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

/// Pure-Dart QR decode from image bytes (zxing2).
abstract final class QrDecodeUtils {
  static String? decodeFromBytes(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final sample = decoded.width > 1000
        ? img.copyResize(decoded, width: 1000)
        : decoded;
    final pixels = sample
        .convert(numChannels: 4)
        .getBytes(order: img.ChannelOrder.abgr)
        .buffer
        .asInt32List();
    final source = RGBLuminanceSource(sample.width, sample.height, pixels);
    final reader = QRCodeReader();
    try {
      return reader
          .decode(BinaryBitmap(GlobalHistogramBinarizer(source)))
          .text;
    } catch (_) {
      try {
        return reader.decode(BinaryBitmap(HybridBinarizer(source))).text;
      } catch (_) {
        return null;
      }
    }
  }
}
