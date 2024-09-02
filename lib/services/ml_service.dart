import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/db/databse_helper_employee.dart';
import 'package:face_net_authentication/db/databse_helper_employee_relief.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/widgets/selectUser.dart';
import 'package:face_net_authentication/services/image_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.6;

  List _predictedData = [];
  List get predictedData => _predictedData;
  List users = [];
  bool landscape_mode = false;

  Future initialize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    threshold = CONSTANT_VAR.DEFAULT_TRESHOLD;

    landscape_mode = pref.getBool("LANDSCAPE_MODE") ?? false;

    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType: TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    this._interpreter?.run(input, output);
    output = output.reshape([192]);

    this._predictedData = List.from(output);
  }

  Future<User?> predict(context) async {
    return _searchResult(context, this._predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  // imglib.Image cropFace(CameraImage image, Face faceDetected) {
  //   imglib.Image convertedImage = _convertCameraImage(image);

  //   double x;
  //   double y;
  //   double h;
  //   double w;

  //   if (landscape_mode) {
  //     x = faceDetected.boundingBox.left - 10.0;
  //     y = faceDetected.boundingBox.top - 10.0;
  //     h = faceDetected.boundingBox.width + 10.0;
  //     w = faceDetected.boundingBox.height + 10.0;
  //   } else {
  //     x = faceDetected.boundingBox.left - 10.0;
  //     y = faceDetected.boundingBox.top - 10.0;
  //     w = faceDetected.boundingBox.width + 10.0;
  //     h = faceDetected.boundingBox.height + 10.0;
  //   }

  //   imglib.Image croppedImage = imglib.copyCrop(
  //       convertedImage, x.round(), y.round(), w.round(), h.round());

  //   // // Flip the cropped image horizontally
  //   // imglib.Image flippedImage = imglib.flipHorizontal(croppedImage);

  //   return croppedImage;
  // }

  // imglib.Image cropFace(CameraImage image, Face faceDetected) {
  //   imglib.Image convertedImage = _convertCameraImage(image);

  //   double x, y, w, h;

  //   if (landscape_mode) {
  //     x = faceDetected.boundingBox.left - 10.0;
  //     y = faceDetected.boundingBox.top - 10.0;
  //     w = faceDetected.boundingBox.width + 10.0;
  //     h = faceDetected.boundingBox.height + 10.0;
  //   } else {
  //     x = faceDetected.boundingBox.left - 10.0;
  //     y = faceDetected.boundingBox.top - 10.0;
  //     w = faceDetected.boundingBox.width + 10.0;
  //     h = faceDetected.boundingBox.height + 10.0;
  //   }

  //   // Crop the image based on the calculated bounding box
  //   imglib.Image croppedImage = imglib.copyCrop(
  //       convertedImage, x.round(), y.round(), w.round(), h.round());

  //   // Resize the cropped image to a consistent size of 122x122
  //   imglib.Image resizedImage =
  //       imglib.copyResize(croppedImage, width: 122, height: 122);

  //   // If you need to flip the image horizontally, uncomment the next line
  //   // imglib.Image flippedImage = imglib.flipHorizontal(resizedImage);

  //   return resizedImage; // or return flippedImage if the image is flipped
  // }

  imglib.Image cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);

    double x, y, w, h;

    // Determine the original bounding box dimensions
    x = faceDetected.boundingBox.left - 10.0;
    y = faceDetected.boundingBox.top - 10.0;
    w = faceDetected.boundingBox.width + 10.0; // Added 10.0 to both sides
    h = faceDetected.boundingBox.height + 10.0; // Added 10.0 to both sides

    // Adjust the bounding box to be a square (1:1 aspect ratio)
    if (w > h) {
      // If width is greater, adjust the height to match the width
      double diff = w - h;
      y = y - diff / 2; // Center the square
      h = w;
    } else if (h > w) {
      // If height is greater, adjust the width to match the height
      double diff = h - w;
      x = x - diff / 2; // Center the square
      w = h;
    }

    // Ensure the bounding box stays within the image boundaries
    x = x < 0 ? 0 : x;
    y = y < 0 ? 0 : y;
    w = (x + w > convertedImage.width) ? convertedImage.width - x : w;
    h = (y + h > convertedImage.height) ? convertedImage.height - y : h;

    // Crop the image based on the adjusted bounding box
    imglib.Image croppedImage = imglib.copyCrop(
      convertedImage,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );

    // Resize the cropped image to a consistent size of 122x122 pixels
    imglib.Image resizedImage =
        imglib.copyResize(croppedImage, width: 122, height: 122);

    // If you need to flip the image horizontally, uncomment the next line
    // imglib.Image flippedImage = imglib.flipHorizontal(resizedImage);

    return resizedImage; // or return flippedImage if the image is flipped
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    if (landscape_mode) {
      var img1 = imglib.copyRotate(img, 0);
      return img1;
    } else {
      var img1 = imglib.copyRotate(img, -90);
      return img1;
    }
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<User?> _searchResult(context, List predictedData) async {
    if (users.isEmpty) {
      users = await getAlluser();
    }

    String encodedBase64 = encode_FR_ToBase64(predictedData);

    print("ENCODED FACE = " + encodedBase64);

    int detected = 0;

    double minDist = 999;
    double currDist = 0.0;
    User? predictedResult;

    List<User> userOnDistance = [];

    // print('users.length=> ${users.length}');

    for (User u in users) {
      if (u.face_template != null) {
        currDist = _euclideanDistance(u.face_template, predictedData);
        print("FR - NAME " +
            (u.employee_name ?? "NO NAME") +
            " | " +
            currDist.toString());
        ;

        if (currDist <= threshold && currDist < minDist && currDist != 0.0) {
          minDist = currDist;
          detected = detected + 1;
          userOnDistance.add(u);
          print("FR- ON DISTANCE" +
              (u.employee_name ?? "NO NAME") +
              " | " +
              currDist.toString());
          predictedResult = u;
        } else {
          print("FR - SCANNED DISTANCE" + currDist.toString());
        }
      }
    }
    // if (userOnDistance.length > 0) {
    //   predictedResult = await Navigator.of(context).push<User>(
    //     MaterialPageRoute(
    //       builder: (context) => selecUser(users: userOnDistance),
    //     ),
    //   );

    //   // Handle the case when the user does not make a selection.
    //   if (predictedResult == null) {
    //     print("User selection was canceled.");
    //     return null;
    //   }
    // } else if (userOnDistance.isNotEmpty) {
    //   predictedResult = userOnDistance.first;
    // }

    print("ALL-DETECTED = " + detected.toString());
    return predictedResult;
  }

  getAlluser() async {
    DatabaseHelperEmployee _dbHelper = DatabaseHelperEmployee.instance;
    users = await _dbHelper.queryAllUsersForMLKit();

    //FOR RELIEF
    DatabaseHelperEmployeeRelief _dbHelperRelief =
        DatabaseHelperEmployeeRelief.instance;
    List<User> userRelief = await _dbHelperRelief.queryAllUsersForMLKit();
    for (User user in userRelief) {
      users.add(user);
    }
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  dispose() {
    users.clear();
  }
}
