// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// import 'image_converter.dart';

// class FaceDeSpoofing {
//   static const String _modelFile = 'FaceDeSpoofing.tflite';
//   static const int inputImageSize = 256;
//   static const double threshold = 0.99;
//   static const bool landscape_mode = true;

//   late Interpreter interpreter;

//   FaceDeSpoofing() {
//     _loadModel();
//   }

//   void _loadModel() async {
//     interpreter = await Interpreter.fromAsset(_modelFile);
//   }

//   Future<bool> deSpoofing(img.Image bitmap) async {
//     img.Image bitmapScale = img.copyResizeCropSquare(bitmap, inputImageSize);

//     List<List<List<double>>> imgNormalized = _normalizeImage(bitmapScale);

//     List input = new List.generate(1, (index) => List.filled(8, 0.0), growable: true);

//     input[0] = imgNormalized.reshape([1, inputImageSize, inputImageSize, 3]);

//     List clssPred = new List.generate(1, (index) => List.filled(8, 0.0));
//     List leafNodeMask = new List.generate(1, (index) => List.filled(8, 0.0));

//     Map<int, Object> outputs = new Map<int, Object>();

//     outputs[interpreter.getOutputIndex("Identity")] = clssPred;
//     outputs[interpreter.getOutputIndex("Identity_1")] = leafNodeMask;

//     if (input.isNotEmpty &&
//         outputs.isNotEmpty &&
//         input.length > 0 &&
//         outputs.length > 0) {
//       interpreter.runForMultipleInputs(input, outputs);

//       print("FaceAntiSpoofing" +
//           "[" +
//           clssPred[0][0].toString() +
//           ", " +
//           clssPred[0][1].toString() +
//           ", " +
//           clssPred[0][2].toString() +
//           ", " +
//           clssPred[0][3].toString() +
//           ", " +
//           clssPred[0][4].toString() +
//           ", " +
//           clssPred[0][5].toString() +
//           ", " +
//           clssPred[0][6].toString() +
//           ", " +
//           clssPred[0][7].toString() +
//           "]\n");
//       print("FaceAntiSpoofing" +
//           "[" +
//           leafNodeMask[0][0].toString() +
//           ", " +
//           leafNodeMask[0][1].toString() +
//           ", " +
//           leafNodeMask[0][2].toString() +
//           ", " +
//           leafNodeMask[0][3].toString() +
//           ", " +
//           leafNodeMask[0][4].toString() +
//           ", " +
//           leafNodeMask[0][5].toString() +
//           ", " +
//           leafNodeMask[0][6].toString() +
//           ", " +
//           leafNodeMask[0][7].toString() +
//           "]\n");

//       return leafScore1(clssPred, leafNodeMask);
//     } else {
//       print("ERROR in input/output values");
//       return false;
//     }
//   }

//   List<List<List<double>>> _normalizeImage(img.Image bitmap) {
//     int h = bitmap.height;
//     int w = bitmap.width;
//     List<List<List<double>>> floatValues =
//         List.generate(h, (_) => List.generate(w, (_) => List.filled(6, 0.0)));
//     double imageStd = 256.0;

//     for (int i = 0; i < h; i++) {
//       for (int j = 0; j < w; j++) {
//         int val = bitmap.getPixel(j, i);
//         int r = img.getRed(val);
//         int g = img.getGreen(val);
//         int b = img.getBlue(val);

//         List<double> hsv = _rgbToHsv(r, g, b);

//         double hue = hsv[0] / 360.0;
//         double s = hsv[1];
//         double v = hsv[2];

//         double rNorm = r / imageStd;
//         double gNorm = g / imageStd;
//         double bNorm = b / imageStd;

//         floatValues[i][j] = [hue, s, v, rNorm, gNorm, bNorm];
//       }
//     }
//     return floatValues;
//   }

//   List<double> _rgbToHsv(int r, int g, int b) {
//     double rd = r / 255.0;
//     double gd = g / 255.0;
//     double bd = b / 255.0;

//     double max = [rd, gd, bd].reduce((a, b) => a > b ? a : b);
//     double min = [rd, gd, bd].reduce((a, b) => a < b ? a : b);

//     double h, s, v = max;

//     double d = max - min;
//     s = max == 0 ? 0 : d / max;

//     if (max == min) {
//       h = 0.0;
//     } else {
//       if (max == rd) {
//         h = (gd - bd) / d + (gd < bd ? 6 : 0);
//       } else if (max == gd) {
//         h = (bd - rd) / d + 2;
//       } else {
//         h = (rd - gd) / d + 4;
//       }
//       h /= 6;
//     }

//     return [h * 360.0, s, v];
//   }

//   // img.Image cropFace(CameraImage image, Face faceDetected) {
//   //   img.Image convertedImage = _convertCameraImage(image);

//   //   double x;
//   //   double y;
//   //   double h;
//   //   double w;

//   //   if (landscape_mode) {
//   //     x = faceDetected.boundingBox.left - 5.0;
//   //     y = faceDetected.boundingBox.top - 5.0;
//   //     w = faceDetected.boundingBox.width + 5.0;
//   //     h = faceDetected.boundingBox.height + 5.0;
//   //   } else {
//   //     x = faceDetected.boundingBox.left - 5.0;
//   //     y = faceDetected.boundingBox.top - 5.0;
//   //     w = faceDetected.boundingBox.width + 5.0;
//   //     h = faceDetected.boundingBox.height + 5.0;
//   //   }

//   //   img.Image croppedImage = img.copyCrop(
//   //       convertedImage, x.round(), y.round(), w.round(), h.round());

//   //   // Resize the image to always 80x80
//   //   // imglib.Image resizedImage =
//   //   //     imglib.copyResize(croppedImage, width: 80, height: 80);

//   //   return croppedImage;
//   // }

//   // img.Image _convertCameraImage(CameraImage image) {
//   //   var imgs = convertToImage(image);
//   //   var img1 =
//   //       landscape_mode ? img.copyRotate(imgs, 0) : img.copyRotate(imgs, -90);
//   //   return img1;
//   // }
// }
