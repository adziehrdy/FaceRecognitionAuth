import 'dart:typed_data';

import 'package:face_net_authentication/globals.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';

imglib.Image convertToImage(CameraImage image) {
  try {
    switch (image.format.group) {
      case ImageFormatGroup.yuv420:
        return _convertYUV420(image);
      case ImageFormatGroup.bgra8888:
        return _convertBGRA8888(image);
      case ImageFormatGroup.jpeg:
        return _convertJPEGToImage(image);
      case ImageFormatGroup.nv21:
        return _convertNV21ToImage(image);
      default:
        showToast(
            "format gambar dari kamera tidak dissuport${image.format.group}");
        print('Unsupported image format: ${image.format.group}');
        throw Exception('Image format not supported');
    }
  } catch (e) {
    print("ERROR:" + e.toString());
  }
  throw Exception('Image format not supported');
}

imglib.Image _convertJPEGToImage(CameraImage cameraImage) {
  return imglib.decodeJpg(cameraImage.planes[0].bytes)!;
}

imglib.Image _convertBGRA8888(CameraImage image) {
  return imglib.Image.fromBytes(
    image.width,
    image.height,
    image.planes[0].bytes,
    format: imglib.Format.bgra,
  );
}

imglib.Image _convertYUV420(CameraImage image) {
  int width = image.width;
  int height = image.height;
  var img = imglib.Image(width, height);
  const int hexFF = 0xFF000000;
  final int uvyButtonStride = image.planes[1].bytesPerRow;
  final int? uvPixelStride = image.planes[1].bytesPerPixel;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride! * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
      final int index = y * width + x;
      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      img.data[index] = hexFF | (b << 16) | (g << 8) | r;
    }
  }

  return img;
}

imglib.Image _convertNV21ToImage(CameraImage image) {
  final width = image.width.toInt();
  final height = image.height.toInt();
  Uint8List yuv420sp = image.planes[0].bytes;

  // Initial conversion from NV21 to RGB
  final outImg = imglib.Image(height, width); // Note the swapped dimensions
  final int frameSize = width * height;

  for (int j = 0, yp = 0; j < height; j++) {
    int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    for (int i = 0; i < width; i++, yp++) {
      int y = (0xff & yuv420sp[yp]) - 16;
      if (y < 0) y = 0;
      if ((i & 1) == 0) {
        v = (0xff & yuv420sp[uvp++]) - 128;
        u = (0xff & yuv420sp[uvp++]) - 128;
      }
      int y1192 = 1192 * y;
      int r = (y1192 + 1634 * v);
      int g = (y1192 - 833 * v - 400 * u);
      int b = (y1192 + 2066 * u);

      if (r < 0) {
        r = 0;
      } else if (r > 262143) r = 262143;
      if (g < 0) {
        g = 0;
      } else if (g > 262143) g = 262143;
      if (b < 0) {
        b = 0;
      } else if (b > 262143) b = 262143;

      outImg.setPixelRgba(j, width - i - 1, ((r << 6) & 0xff0000) >> 16,
          ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
    }
  }

  final flippedImg = imglib.flip(outImg, imglib.Flip.vertical);

  // Rotate the image by 90 degrees if needed
  return imglib.copyRotate(flippedImg, 90);

  // return outImg;
  // return imglib.copyRotate(outImg, 90);
  // Rotate the image by 90 degrees (or 270 degrees if needed)
  // return imglib.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
}
