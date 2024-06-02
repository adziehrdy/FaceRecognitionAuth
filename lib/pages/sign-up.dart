import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

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

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  late imglib.Image faceImage;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

    // adzieFAS.loadModelFromAssets();

    _start();
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

        if (blurScore > 1000) {
          RECONIZE_FACE(image);

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
    if (_faceDetectorService.faceDetected) {
      // imglib.Image faceImageAS =
      //     cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);
      imglib.Image FAS_CROP =
          cropFaceANTISPOOF(image, _faceDetectorService.faces[0]);

      bool isSpoof = await FAS.deSpoofing(FAS_CROP);

      if (isSpoof) {
        painterMode = "SPOOF";
        realCounter = 0;
      } else {
        if (SpoofCounter >= 2) {
          painterMode = "GOOD";
          SpoofCounter = 0;
        }
      }

      // bool? isSpoof = await FaceAntiSpoofing.antiSpoofing(faceImageAS);
      // bool? isSpoof = await adzieFAS.isFaceSpoofedWithModel(
      //     image, _faceDetectorService.faces[0], context);

      // namaReconized = user?.employee_name ?? "UNRECONIZE";

      // var bottomSheetController = scaffoldKey.currentState!
      //     .showBottomSheet((context) => signInSheet(user: user));
      // bottomSheetController.closed.whenComplete(_reload);
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
    // await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => FrDetectedPage(
    //         // employee_name: user.employee_name!,
    //         textJamAbsensi: textJamAbsensi!,
    //         jamAbsensi: jamAbsensi!,
    //         alamat: alamat,
    //         lat: lat.toString(),
    //         long: long.toString(),
    //         // company_id: user.company_id!,
    //         // employee_id: user.employee_id!,
    //         type_absensi: widget.MODE,
    //         faceImage: convertImagelibToUint8List(faceImage),
    //         user: user,
    //       ),
    //     ));

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
    Widget header =
        CameraHeader((widget.user.employee_name ?? "-").toUpperCase());
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

<<<<<<< Updated upstream
  Future enroll_face(context) async {
    await _cameraService.cameraController?.pausePreview();

    List predictedData = _mlService.predictedData;
    // String base64face = encode_FR_ToBase64(predictedData);
    String ImagePhoto = "";
    // print(base64face);

    try {
      // await convertXFIleToImage(photoTakenFile!).then((value) async {
      //   ImagePhoto = await imageToBase64(value);
      // });

      String frTemplateBase64 = encode_FR_ToBase64(predictedData);

      // frTemplateBase64 = "W10=";

      if (frTemplateBase64 == "W10=" || frTemplateBase64.length < 50) {
        throw Exception('Hasil prediksi error');
      }

      ImagePhoto =
          convertImagelibToBase64JPG(_mlService.cropFace(img!, faceDetected!));

      //JIKA HASIL PREDICTED ERROR

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog_confirm_fr(
            faceImage: convertImagelibToUint8List(
                _mlService.cropFace(img!, faceDetected!)),
            employeeName: (widget.user.employee_name ?? "-").toUpperCase(),
            onApprove: () async {
              showToastShort("Uploading..");
              bool success_upload_fr = await repo.uploadFR(
                  widget.user.employee_id!, frTemplateBase64, ImagePhoto);

              if (success_upload_fr) {
                await _dataBaseHelper.updateFaceTemplate(
                    widget.user.employee_id!, predictedData, ImagePhoto);
                this._mlService.setPredictedData([]);
                bool isApproved = await hitApproveFR(widget.user);

                if (isApproved) {
                  //UPDATE TO DB

                  showToast("Registrasi wajah sukses !");
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  showToast("Gagal Approve FR, Mohon Coba Kembali");
                  Navigator.pop(context);
                }
              } else {
                showToast(
                    "Kesalahan Saat Upload FR Ke server, Mohon Coba Kembali");
                Navigator.pop(context);
              }
            },
          );
        },
      );
      await _cameraService.cameraController?.resumePreview();
      _frameFaces();
    } catch (e) {
      print(e);
      showToastShort("GAGAL Saat registrasi wajah, Mohon coba Kembali");
      //  Navigator.pop(context);
      _reload();
      await _cameraService.cameraController?.resumePreview();
      _frameFaces();
    }
  }

  Widget landscapeLayout(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // Kode untuk tampilan landscape
    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width:
                  height * _cameraService.cameraController!.value.aspectRatio,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_cameraService.cameraController!),
                  CustomPaint(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(100),
                        child: Image.asset("assets/images/face.png"),
                      ),
                    ),
                    painter: FacePainter(
                      face: faceDetected,
                      imageSize: imageSize!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
=======
            Text("NOT BLUR SCORE = " + blurScore.toString()),
            // Text("BLUR SCORE = " + bl),
          ]),
        ],
>>>>>>> Stashed changes
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

<<<<<<< Updated upstream
  Widget portraitLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Kode untuk tampilan potret
    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Container(
              width: width,
              height:
                  width * _cameraService.cameraController!.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_cameraService.cameraController!),
                  CustomPaint(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(90),
                        child: Image.asset("assets/images/face.png"),
                      ),
                    ),
                    painter: FacePainter(
                      face: faceDetected,
                      imageSize: imageSize!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
=======
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
>>>>>>> Stashed changes
  }
}

// Widget landscapeLayout(BuildContext context) {
//   double height = MediaQuery.of(context).size.height;
//   // Kode untuk tampilan landscape
//   return Transform.scale(
//     scale: 1.0,
//     child: AspectRatio(
//       aspectRatio: MediaQuery.of(context).size.aspectRatio,
//       child: OverflowBox(
//         alignment: Alignment.center,
//         child: FittedBox(
//           fit: BoxFit.fitWidth,
//           child: Container(
//             width: height * _cameraService.cameraController!.value.aspectRatio,
//             height: height,
//             child: Stack(
//               fit: StackFit.expand,
//               children: <Widget>[
//                 CameraPreview(_cameraService.cameraController!),
//                 CustomPaint(
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.all(150),
//                       child: Image.asset("assets/images/face.png"),
//                     ),
//                   ),
//                   painter: FacePainter(
//                       face: faceDetected,
//                       imageSize: imageSize!,
//                       painterMode: ""),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget portraitLayout(BuildContext context) {
//   double width = MediaQuery.of(context).size.width;
//   // Kode untuk tampilan potret
//   return Transform.scale(
//     scale: 1.0,
//     child: AspectRatio(
//       aspectRatio: MediaQuery.of(context).size.aspectRatio,
//       child: OverflowBox(
//         alignment: Alignment.center,
//         child: FittedBox(
//           fit: BoxFit.fitHeight,
//           child: Container(
//             width: width,
//             height: width * _cameraService.cameraController!.value.aspectRatio,
//             child: Stack(
//               fit: StackFit.expand,
//               children: <Widget>[
//                 CameraPreview(_cameraService.cameraController!),
//                 CustomPaint(
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.all(90),
//                       child: Image.asset("assets/images/face.png"),
//                     ),
//                   ),
//                   painter: FacePainter(
//                       face: faceDetected,
//                       imageSize: imageSize!,
//                       painterMode: ""),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
