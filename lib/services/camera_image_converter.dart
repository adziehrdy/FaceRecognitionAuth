import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';

/// Helper untuk convert CameraImage ke InputImage (MLKit)
class CameraImageConverter {
  /// Convert CameraImage ke InputImage
  static InputImage? toInputImage({
    required CameraImage image,
    required InputImageRotation rotation,
  }) {
    try {
      // Ambil semua byte dari plane
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // Deteksi format yang valid
      final format = _detectFormat(image);

      // Buat metadata
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint("⚠️ CameraImageConverter Error: $e");
      return null;
    }
  }

  /// Deteksi format gambar dari CameraImage
  static InputImageFormat _detectFormat(CameraImage image) {
    // Android biasanya YUV_420_888, iOS bisa BGRA8888
    switch (image.format.group) {
      case ImageFormatGroup.yuv420:
        return InputImageFormat.nv21; // aman di Android
      case ImageFormatGroup.bgra8888:
        return InputImageFormat.bgra8888; // aman di iOS
      default:
        return InputImageFormat.nv21; // fallback
    }
  }
}
