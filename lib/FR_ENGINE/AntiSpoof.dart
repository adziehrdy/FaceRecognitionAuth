// import 'dart:math' as math;
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:onnxruntime/onnxruntime.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import '../services/image_converter.dart';

// class AdziehrdyAntiSpoof {
//   Interpreter? _interpreter;
//   List _predictedData = [];
//   List get predictedData => _predictedData;
//   double dist = 0;
//   bool landscape_mode = true;
//   int model_size = 128;
//   var ctx;

//   AdziehrdyAntiSpoof() {
//     loadModelFromAssets();
//   }

//   // = = = = = = = = = = = //
//   //  ANTI SPOOFING (onnx) //
//   // = = = = = = = = = = = //

//   Future<OrtSession> loadModelFromAssets() async {
//     OrtEnv.instance.init();
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     landscape_mode = pref.getBool("LANDSCAPE_MODE") ?? false;
//     final sessionOptions = OrtSessionOptions();
//     // const assetFileName = 'assets/AntiSpoofing_print-replay_128.onnx';
//     // const assetFileName = 'assets/AntiSpoofing_print-replay_1.5_128.onnx';
//     // const assetFileName = 'assets/2.7_80x80_MiniFASNetV2.onnx';
//     const assetFileName = 'assets/AntiSpoofing_bin_1.5_128.onnx';

//     // AntiSpoofing_print-replay_1.5_128
//     final rawAssetFile = await rootBundle.load(assetFileName);
//     final bytes = rawAssetFile.buffer.asUint8List();
//     final session = OrtSession.fromBuffer(bytes, sessionOptions);

//     return session;
//   }

//   Future<bool> deSpoofing(imglib.Image faceImage) async {
//     ctx = context;
//     try {
//       final session = await loadModelFromAssets();
//       ctx = context;

//       final processedData = await _preProcess(faceImage);
//       final input = processedData;

//       final shape = [1, 3, model_size, model_size];
//       final inputOrt = OrtValueTensor.createTensorWithDataList(input, shape);
//       final inputName = session.inputNames[0];

//       final inputs = {inputName: inputOrt};
//       final runOptions = OrtRunOptions();

//       final outputs = session.run(runOptions, inputs);

//       final FAStensor = outputs[0]?.value;

//       List<double> FASTensorList = [];

//       if (FAStensor != null &&
//           FAStensor is List<List<double>> &&
//           FAStensor.isNotEmpty) {
//         FASTensorList = FAStensor[0];
//       }

//       List<double> probabilities = softmax(FASTensorList);

//       // print("ML_ANTISPOOF_SCORE = " + probabilities[0].toStringAsFixed(6));

//       if (probabilities[0] < 0.005) {
//         print("FAS SCORE =" + probabilities[0].toStringAsFixed(6) + " SPOOF");
//         return true;
//       } else {
//         print("FAS SCORE =" + probabilities[0].toStringAsFixed(6) + " REAL");
//         return false;
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//       return true;
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

//   // imglib.Image cropFace(CameraImage image, Face faceDetected) {
//   //   imglib.Image convertedImage = _convertCameraImage(image);

//   //   double x;
//   //   double y;
//   //   double h;
//   //   double w;

//   //   if (landscape_mode) {
//   //     x = faceDetected.boundingBox.left - 100.0;
//   //     y = faceDetected.boundingBox.top - 200.0;
//   //     w = faceDetected.boundingBox.width + 200.0;
//   //     h = faceDetected.boundingBox.height + 300.0;
//   //   } else {
//   //     x = faceDetected.boundingBox.left - 10.0;
//   //     y = faceDetected.boundingBox.top - 10.0;
//   //     w = faceDetected.boundingBox.width * 0.75 + 10.0;
//   //     h = faceDetected.boundingBox.height * 0.75 + 10.0;
//   //   }

//   //   imglib.Image croppedImage = imglib.copyCrop(
//   //       convertedImage, x.round(), y.round(), w.round(), h.round());

//   //   // Resize the image to always 80x80
//   //   imglib.Image resizedImage =
//   //       imglib.copyResize(croppedImage, width: 80, height: 80);

//   //   return resizedImage;
//   // }

//   // imglib.Image _convertCameraImage(CameraImage image) {
//   //   var img = convertToImage(image);
//   //   var img1 = landscape_mode
//   //       ? imglib.copyRotate(img, 0)
//   //       : imglib.copyRotate(img, -90);
//   //   return img1;
//   // }

//   Future<Float32List> _preProcess(imglib.Image croppedImage) async {
//     // showDialog(
//     //   context: ctx,
//     //   builder: (context) => AlertDialog(
//     //     content:
//     //         Image.memory(Uint8List.fromList(imglib.encodePng(croppedImage))),
//     //   ),
//     // );

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
