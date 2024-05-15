// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:face_net_authentication/FR_ENGINE/AntiSpoof.dart';
// import 'package:face_net_authentication/constants/constants.dart';
// import 'package:face_net_authentication/db/databse_helper_employee_relief.dart';
// import 'package:face_net_authentication/globals.dart';
// import 'package:face_net_authentication/models/user.dart';
// import 'package:face_net_authentication/db/databse_helper_employee.dart';
// import 'package:face_net_authentication/services/image_converter.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:onnxruntime/onnxruntime.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path_provider/path_provider.dart' as path;

// class MLService {
//   Interpreter? _interpreter;
//   double threshold = 0.6;

//   List _predictedData = [];
//   List get predictedData => _predictedData;
//   List users = [];
//   bool landscape_mode = true;
//   late AdziehrdyAntiSpoof antiSpoof;
//   Future<List<double>?> FASoutputs = Future.value([]);

//   double dist = 0;

//   Future initialize() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     threshold = pref.getDouble("threshold") ?? CONSTANT_VAR.DEFAULT_TRESHOLD;

//     landscape_mode = pref.getBool("LANDSCAPE_MODE") ?? false;

//     late Delegate delegate;
//     try {
//       if (Platform.isAndroid) {
//         delegate = GpuDelegateV2(
//           options: GpuDelegateOptionsV2(
//             isPrecisionLossAllowed: false,
//             inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
//             inferencePriority1: TfLiteGpuInferencePriority.minLatency,
//             inferencePriority2: TfLiteGpuInferencePriority.auto,
//             inferencePriority3: TfLiteGpuInferencePriority.auto,
//           ),
//         );
//       } else if (Platform.isIOS) {
//         delegate = GpuDelegate(
//           options: GpuDelegateOptions(
//               allowPrecisionLoss: true,
//               waitType: TFLGpuDelegateWaitType.active),
//         );
//       }
//       var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

//       this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
//           options: interpreterOptions);

//       // loadModelAntiSpoof();
//     } catch (e) {
//       print('Failed to load model.');
//       print(e);
//     }
//   }

//   Future<OrtSession> loadModelAntiSpoof() async {
//     OrtEnv.instance.init();
//     final sessionOptions = OrtSessionOptions();
//     // const assetFileName = 'assets/FaceBagNet_color_96.onnx';
//     // const assetFileName = 'assets/AntiSpoofing_print-replay_128.onnx';
//     const assetFileName = 'assets/2.7_80x80_MiniFASNetV2.onnx';

//     final rawAssetFile = await rootBundle.load(assetFileName);
//     final bytes = rawAssetFile.buffer.asUint8List();
//     final session = OrtSession.fromBuffer(bytes, sessionOptions);

//     return session;
//   }

//   //   Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
//   //   assert(image != null, 'Image is null');

//   //   await _faceDetectorService.detectFacesFromImage(image!);

//   //   if (_faceDetectorService.faceDetected) {
//   //     // FASoutputs = _mlService.isFaceSpoofedWithModel(
//   //     //     image, _faceDetectorService.faces[0]);

//   //     final results = await _mlService.MODIFIEDisFaceSpoofedWithModel(
//   //         image, _faceDetectorService.faces[0]);

//   //     if (results != null) {
//   //       // Access processedImage and probabilities from the list
//   //       processedImage = results[0] as imglib.Image;
//   //       final FASoutputs = results[1] as List<double>;

//   //       _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
//   //     } else {
//   //       // Handle the case where results are null (e.g., an error occurred)
//   //       print('Error: No results returned from MODIFIEDisFaceSpoofedWithModel');
//   //     }
//   //   }

//   //   if (mounted) setState(() {});
//   // }

//   Future<List?> MODIFIEDisFaceSpoofedWithModel(
//       CameraImage cameraImage, Face? face) async {
//     print("===> isFaceSpoofedWithModel Starts");

//     try {
//       // Assuming you have a method to load the model from assets
//       final session = await loadModelAntiSpoof();

//       if (face == null) throw Exception('Face is null');

//       final processedData = await _preProcess(cameraImage, face);
//       // Access img and imageAsList from the returned list
//       final processedImg = processedData[0] as imglib.Image;
//       final input = processedData[1] as Float32List;

