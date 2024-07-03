import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_net_authentication/FR_ENGINE/AntiSpoof.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/Spoofpage.dart';
import 'package:face_net_authentication/pages/fr_detected_page.dart';
import 'package:face_net_authentication/pages/widgets/camera_detection_preview.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/single_picture.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:face_net_authentication/services/ml_antiSpoof.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart' as intl;
import 'package:one_clock/one_clock.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:image/image.dart' as img;

import '../FR_ENGINE/pytouch_FAS.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.MODE}) : super(key: key);

  final String MODE;
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  late imglib.Image faceImage;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double lat = 0;
  double long = 0;
  String alamat = "-";
  User? lastUserKnow;

  bool _isPictureTaken = false;
  bool _isInitializing = false;
  bool enable_recognize_process = true;
  int SpoofCounter = 3;
  int BlurrCounter = 0;

  String namaReconized = "UNRECONIZE";

  DateTime? jamAbsensi;
  String? textJamAbsensi;

  Image? DetectedFaceImage;

  bool isSpoofBefore = false;
  int realCounter = 0;
  int REAL_TRESHOLD = 2;
  String painterMode = "";
  double spoofScore = 0.1111;
  int blurScore = 0;
  img.Image? anspImage;
  // Pytouch_FAS adzieFAS = Pytouch_FAS();
  FaceDeSpoofing FAS = FaceDeSpoofing();
  // AdziehrdyAntiSpoof FAS = AdziehrdyAntiSpoof();

  late OrtSession antiSpoof;

  @override
  void initState() {
    super.initState();
    getLastLocation();
    _loadModels();
    // adzieFAS.loadModelFromAssets();

    _start();
  }

  Future<void> getLastLocation() async {
    lat = await SpGetLastLat() ?? 0;
    long = await SpGetLastlong() ?? 0;
    alamat = await SpGetLastAlamat(context) ?? "-";

    setState(() {
      lat;
      long;
      alamat;
    });
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    antiSpoof.release();
    super.dispose();
  }

  Future _start() async {
    // FAS.loadModel();
    await _cameraService.initialize();
    await _frameFaces();

    // adzieFAS.loadModelFromAssets();
  }

  _frameFaces() async {
    bool processing = false;
    try {
      _cameraService.cameraController!
          .startImageStream((CameraImage image) async {
        if (processing) return; // prevents unnecessary overprocessing.
        processing = true;
        await _predictFacesDetect(image: image);

        processing = false;
      });
    } on CameraException catch (e) {
      print('CameraException: ${e.description}');
    }
  }

  Future<void> _predictFacesDetect({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);

    if (_faceDetectorService.faceDetected) {
      faceImage = _mlService.cropFace(image, _faceDetectorService.faces[0]);
//---------

      if (_faceDetectorService.faces[0].headEulerAngleY! > 5 ||
          _faceDetectorService.faces[0].headEulerAngleY! < -5) {
        print("=== POSISI MUKA TIDAK BAGUS=== ");
        SpoofCounter = 0;
      } else {
        // bool result = await _runAntiSpoof(faceImage, [
        //   faceImage.xOffset,
        //   faceImage.yOffset,
        //   faceImage.width,
        //   faceImage.height
        // ]);

        // if (result) {
        //   painterMode = "GOOD";
        // } else {
        //   painterMode = "SPOOF";
        // }

        //=======================

        int laplaceScore = await laplacian(faceImage);
        print("BLURR SCORE " + laplaceScore.toString());

        blurScore = laplaceScore;

        if (blurScore > 0) {
          final leftEyeOpen =
              _faceDetectorService.faces[0].leftEyeOpenProbability;
          final rightEyeOpen =
              _faceDetectorService.faces[0].rightEyeOpenProbability;

          // if ((leftEyeOpen! < 0.90) &&
          //     (rightEyeOpen! < 0.90 && rightEyeOpen > 0.20)) {
          //   RECONIZE_FACE(image);
          // } else {
          img.Image anspImageRaw =
              await cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);
          bool result = await _runAntiSpoof(anspImageRaw!);
          // setState(() {
          //   anspImage;
          // });

          if (result) {
            // RECONIZE_FACE(image);
          }
          // }
        } else {
          painterMode = "BLUR";
          BlurrCounter = BlurrCounter + 1;
          print("BLURR COUNTER " + BlurrCounter.toString());
          if (BlurrCounter >= 50) {
            showToast("Foto Wajah Blur, Mohon Mengatur Posisi Wajah Yang Baik");
            BlurrCounter = 0;
          }
        }
      }
// RECONIZE_FACE();

      //--------
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      await _cameraService.takePicture();
      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('No face detected!')));
    }
  }

  RECONIZE_FACE(CameraImage image) async {
    if (enable_recognize_process) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
      if (_faceDetectorService.faceDetected) {
        User? user = await _mlService.predict();
        if (user != null) {
          painterMode = "GOOD";
          _SUCCESS(user);
        }

        // namaReconized = user?.employee_name ?? "UNRECONIZE";

        // var bottomSheetController = scaffoldKey.currentState!
        //     .showBottomSheet((context) => signInSheet(user: user));
        // bottomSheetController.closed.whenComplete(_reload);
      } else {}
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

  _SUCCESS(User user) async {
    //  await _cameraService.takePicture();
    getDateTimeNow();

    // pauseCameraAndMLKit();

    //  //TESTING ABSENSI

    //  textJamAbsensi = "2024-02-11 07:30:00";
    //  jamAbsensi = DateTime.parse(textJamAbsensi!);

    //  //TESTING ABSENSI

    enable_recognize_process = false;
    lastUserKnow = null;
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FrDetectedPage(
            // employee_name: user.employee_name!,
            textJamAbsensi: textJamAbsensi!,
            jamAbsensi: jamAbsensi!,
            alamat: alamat,
            lat: lat.toString(),
            long: long.toString(),
            // company_id: user.company_id!,
            // employee_id: user.employee_id!,
            type_absensi: widget.MODE,
            faceImage: convertImagelibToUint8List(faceImage),
            user: user,
          ),
        ));

    SpoofCounter = 3;
    BlurrCounter = 0;
    realCounter = 0;

    // _reload();

    resumeCameraAndMLKit();
    enable_recognize_process = true;
  }

  // Future<void> onTap() async {
  //   //  await takePicture();

  //    await _cameraService.takePicture();

  //   getDateTimeNow();
  //   pauseCameraAndMLKit();
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => FrDetectedPage(
  //           employee_name: "adzie hadi",
  //           textJamAbsensi: textJamAbsensi!,
  //           jamAbsensi: jamAbsensi!,
  //           alamat: alamat,
  //           lat: lat.toString(),
  //           long: long.toString(),
  //           company_id: "PDC",
  //           employee_id: "110796",
  //           type_absensi: widget.MODE,faceImage: _cameraService.imagePath!,
  //         ),
  //       ));
  //   resumeCameraAndMLKit();

  //   //CAPTURE BUTTON
  //   // await takePicture();
  //   // if (_faceDetectorService.faceDetected) {
  //   //   User? user = await _mlService.predict();
  //   //   var bottomSheetController = scaffoldKey.currentState!
  //   //       .showBottomSheet((context) => signInSheet(user: user));
  //   //   bottomSheetController.closed.whenComplete(_reload);

  //   // }
  // }

  Widget getBodyWidget() {
    if (_isInitializing) return Center(child: CircularProgressIndicator());
    if (_isPictureTaken)
      return SinglePicture(imagePath: _cameraService.imagePath!);
    return CameraDetectionPreview(
      painterMode: painterMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("ABSEN " + widget.MODE);
    Widget body = getBodyWidget();
    Widget? fab;
    // if (!_isPictureTaken) fab = AuthButton(onTap: onTap);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          body,
          Column(
            children: [
              header,
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          backgroundBlendMode: BlendMode.softLight,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 2,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: DigitalClock(
                          textScaleFactor: 2,
                          showSeconds: true,
                          isLive: true,
                          datetime: DateTime.now(),
                        ),
                      ),
                      // Text(_latitude + "," + _longitude),
                      // Text(alamat)
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              // Text(lat.toString() + " , " + long.toString()),
              // Text(
              //   "NOT BLUR SCORE = " + blurScore.toString(),
              //   style: TextStyle(
              //       color: Colors.orange,
              //       fontWeight: FontWeight.bold,
              //       backgroundColor: Colors.white),
              // ),

              // Text(
              //   "NOT BLUR SCORE = " + blurScore.toString(),
              //   style: TextStyle(
              //       color: Colors.orange,
              //       fontWeight: FontWeight.bold,
              //       backgroundColor: Colors.white),
              // ),
              // Text("BLUR SCORE = " + bl),
              SizedBox(height: 5),
              // Padding(
              //   padding: const EdgeInsets.all(15),
              //   child: Text(
              //     alamat,
              //     textAlign: TextAlign.center,
              //     maxLines: 2,
              //   ),
              // )
            ],
          ),
          if (anspImage != null)
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Image.memory(convertImagelibToUint8List(anspImage!),
                    fit: BoxFit.fill),
              ),
            ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    (blurScore < 450)
                        ? Text(
                            "WAJAH BLUR",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.white),
                          )
                        : SizedBox(),
                    Text(
                      "LIVENESS SCORE = " + spoofScore.toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white),
                    ),
                  ],
                ),
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

  // signInSheet({@required User? user}) => user == null
  //     ? Container(
  //         width: MediaQuery.of(context).size.width,
  //         padding: EdgeInsets.all(20),
  //         child: Text(
  //           'User not found 😞',
  //           style: TextStyle(fontSize: 20),
  //         ),
  //       )
  //     : SignInSheet(user: user);

  //        void startRecognitionLoop() {
  //   if (!_isRecognizing) {
  //     _isRecognizing = true;
  //     _continuousRecognitionLoop();
  //   }
  // }

  //   void _continuousRecognitionLoop() async {
  //   while (_isRecognizing) {
  //     try {
  //       bool faceDetected = await widget.onPressed();
  //       if (faceDetected) {
  //         if (widget.isLogin) {
  //           var user = await _predictUser();
  //           if (user != null) {
  //             this.predictedUser = user;
  //             // Automatically perform sign-in logic
  //             _signIn(context);
  //           }
  //         }
  //         // ... Show bottom sheet ...
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  //  void stopRecognitionLoop() {
  //   _isRecognizing = false;
  // }

  getDateTimeNow() {
    setState(() {
      jamAbsensi = DateTime.now();
      intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss');
      textJamAbsensi = dateFormat.format(DateTime.now());
    });
  }

  void pauseCameraAndMLKit() {
    _cameraService.cameraController?.pausePreview();
  }

  void resumeCameraAndMLKit() async {
    _cameraService.cameraController?.resumePreview();
    // _frameFaces();
  }

  Future<void> _loadModels() async {
    final rawAssetFileAS = await rootBundle.load("assets/model_float32.onnx");
    final sessionOptionsAS = OrtSessionOptions();
    final bytesAS = rawAssetFileAS.buffer.asUint8List();
    antiSpoof = OrtSession.fromBuffer(bytesAS, sessionOptionsAS);

    // antiSpoof = await onnx.OrtSession.fromBytes(
    //   File('assets/AntiSpoofing_bin_1.5_128.onnx').readAsBytesSync(),
    // );
  }

  double sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
  }

  Future<bool> _runAntiSpoof(imglib.Image rawImage) async {
    int model_size = 128;
    // Resize image
    anspImage =
        imglib.copyResize(rawImage, width: model_size, height: model_size);
    final Float32List inputImage = _preprocessImage(anspImage!);

    try {
      // Buat input tensor
      final input = OrtValueTensor.createTensorWithDataList(
          inputImage, [1, 3, model_size, model_size]);
      final runOptions = OrtRunOptions();
      final inputs = {antiSpoof.inputNames[0]: input};

      // Jalankan model
      final output = antiSpoof.run(runOptions, inputs);

      // Dapatkan hasil
      List<List<double>> score = output[0]!.value as List<List<double>>;

      // Terapkan sigmoid pada setiap elemen dalam array hasil
      // List<double> sigmoidScores = score[0].map((x) => sigmoid(x)).toList();

      // Ambil nilai yang digunakan untuk penentuan label (misalnya nilai ke-3)

      setState(() {
        spoofScore = score[0].last;
      });

      // Cetak hasil setelah sigmoid diterapkan
      print("ANTISPOOF SCORE (sigmoid) = " + spoofScore.toString());
      // print("ANTISPOOF SCORE (sigmoid 0) = " + sigmoidScores[0].toString());

      // Gunakan nilai sigmoid untuk menentukan hasil
      if ((spoofScore >= 0.94 || spoofScore <= 0.75) && spoofScore < 0.99) {
        if (realCounter >= 4) {
          SpoofCounter = 3;
          painterMode = "GOOD";
          return true;
        } else {
          if (realCounter < 4) {
            realCounter = realCounter + 1;
          }
          SpoofCounter = SpoofCounter - 1;
          painterMode = "BLUR";

          return false;
        }
      } else {
        if (SpoofCounter <= 3) {
          SpoofCounter = SpoofCounter + 1;
        }
        if (realCounter != 0) {
          realCounter = realCounter - 1;
        }
        painterMode = "SPOOF";
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  img.Image _increasedCrop(img.Image image, List<int> bbox,
      {double bboxInc = 1.5}) {
    final realH = image.height;
    final realW = image.width;

    final x = bbox[0];
    final y = bbox[1];
    final w = bbox[2] - x;
    final h = bbox[3] - y;
    final l = w > h ? w : h;

    final xc = x + w / 2;
    final yc = y + h / 2;

    final x1 = (xc - l * bboxInc / 2).toInt();
    final y1 = (yc - l * bboxInc / 2).toInt();
    final x2 = (xc + l * bboxInc / 2).toInt();
    final y2 = (yc + l * bboxInc / 2).toInt();

    return img.copyCrop(image, x1, y1, x2 - x1, y2 - y1);
  }

  Float32List _preprocessImage(imglib.Image image) {
    int model_size = 128;

    // Resize image to the model input size (128x128 in this case)
    final resizedImage =
        imglib.copyResize(image, width: model_size, height: model_size);

    // Create a Float32List to hold the normalized image data
    final Float32List inputImage = Float32List(model_size * model_size * 3);

    int pixelIndex = 0;
    for (int y = 0; y < model_size; y++) {
      for (int x = 0; x < model_size; x++) {
        final pixel = resizedImage.getPixel(x, y);
        final r = (pixel >> 16) & 0xFF;
        final g = (pixel >> 8) & 0xFF;
        final b = pixel & 0xFF;

        // Normalize the pixel values to [0, 1] and store them in inputImage
        inputImage[pixelIndex++] = b / 255.0;
        inputImage[pixelIndex++] = g / 255.0;
        inputImage[pixelIndex++] = r / 255.0;
      }
    }

    return inputImage;
  }
}
