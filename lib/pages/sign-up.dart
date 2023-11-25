import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/models/user.dart';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/pages/widgets/auth-action-button.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/repo/user_repos.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  bool is_landscape = false;
  String? imagePath;
  Face? faceDetected;
  Image? faceDetectedJPG;
  Size? imageSize;
  CameraImage? img;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;
  XFile? photoTakenFile;


  // service injection
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  MLService _mlService = locator<MLService>();

  UserRepo repo = UserRepo();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);

    await _cameraService.initialize();

    setState(() => _initializing = false);

    _frameFaces();
  }

  Future<bool> onShot() async {

    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Wajah Tidak Ditemukan, Mohon Coba kembali'),
          );
         
        },
      );

      return false;
    } else {
      _saving = true;
      // await Future.delayed(Duration(milliseconds: 500));
      // await Future.delayed(Duration(milliseconds: 200));
      showToast("Uploading Face..");
      photoTakenFile = await _cameraService.takePicture();
      await _cameraService.cameraController?.pausePreview();
      imagePath = photoTakenFile?.path;

      

      setState(() {

        enroll_face(context);
      });

      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {

       img = image;


      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          await _faceDetectorService.detectFacesFromImage(img!);

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];

              // faceDetectedJPG = faceDetected!.detectedFaceAsImage()


            });
            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            print('face is null');
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print('Error _faceDetectorService face => $e');
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = Container(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            ),
            transform: Matrix4.rotationY(mirror)),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          is_landscape = true;
          return landscapeLayout(context);
        } else {
          is_landscape = false;
          return portraitLayout(context);
        }
      },
    
  );
    }

    return Scaffold(
        body: Stack(
          children: [
            body,
            CameraHeader(
              widget.user.employee_name ?? "NO NAME",
              onBackPressed: _onBackPressed,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
                onPressed: onShot,
                isLogin: false,
                reload: _reload,
              )
            : Container());
  }

  Future enroll_face(context) async {
    List predictedData = _mlService.predictedData;
    String base64face = encode_FR_ToBase64(predictedData);
    String ImagePhoto = "";
    // print(base64face);

    try {
      // await convertXFIleToImage(photoTakenFile!).then((value) async {
      //   ImagePhoto = await imageToBase64(value);
      // });

      ImagePhoto = convertImagelibToBase64JPG(_mlService.cropFace(img!, faceDetected!));

      bool success_upload_fr = await repo.uploadFR(widget.user.employee_id!,
          encode_FR_ToBase64(predictedData), ImagePhoto);

      if (success_upload_fr) {
        await _dataBaseHelper.updateFaceTemplate(
            widget.user.employee_id!, predictedData, ImagePhoto);
        this._mlService.setPredictedData([]);
        showToast("Registrasi wajah sukses");
        Navigator.pop(context);
      } else {
        showToast("Kesalahan Saat Upload FR Ke server");
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      showToast("Gagal registrasi wajah, Mohon coba Kembali");
      await _cameraService.cameraController?.resumePreview();
      Navigator.pop(context);
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
            width: height * _cameraService.cameraController!.value.aspectRatio,
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
    ),
  );
}

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
            height: width * _cameraService.cameraController!.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_cameraService.cameraController!),
                CustomPaint(
                  child: Center(
                    
                    child: Container(padding: EdgeInsets.all(90), child: Image.asset("assets/images/face.png"),),
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
}
}