//       // Create OrtValue from input
//       // final shape = [1, 3, 128, 128];
//       final shape = [1, 3, 80, 80];
//       // final shape = [1, 80, 80, 3];
//       final inputOrt =
//           OrtValueTensor.createTensorWithDataList(await input, shape);
//       final inputName = session.inputNames[0];

//       // Create inputs map
//       final inputs = {inputName: inputOrt};

//       // Create run options
//       final runOptions = OrtRunOptions();

//       // Run the model
//       final outputs = session.run(runOptions, inputs);

//       final FAStensor = outputs[0]?.value;

//       print("===> outputs.length: " + outputs.length.toString());
//       print("===> FAStensor: " + FAStensor.toString());

//       List<double> FASTensorList = [];

//       if (FAStensor != null &&
//           FAStensor is List<List<double>> &&
//           FAStensor.isNotEmpty) {
//         FASTensorList = FAStensor[0];
//       }

//       // use softmax to get probabilities of the FASTensorList
//       List<double> probabilities = softmax(FASTensorList);

//       if (probabilities.isNotEmpty && probabilities[0] < 0.001) {
//         print("SPOFF = PALSU | " + probabilities[0].toString());
//       } else {
//         print("SPOFF = ASLI | " + probabilities[0].toString());
//       }
//       // probabilities = [0.6734, 0.3266];
//       // probabilities = [0.3349, 0.6651];
//       print("===> probabilities: " +
//           probabilities.toString()); // prints the probabilities

//       // release onnx components
//       inputOrt.release();
//       runOptions.release();
//       session.release();
//       print("===> isFaceSpoofedWithModel Ends");
//       return processedData;
//     } catch (e) {
//       print('An error occurred: $e');
//       return null;
//     }
//   }

//   Future<void> setCurrentPrediction(CameraImage cameraImage, Face? face) async {
//     if (_interpreter == null) throw Exception('Interpreter is null');
//     if (face == null) throw Exception('Face is null');

//     List? input = await MODIFIEDisFaceSpoofedWithModel(cameraImage, face);

//     if (input != null) {
//       input = input.reshape([1, 112, 112, 3]);
//       List output = List.generate(1, (index) => List.filled(192, 0));

//       this._interpreter?.run(input, output);
//       output = output.reshape([192]);

//       this._predictedData = List.from(output);
//     }
//   }

//   Future<User?> predict() async {
//     return _searchResult(this._predictedData);
//   }

//   Future<List> _preProcess(CameraImage image, Face faceDetected) async {
//     imglib.Image croppedImage = cropFace(image, faceDetected);
//     imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
//     imglib.Image imgAntiSpoof;
//     // img = imglib.copyResizeCropSquare(croppedImage, 128);
//     imgAntiSpoof = imglib.copyResizeCropSquare(croppedImage, 80);
//     // final directory = await path.getApplicationDocumentsDirectory();
//     // final file = File(join(directory.path, 'resized.png'));
//     // await file.writeAsBytes(imglib.encodePng(img));
//     final directory = await path.getExternalStorageDirectory();
//     final file = File(join(directory!.path, 'resized.png'));
//     try {
//       await file.writeAsBytes(imglib.encodePng(imgAntiSpoof));
//       print("===> file.path: " + file.path);
//     } catch (e) {
//       print('Error: $e');
//     }

//     // Float32List imageAsList = imageToByteListFloat32(croppedImage, 128);
//     Float32List imageAsList = imageToByteListFloat32AntiSpoof(croppedImage, 80);

//     // normalization
//     for (int i = 0; i < imageAsList.length; i++) {
//       imageAsList[i] = imageAsList[i];
//     }
//     return [imgAntiSpoof, imageAsList];
//     // Float32List imageAsList = imageToByteListFloat32(img);
//     // return imageAsList;
//   }

//   Float32List imageToByteListFloat32AntiSpoof(
//       imglib.Image image, int imageSize) {
//     var convertedBytes = Float32List(1 * imageSize * imageSize * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;

