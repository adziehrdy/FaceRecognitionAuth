// import 'dart:math' as math;
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import '../services/image_converter.dart';

// class Pytouch_FAS {
//   Interpreter? _interpreter;
//   List _predictedData = [];
//   List get predictedData => _predictedData;
//   double dist = 0;
//   bool landscape_mode = true;
//   int model_size = 80;
//   var ctx;

//   // = = = = = = = = = = = //
//   //  ANTI SPOOFING (onnx) //
//   // = = = = = = = = = = = //

//   Future<bool?> isFaceSpoofedWithModel(
//       CameraImage cameraImage, Face? face, context) async {
//     ctx = context;
//     try {
//       Model customModel = await PyTorchMobile.loadModel('assets/best5-n.pt');
//       ctx = context;

//       if (face == null) throw Exception('Face is null');

//       final processedData = await _preProcess(cameraImage, face);
//       final input = processedData;

//       final shape = [1, 3, model_size, model_size];

//       List? prediction =
//           await customModel.getPrediction(input, shape, DType.float32);

//       final FAStensor = prediction?[0]?.value ?? "0.0";

//       List<double> FASTensorList = [];

//       if (FAStensor != null &&
//           FAStensor is List<List<double>> &&
//           FAStensor.isNotEmpty) {
//         FASTensorList = FAStensor[0];
//       }

//       List<double> probabilities = softmax(FASTensorList);

//       // print("ML_ANTISPOOF_SCORE = " + probabilities[0].toStringAsFixed(6));

//       if (probabilities[0] < 0.004) {
//         print("ML_ANTISPOOF_SCORE = " +
//             probabilities[0].toStringAsFixed(6) +
//             " SPOOF");
//         return true;
//       } else {
//         print("ML_ANTISPOOF_SCORE = " +
//             probabilities[0].toStringAsFixed(6) +
//             " REAL");
//         return false;
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//       return null;
//     }
//   }

//   // Future<Float32List> _preProcess(CameraImage image, Face faceDetected) async {
//   //   imglib.Image croppedImage = cropFace(image, faceDetected);

//   //   Float32List imageAsList = imageToByteListFloat32(croppedImage, 128);

//   //   for (int i = 0; i < imageAsList.length; i++) {
//   //     imageAsList[i] = imageAsList[i];
//   //   }
//   //   return imageAsList;
//   // }

//   List<double> softmax(List<double> input) {
//     double maxInput = input.reduce(math.max);
//     List<double> exps = input.map((i) => math.exp(i - maxInput)).toList();
//     double sumExps = exps.reduce((a, b) => a + b);
//     List<double> softmaxOutput = exps.map((e) => e / sumExps).toList();
//     return softmaxOutput;
//   }

//   imglib.Image cropFace(CameraImage image, Face faceDetected) {
//     imglib.Image convertedImage = _convertCameraImage(image);

//     double x;
//     double y;
//     double h;
//     double w;

//     if (landscape_mode) {
//       x = faceDetected.boundingBox.left - 5.0;
//       y = faceDetected.boundingBox.top - 5.0;
//       w = faceDetected.boundingBox.width + 5.0;
//       h = faceDetected.boundingBox.height + 5.0;
//     } else {
//       x = faceDetected.boundingBox.left - 5.0;
//       y = faceDetected.boundingBox.top - 5.0;
//       w = faceDetected.boundingBox.width + 5.0;
//       h = faceDetected.boundingBox.height + 5.0;
//     }

//     imglib.Image croppedImage = imglib.copyCrop(
//         convertedImage, x.round(), y.round(), w.round(), h.round());

//     // Resize the image to always 80x80
//     // imglib.Image resizedImage =
//     //     imglib.copyResize(croppedImage, width: 80, height: 80);

//     return croppedImage;
//   }

//   imglib.Image _convertCameraImage(CameraImage image) {
//     var img = convertToImage(image);
//     var img1 = landscape_mode
//         ? imglib.copyRotate(img, 0)
//         : imglib.copyRotate(img, -90);
//     return img1;
//   }

//   Future<Float32List> _preProcess(CameraImage image, Face faceDetected) async {
//     imglib.Image croppedImage = cropFace(image, faceDetected);

//     showDialog(
//       context: ctx,
//       builder: (context) => AlertDialog(
//         content:
//             Image.memory(Uint8List.fromList(imglib.encodePng(croppedImage))),
//       ),
//     );

//     // Resize the image to the required dimensions
//     imglib.Image resizedImage =
//         imglib.copyResize(croppedImage, width: model_size, height: model_size);

//     // Convert the resized image to a Float32List
//     Float32List imageAsList = imageToByteListFloat32(resizedImage);

//     // Normalize pixel values to a range of 0 to 1
//     for (int i = 0; i < imageAsList.length; i++) {
//       imageAsList[i] /= 255.0;
//     }

//     return imageAsList;
//   }

//   Float32List imageToByteListFloat32(imglib.Image image) {
//     var convertedBytes = Float32List(model_size * model_size * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;

//     for (var i = 0; i < model_size; i++) {
//       for (var j = 0; j < model_size; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = imglib.getRed(pixel).toDouble();
//         buffer[pixelIndex++] = imglib.getGreen(pixel).toDouble();
//         buffer[pixelIndex++] = imglib.getBlue(pixel).toDouble();
//       }
//     }

//     return convertedBytes;
//   }

//   void setPredictedData(value) {
//     this._predictedData = value;
//   }

//   dispose() {
//     _interpreter?.close();
//   }
// }

// extension Precision on double {
//   double toFloat() {
//     return double.parse(this.toStringAsFixed(2));
//   }
// }
