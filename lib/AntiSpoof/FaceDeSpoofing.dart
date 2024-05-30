// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class FaceDeSpoofing {
//   static const String MODEL_FILE = "FaceDeSpoofing.tflite";
//   static const int INPUT_IMAGE_SIZE = 256;
//   static const double THRESHOLD = 0.5;

//   late Interpreter interpreter;

//   FaceDeSpoofing(AssetManager assetManager) {
//     interpreter = Interpreter.fromAsset(MODEL_FILE);
//   }

//   Future<double> deSpoofing(ui.Image image) async {
//     img.Image imgLib = img.Image.fromBytes(
//         image.width, image.height, await _imageToByteList(image));

//     img.Image resizedImage = img.copyResize(imgLib,
//         width: INPUT_IMAGE_SIZE, height: INPUT_IMAGE_SIZE);

//     List<List<List<double>>> imgData = normalizeImage(resizedImage);

//       interpreter = await Interpreter.fromAsset(MODEL_FILE);

//     var output = List.generate(
//         1,
//         (index) => List.generate(
//             32,
//             (index) => List.generate(
//                 32, (index) => List.generate(1, (index) => 0.0))));

//     interpreter.run(input.buffer, output.buffer);

//     double sum1 = 0;
//     for (int i = 0; i < 32; i++) {
//       double sum2 = 0;
//       for (int j = 0; j < 32; j++) {
//         sum2 += pow(output[0][i][j][0], 2);
//       }
//       sum1 += sum2 / 32;
//     }
//     return sum1 / 32;
//   }

//   List<List<List<double>>> normalizeImage(img.Image bitmap) {
//     int h = bitmap.height;
//     int w = bitmap.width;
//     List<List<List<double>>> floatValues = List.generate(
//         h, (i) => List.generate(w, (j) => List.generate(6, (k) => 0.0)));

//     double imageStd = 256;

//     for (int i = 0; i < h; i++) {
//       for (int j = 0; j < w; j++) {
//         int val = bitmap.getPixel(j, i);
//         List<double> hsv = rgbToHsv(val);

//         double hue = hsv[0] / 360;
//         double s = hsv[1];
//         double v = hsv[2];

//         double r = (img.getRed(val) / imageStd);
//         double g = (img.getGreen(val) / imageStd);
//         double b = (img.getBlue(val) / imageStd);

//         floatValues[i][j] = [hue, s, v, r, g, b];
//       }
//     }
//     return floatValues;
//   }

//   List<double> rgbToHsv(int rgb) {
//     double r = img.getRed(rgb) / 255.0;
//     double g = img.getGreen(rgb) / 255.0;
//     double b = img.getBlue(rgb) / 255.0;

//     double max = max(max(r, g), b);
//     double min = min(min(r, g), b);

//     double h, s, v = max;

//     double d = max - min;
//     s = max == 0 ? 0 : d / max;

//     if (max == min) {
//       h = 0; // achromatic
//     } else {
//       if (max == r) {
//         h = (g - b) / d + (g < b ? 6 : 0);
//       } else if (max == g) {
//         h = (b - r) / d + 2;
//       } else if (max == b) {
//         h = (r - g) / d + 4;
//       }
//       h /= 6;
//     }
//     return [h * 360, s, v];
//   }

//   Future<Uint8List> _imageToByteList(ui.Image image) async {
//     ByteData byteData =
//         await img.Image.toByteData(format: ui.ImageByteFormat.rawRgba);
//     return byteData.buffer.asUint8List();
//   }
// }
