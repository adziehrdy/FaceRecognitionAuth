import 'dart:async';

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
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart' as intl;
import 'package:one_clock/one_clock.dart';

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
  int SpoofCounter = 0;
  int BlurrCounter = 0;

  String namaReconized = "UNRECONIZE";

  DateTime? jamAbsensi;
  String? textJamAbsensi;

  Image? DetectedFaceImage;

  bool isSpoofBefore = false;
  int realCounter = 0;

  String painterMode = "";
  double spoofScore = 0;
  int blurScore = 0;
  // Pytouch_FAS adzieFAS = Pytouch_FAS();
  FaceDeSpoofing FAS = FaceDeSpoofing();

  @override
  void initState() {
    super.initState();
    getLastLocation();
    // adzieFAS.loadModelFromAssets();

    _start();
  }

  Future<void> getLastLocation() async {
    lat = await SpGetLastLat() ?? 0;
    long = await SpGetLastlong() ?? 0;
    alamat = await SpGetLastAlamat() ?? "-";

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

      if (_faceDetectorService.faces[0].headEulerAngleY! > 10 ||
          _faceDetectorService.faces[0].headEulerAngleY! < -10) {
        print("=== POSISI MUKA TIDAK BAGUS=== ");
      } else {
        int laplaceScore = await laplacian(faceImage);
        print("BLURR SCORE " + laplaceScore.toString());

        blurScore = laplaceScore;

        if (blurScore > 600) {
          if (lastUserKnow == null) {
            RECONIZE_FACE(image);
          } else {
            imglib.Image FAS_CROP =
                cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);

            bool isSpoof = await FAS.deSpoofing(FAS_CROP);
            if (!isSpoof) {
              _SUCCESS(lastUserKnow!);
            } else {
              lastUserKnow = null;
            }
          }

          // FAS.deSpoofing(faceImage);
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
          // imglib.Image faceImageAS =
          //     cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);
          imglib.Image FAS_CROP =
              cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);

          bool isSpoof = await FAS.deSpoofing(FAS_CROP);

          if (isSpoof && (blurScore < 2000)) {
            lastUserKnow = null;
            painterMode = "SPOOF";
            realCounter = 0;
          } else {
            lastUserKnow = user;
            painterMode = "GOOD";
            if (SpoofCounter >= 3) {
              SpoofCounter = 0;
            }
          }

          // bool? isSpoof = await FaceAntiSpoofing.antiSpoofing(faceImageAS);
          // bool? isSpoof = await adzieFAS.isFaceSpoofedWithModel(
          //     image, _faceDetectorService.faces[0], context);

          if (!isSpoof || blurScore > 2000) {
            lastUserKnow = user;
            realCounter = realCounter + 1;
            if (realCounter >= 2) {
              _SUCCESS(user);
            }
          } else {
            realCounter = 0;
            SpoofCounter = SpoofCounter + 1;

            if (SpoofCounter >= 12) {
              enable_recognize_process = false;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Spoofpage(),
                  ));

              enable_recognize_process = true;
              SpoofCounter = 0;
              lastUserKnow = null;
              painterMode = "SPOOF";
            }
          }
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
    enable_recognize_process = false;
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

    SpoofCounter = 0;
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
          Column(children: [
            header,
            Column(children: [
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
            ]),
            SizedBox(height: 10),
            // Text(lat.toString() + " , " + long.toString()),
            Text("NOT BLUR SCORE = " + blurScore.toString()),
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
          ]),
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
}
