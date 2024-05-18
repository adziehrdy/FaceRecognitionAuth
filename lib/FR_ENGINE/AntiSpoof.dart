import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../services/image_converter.dart';

class AdziehrdyAntiSpoof {
  Interpreter? _interpreter;
  List _predictedData = [];
  List get predictedData => _predictedData;
  double dist = 0;
  bool landscape_mode = false;

  // = = = = = = = = = = = //
  //  ANTI SPOOFING (onnx) //
  // = = = = = = = = = = = //

  Future<OrtSession> loadModelFromAssets() async {
    OrtEnv.instance.init();
    SharedPreferences pref = await SharedPreferences.getInstance();
    landscape_mode = pref.getBool("LANDSCAPE_MODE") ?? false;
    final sessionOptions = OrtSessionOptions();
    // const assetFileName = 'assets/FaceBagNet_color_96.onnx';
    const assetFileName = 'assets/AntiSpoofing_print-replay_128.onnx';
    // const assetFileName = 'assets/2.7_80x80_MiniFASNetV2.onnx';

    final rawAssetFile = await rootBundle.load(assetFileName);
    final bytes = rawAssetFile.buffer.asUint8List();
    final session = OrtSession.fromBuffer(bytes, sessionOptions);

    return session;
  }

  // ORIGINAL
  // Future<List<double>?> isFaceSpoofedWithModel(
  //     CameraImage cameraImage, Face? face) async {
  //   print("===> isFaceSpoofedWithModel Starts");

  //   try {
  //     // Assuming you have a method to load the model from assets
  //     final session = await loadModelFromAssets();

  //     if (face == null) throw Exception('Face is null');

  //     Future<List> input = _preProcess(cameraImage, face);

  //     // Create OrtValue from input
  //     // final shape = [1, 3, 128, 128];
  //     final shape = [1, 3, 80, 80];
  //     // final shape = [1, 80, 80, 3];
  //     final inputOrt =
  //         OrtValueTensor.createTensorWithDataList(await input, shape);
  //     final inputName = session.inputNames[0];

  //     // Create inputs map
  //     final inputs = {inputName: inputOrt};

  //     // Create run options
  //     final runOptions = OrtRunOptions();

  //     // Run the model
  //     final outputs = session.run(runOptions, inputs);

  //     final FAStensor = outputs[0]?.value;

  //     print("===> outputs.length: " + outputs.length.toString());
  //     print("===> FAStensor: " + FAStensor.toString());

  //     List<double> FASTensorList = [];

  //     if (FAStensor != null &&
  //         FAStensor is List<List<double>> &&
  //         FAStensor.isNotEmpty) {
  //       FASTensorList = FAStensor[0];
  //     }

  //     // use softmax to get probabilities of the FASTensorList
  //     List<double> probabilities = softmax(FASTensorList);
  //     // probabilities = [0.6734, 0.3266];
  //     // probabilities = [0.3349, 0.6651];
  //     print("===> probabilities: " +
  //         probabilities.toString()); // prints the probabilities

  //     // release onnx components
  //     inputOrt.release();
  //     runOptions.release();
  //     session.release();
  //     print("===> isFaceSpoofedWithModel Ends");
  //     return probabilities;
  //   } catch (e) {
  //     print('An error occurred: $e');
  //     return null;
  //   }
  // }