//     for (var i = 0; i < imageSize; i++) {
//       for (var j = 0; j < imageSize; j++) {
//         var pixel = image.getPixel(j, i);
//         // buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
//         // buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
//         // buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
//         // buffer[pixelIndex++] = imglib.getRed(pixel) / 255;
//         // buffer[pixelIndex++] = imglib.getGreen(pixel) / 255;
//         // buffer[pixelIndex++] = imglib.getBlue(pixel) / 255;
//         buffer[pixelIndex++] = imglib.getRed(pixel) / 1;
//         buffer[pixelIndex++] = imglib.getGreen(pixel) / 1;
//         buffer[pixelIndex++] = imglib.getBlue(pixel) / 1;
//       }
//     }
//     return convertedBytes.buffer.asFloat32List();
//   }

//   imglib.Image cropFace(CameraImage image, Face faceDetected) {
//     imglib.Image convertedImage = _convertCameraImage(image);

//     double x;
//     double y;
//     double h;
//     double w;

//     if (landscape_mode) {
//       x = faceDetected.boundingBox.left - 10.0;
//       y = faceDetected.boundingBox.top - 10.0;
//       h = faceDetected.boundingBox.width + 10.0;
//       w = faceDetected.boundingBox.height + 10.0;
//     } else {
//       x = faceDetected.boundingBox.left - 10.0;
//       y = faceDetected.boundingBox.top - 10.0;
//       w = faceDetected.boundingBox.width + 10.0;
//       h = faceDetected.boundingBox.height + 10.0;
//     }

//     return imglib.copyCrop(
//         convertedImage, x.round(), y.round(), w.round(), h.round());
//   }

//   imglib.Image _convertCameraImage(CameraImage image) {
//     var img = convertToImage(image);
//     if (landscape_mode) {
//       var img1 = imglib.copyRotate(img, 0);
//       return img1;
//     } else {
//       var img1 = imglib.copyRotate(img, -90);
//       return img1;
//     }
//   }

//   Float32List imageToByteListFloat32(imglib.Image image) {
//     var convertedBytes = Float32List(1 * 112 * 112 * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;

//     for (var i = 0; i < 112; i++) {
//       for (var j = 0; j < 112; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
//       }
//     }
//     return convertedBytes.buffer.asFloat32List();
//   }

//   Future<User?> _searchResult(List predictedData) async {
//     if (users.isEmpty) {
//       users = await getAlluser();
//     }

//     double minDist = 999;
//     double currDist = 0.0;
//     User? predictedResult;

//     // print('users.length=> ${users.length}');

//     for (User u in users) {
//       if (u.face_template != null) {
//         currDist = _euclideanDistance(u.face_template, predictedData);
//         print("FR - NAME " +
//             (u.employee_name ?? "NO NAME") +
//             " | " +
//             currDist.toString());
//         ;

//         if (currDist <= threshold && currDist < minDist && currDist != 0.0) {
//           minDist = currDist;
//           print("FR- FINAL DISTANCE" + currDist.toString());
//           predictedResult = u;
//         } else {
//           print("FR - SCANNED DISTANCE" + currDist.toString());
//         }
//       }
//     }
//     return predictedResult;
//   }

//   getAlluser() async {
//     DatabaseHelperEmployee _dbHelper = DatabaseHelperEmployee.instance;
//     users = await _dbHelper.queryAllUsersForMLKit();

//     //FOR RELIEF
//     DatabaseHelperEmployeeRelief _dbHelperRelief =
//         DatabaseHelperEmployeeRelief.instance;
//     List<User> userRelief = await _dbHelperRelief.queryAllUsersForMLKit();
//     for (User user in userRelief) {
//       if (reliefChecker(user.relief_start_date, user.relief_end_date)) {
//         users.add(user);
//       }
//     }

//     //ADZIEHRDY
//     // users = await _dbHelper.queryAllUsers();
//   }

//   List<double> softmax(List<double> scores) {
//     double maxScore = scores.reduce(max);
//     List<double> expScores =
//         scores.map((score) => exp(score - maxScore)).toList();
//     double sumExpScores = expScores.reduce((a, b) => a + b);
//     return expScores.map((score) => score / sumExpScores).toList();
//   }

//   double _euclideanDistance(List? e1, List? e2) {
//     if (e1 == null || e2 == null) throw Exception("Null argument");

//     double sum = 0.0;
//     for (int i = 0; i < e1.length; i++) {
//       sum += pow((e1[i] - e2[i]), 2);
//     }
//     return sqrt(sum);
//   }

//   void setPredictedData(value) {
//     this._predictedData = value;
//   }

//   dispose() {
//     users.clear();
//   }
// }
