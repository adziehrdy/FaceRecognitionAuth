import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/services/image_converter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
    threshold = pref.getDouble("threshold") ?? CONSTANT_VAR.DEFAULT_TRESHOLD;

    landscape_mode = pref.getBool("LANDSCAPE_MODE") ?? false;

    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            // inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            // inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            // inferencePriority2: TfLiteGpuInferencePriority.auto,
            // inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
            // waitType: TFLGpuDelegateWaitType.active
          ),
        );
      }
      // var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      // this._interpreter = await Interpreter.fromAsset(
      //     'assets/MobileFaceNetv2.tflite',
      //     options: interpreterOptions);

      this._interpreter =
          await Interpreter.fromAsset('assets/mobilefacenet.tflite');
    } catch (e) {
      showToast('Failed Load FR Model, Mohon Hubungi Admin');
      showToast(e.toString());
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

  Future<User?> predict() async {
    return _searchResult(this._predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image cropFace(CameraImage image, Face faceDetected) {
    // Konversi CameraImage ke imglib.Image
    imglib.Image convertedImage = _convertCameraImage(image);

    // Dapatkan koordinat bounding box dari deteksi wajah
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;

    // Pastikan rasio aspek 1x1 berdasarkan tinggi
    // Gunakan ukuran yang lebih besar antara lebar dan tinggi
    double maxSize = h > w ? h : w;

    // Pastikan crop tidak keluar dari batas gambar asli
    double cropX = x < 0 ? 0 : x;
    double cropY = y < 0 ? 0 : y;
    double cropW = (cropX + maxSize) > convertedImage.width
        ? convertedImage.width - cropX
        : maxSize;
    double cropH = (cropY + maxSize) > convertedImage.height
        ? convertedImage.height - cropY
        : maxSize;

    // Lakukan crop gambar menggunakan ukuran yang dihitung
    return imglib.copyCrop(convertedImage, cropX.round(), cropY.round(),
        cropW.round(), cropH.round());
  }

// Fungsi konversi CameraImage ke imglib.Image (tetap sama)
  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    if (landscape_mode) {
      return imglib.copyRotate(img, 0);
    } else {
      return imglib.copyRotate(img, -90);
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

  Future<User?> _searchResult(List predictedData) async {
    if (users.isEmpty) {
      users = await getAlluser();
    }

    double minDist = 999;
    double currDist = 0.0;
    User? predictedResult;

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
          print("FR- FINAL DISTANCE" + currDist.toString());
          predictedResult = u;
        } else {
          print("FR - SCANNED DISTANCE" + currDist.toString());
        }
      }
    }
    return predictedResult;
  }

  getAlluser() async {
    DatabaseHelperEmployee _dbHelper = DatabaseHelperEmployee.instance;

    users = await _dbHelper.queryAllUsersForMLKit();

    //ADZIEHRDY
    // users = await _dbHelper.queryAllUsers();
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