  // MODIFIED
  Future<List?> MODIFIEDisFaceSpoofedWithModel(
      CameraImage cameraImage, Face? face) async {
    // print("===> isFaceSpoofedWithModel Starts");

    try {
      // Assuming you have a method to load the model from assets
      final session = await loadModelFromAssets();

      if (face == null) throw Exception('Face is null');

      final processedData = await _MODIFIEDpreProcess(cameraImage, face);
      // Access img and imageAsList from the returned list
      final input = processedData;

      // Create OrtValue from input
      final shape = [1, 3, 128, 128];
      // final shape = [1, 3, 80, 80];
      // final shape = [1, 80, 80, 3];
      final inputOrt =
          OrtValueTensor.createTensorWithDataList(await input, shape);
      final inputName = session.inputNames[0];

      // Create inputs map
      final inputs = {inputName: inputOrt};

      // Create run options
      final runOptions = OrtRunOptions();

      // Run the model
      final outputs = session.run(runOptions, inputs);

      final FAStensor = outputs[0]?.value;

      // print("===> outputs.length: " + outputs.length.toString());
      // print("===> FAStensor: " + FAStensor.toString());

      List<double> FASTensorList = [];

      if (FAStensor != null &&
          FAStensor is List<List<double>> &&
          FAStensor.isNotEmpty) {
        FASTensorList = FAStensor[0];
      }

      // use softmax to get probabilities of the FASTensorList
      List<double> probabilities = softmax(FASTensorList);
      // probabilities = [0.6734, 0.3266];
      // probabilities = [0.3349, 0.6651];
      // print("===> probabilities: " +
      //     probabilities.toString()); // prints the probabilities

      // release onnx components
      inputOrt.release();
      runOptions.release();
      session.release();
      // print("===> isFaceSpoofedWithModel Ends");
      return probabilities;
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  // ORIGINAL
  // Future<List> _preProcess(CameraImage image, Face faceDetected) async {
  //   imglib.Image croppedImage = _cropFace(image, faceDetected);

  //   imglib.Image img;
  //   // img = imglib.copyResizeCropSquare(croppedImage, 128);
  //   img = imglib.copyResizeCropSquare(croppedImage, 80);
  //   final directory = await path.getApplicationDocumentsDirectory();
  //   final file = File(join(directory.path, 'resized.png'));
  //   // print the image path
  //   print(file.path);
  //   await file.writeAsBytes(imglib.encodePng(img));
  //   // new File("resized.png").writeAsBytesSync(imglib.encodePng(img));

  //   // Float32List imageAsList = imageToByteListFloat32(croppedImage, 128);
  //   Float32List imageAsList = imageToByteListFloat32(croppedImage, 80);

  //   // normalization
  //   for (int i = 0; i < imageAsList.length; i++) {
  //     imageAsList[i] = imageAsList[i];
  //   }
  //   return imageAsList;
  // }

  // MODIFIED
  Future<Float32List> _MODIFIEDpreProcess(
      CameraImage image, Face faceDetected) async {
    imglib.Image croppedImage = _cropFace(image, faceDetected);

    // imglib.Image img;
    // // img = imglib.copyResizeCropSquare(croppedImage, 128);
    // img = imglib.copyResizeCropSquare(croppedImage, 128);
    // final directory = await path.getApplicationDocumentsDirectory();
    // final file = File(join(directory.path, 'resized.png'));
    // await file.writeAsBytes(imglib.encodePng(img));
    // // final directory = await path.getExternalStorageDirectory();
    // // final file = File(join(directory!.path, 'resized.png'));
    // try {
    //   await file.writeAsBytes(imglib.encodePng(img));
    //   print("===> file.path: " + file.path);
    // } catch (e) {
    //   print('Error: $e');
    // }

    // Float32List imageAsList = imageToByteListFloat32(croppedImage, 128);
    Float32List imageAsList = imageToByteListFloat32(croppedImage, 128);

    // normalization
    for (int i = 0; i < imageAsList.length; i++) {
      imageAsList[i] = imageAsList[i];
    }
    return imageAsList;
  }

  List<double> softmax(List<double> scores) {
    double maxScore = scores.reduce(max);
    List<double> expScores =
        scores.map((score) => exp(score - maxScore)).toList();
    double sumExpScores = expScores.reduce((a, b) => a + b);
    List<double> softmaxScores =
        expScores.map((score) => score / sumExpScores).toList();
    return softmaxScores;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);

    double x;
    double y;
    double h;
    double w;

    // if (landscape_mode) {
    //   x = faceDetected.boundingBox.left - 10.0;
    //   y = faceDetected.boundingBox.top - 10.0;
    //   h = faceDetected.boundingBox.width + 10.0;
    //   w = faceDetected.boundingBox.height + 10.0;
    // } else {
    x = faceDetected.boundingBox.left - 10.0;
    y = faceDetected.boundingBox.top - 10.0;
    w = faceDetected.boundingBox.width + 10.0;
    h = faceDetected.boundingBox.height + 10.0;
    // }

    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image, int imageSize) {
    var convertedBytes = Float32List(1 * imageSize * imageSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < imageSize; i++) {
      for (var j = 0; j < imageSize; j++) {
        var pixel = image.getPixel(j, i);
        // buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        // buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        // buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
        // buffer[pixelIndex++] = imglib.getRed(pixel) / 255;
        // buffer[pixelIndex++] = imglib.getGreen(pixel) / 255;
        // buffer[pixelIndex++] = imglib.getBlue(pixel) / 255;
        buffer[pixelIndex++] = imglib.getRed(pixel) / 1;
        buffer[pixelIndex++] = imglib.getGreen(pixel) / 1;
        buffer[pixelIndex++] = imglib.getBlue(pixel) / 1;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  dispose() {
    _interpreter?.close();
  }

  // Future<void> saveImage(filePath, imglib.Image image) async {
  //   // Encode the image as JPG
  //   List<int> jpgBytes = imglib.encodeJpg(image);

  //   // Write the bytes to a file
  //   await File(filePath).writeAsBytes(jpgBytes);
  // }
}

extension Precision on double {
  double toFloat() {
    return double.parse(this.toStringAsFixed(2));
  }
}
