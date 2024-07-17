// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class FaceAntiSpoofing2 {
//   static const String _modelFile = 'adziehrdy_FAS.tflite';
//   static const int _inputImageSize = 256;
//   static const double _threshold = 0.2;
//   late Interpreter _interpreter;

//   FaceAntiSpoofing2() {
//     _loadModel();
//   }

//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset(_modelFile);
//   }

//   Future<bool> deSpoofing(img.Image bitmap) async {
//     img.Image resizedImage =
//         img.copyResize(bitmap, width: _inputImageSize, height: _inputImageSize);
//     List<List<List<double>>> imgNormalized = _normalizeImage(resizedImage);
//     List<List<List<List<double>>>> input = [imgNormalized];

//     // Correct output shape to [1, 8]
//     List<List<double>> output =
//         List.generate(1, (_) => List.generate(8, (_) => 0.0));

//     _interpreter.run(input, output);

//     // Since the output is [1, 8], adjust the calculation accordingly
//     double sum1 = 0.0;
//     for (int i = 0; i < 8; i++) {
//       sum1 += output[0][i] * output[0][i];
//     }
//     double finalScore = sum1 / 8;

//     if (finalScore < 0.98 && finalScore > 0.6) {
//       print("FAS SCORE = " + finalScore.toString() + " === SPOOF");
//       return true;
//     } else {
//       print("FAS SCORE = " + finalScore.toString() + " === REAL");
//       return false;
//     }
//   }

//   List<List<List<double>>> _normalizeImage(img.Image bitmap) {
//     int h = bitmap.height;
//     int w = bitmap.width;
//     List<List<List<double>>> floatValues =
//         List.generate(h, (i) => List.generate(w, (j) => List.filled(3, 0.0)));

//     for (int i = 0; i < h; i++) {
//       for (int j = 0; j < w; j++) {
//         int val = bitmap.getPixel(j, i);
//         double r = ((val >> 16) & 0xFF) / 255.0;
//         double g = ((val >> 8) & 0xFF) / 255.0;
//         double b = (val & 0xFF) / 255.0;

//         floatValues[i][j] = [r, g, b];
//       }
//     }
//     return floatValues;
//   }
// }
