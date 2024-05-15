import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/fr_detected_page.dart';
import 'package:face_net_authentication/pages/widgets/camera_detection_preview.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/signin_form.dart';
import 'package:face_net_authentication/pages/widgets/single_picture.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart' as intl;
import 'package:one_clock/one_clock.dart';

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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double lat = 0;
  double long = 0;
  String alamat = "-";

  bool _isPictureTaken = false;
  bool _isInitializing = false;
  bool enable_recognize_process = true;

  CameraImage? faceImage;

  String namaReconized = "UNRECONIZE";

  DateTime? jamAbsensi;
  String? textJamAbsensi;

  Image? DetectedFaceImage;

  @override
  void initState() {
    super.initState();

    getLastLocation();

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
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    setState(() => _isInitializing = false);
    _frameFaces();
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesDetect(image: image);

      processing = false;
    });
  }

  Future<void> _predictFacesDetect({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);

    if (_faceDetectorService.faceDetected) {
//---------

      if (_faceDetectorService.faces[0].headEulerAngleY! > 10 ||
          _faceDetectorService.faces[0].headEulerAngleY! < -10) {
        print("=== POSISI MUKA TIDAK BAGUS=== ");
      } else {
        _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);

        //SET FACE

        print("POSISI MUKA BAGUS");
        RECONIZE_FACE(image);
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
      if (_faceDetectorService.faceDetected) {
        User? user = await _mlService.predict();
        if (user != null) {
          enable_recognize_process = false;
          //  await _cameraService.takePicture();
          getDateTimeNow();
          pauseCameraAndMLKit();
          imglib.Image faceImage =
              _mlService.cropFace(image, _faceDetectorService.faces[0]);

          //  //TESTING ABSENSI

          //  textJamAbsensi = "2024-02-11 07:30:00";
          //  jamAbsensi = DateTime.parse(textJamAbsensi!);

          //  //TESTING ABSENSI

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

          // _reload();

          resumeCameraAndMLKit();
          enable_recognize_process = true;
        }
        // namaReconized = user?.employee_name ?? "UNRECONIZE";

        // var bottomSheetController = scaffoldKey.currentState!
        //     .showBottomSheet((context) => signInSheet(user: user));
        // bottomSheetController.closed.whenComplete(_reload);
      }
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
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
    return CameraDetectionPreview();
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
                  DigitalClock(
                      textScaleFactor: 2,
                      showSeconds: true,
                      isLive: true,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      datetime: DateTime.now()),
                  // Text(_latitude + "," + _longitude),
                  // Text(alamat)
                ],
              )
            ]),
            SizedBox(height: 5),
            Text(lat.toString() + " , " + long.toString()),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                alamat,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            )
          ]),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

  signInSheet({@required User? user}) => user == null
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Text(
            'User not found 😞',
            style: TextStyle(fontSize: 20),
          ),
        )
      : SignInSheet(user: user);

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
    _frameFaces();
  }
}
