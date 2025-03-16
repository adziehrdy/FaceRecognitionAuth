import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/pages/widgets/auth-action-button.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/dialog_confirm_FR.dart';
import 'package:face_net_authentication/repo/user_repos.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'db/databse_helper_employee.dart';

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
  int blurScore = 0;
  int maxBlurScore = 700;
  int lightScore = 0;
  Color blurIndicatorColor = Colors.red;
  Color lightIndicatorColor = Colors.red;

  int blurThreshold = 450;
  int lightThreshold = 300;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;
  XFile? photoTakenFile;
  bool _loading = false; // Variable untuk menampilkan loading

  int counterForPrintLiveness = 0;

  // service injection
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  CameraService _cameraService = CameraService(isSignupMode: true);
  MLService _mlService = locator<MLService>();

  UserRepo repo = UserRepo();

  Queue<double> dataQueue = Queue<double>();
  bool canRegister = false;

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

      // showDialog(
      //   context: context,
      //   barrierDismissible:
      //       true, // Menyembunyikan dialog saat pengguna menyentuh di luar dialog
      //   builder: (BuildContext context) {
      //     return Center(
      //       child:
      //           CircularProgressIndicator(), // Tampilkan CircularProgressIndicator
      //     );
      //   },
      // );
      photoTakenFile = await _cameraService.takePicture();

      imagePath = photoTakenFile?.path;

      setState(() async {
        await enroll_face(context);
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
          faceDetected = _faceDetectorService.faces[0];

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() async {
              if (_faceDetectorService.faces[0].headEulerAngleY! >
                      CONSTANT_VAR.headEulerY ||
                  _faceDetectorService.faces[0].headEulerAngleY! <
                      -CONSTANT_VAR.headEulerY ||
                  _faceDetectorService.faces[0].headEulerAngleX! >
                      CONSTANT_VAR.headEulerX ||
                  _faceDetectorService.faces[0].headEulerAngleX! <
                      -CONSTANT_VAR.headEulerX) {
                setState(() {
                  blurScore = 0;
                  lightScore = 0;
                });

                canRegister = true;
              } else {
                await blurCheck(image);
                await lightCheck(image);

                if (blurScore >= blurThreshold &&
                    lightScore >= lightThreshold) {
                  setState(() {
                    canRegister = false;
                  });
                } else {
                  setState(() {
                    canRegister = true;
                  });
                }
              }
            });

            if (_saving) {
              _mlService.setCurrentPrediction(
                  image, _faceDetectorService.faces[0]);
              setState(() {
                _saving = false;
              });
            }
          } else {
            dataQueue.clear();
            print("AVERAGE LIVENESS = CLEANED");

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

  // _frameFaces() {
  //   imageSize = _cameraService.getImageSize();

  //   _cameraService.cameraController?.startImageStream((image) async {
  //     img = image;

  //     if (_cameraService.cameraController != null) {
  //       if (_detectingFaces) return;

  //       _detectingFaces = true;

  //       try {
  //         await _faceDetectorService.detectFacesFromImage(img!);

  //         if (_faceDetectorService.faces.isNotEmpty) {
  //           print("EYE RIGHT PROBABILITY = "+_faceDetectorService.faces[0].rightEyeOpenProbability.toString());
  //           print("EYE LEFT PROBABILITY = "+_faceDetectorService.faces[0].leftEyeOpenProbability.toString());
  //           setState(() {
  //             if (_faceDetectorService.faces[0].headEulerAngleY! > 10 ||
  //                 _faceDetectorService.faces[0].headEulerAngleY! < -10) {

  //             } else {
  //               faceDetected = _faceDetectorService.faces[0];
  //             }
  //             // faceDetectedJPG = faceDetected!.detectedFaceAsImage()
  //           });
  //           if (_saving) {
  //             _mlService.setCurrentPrediction(image, faceDetected);
  //             setState(() {
  //               _saving = false;
  //             });
  //           }
  //         } else {
  //           print('face is null');
  //           setState(() {
  //             faceDetected = null;
  //           });
  //         }

  //         _detectingFaces = false;
  //       } catch (e) {
  //         print('Error _faceDetectorService face => $e');
  //         _detectingFaces = false;
  //       }
  //     }
  //   });
  // }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  blurCheck(image) async {
    int laplaceScore = await laplacian(
        _mlService.cropFace(image, _faceDetectorService.faces[0]));
    print("BLURR SCORE " + laplaceScore.toString());

    setState(() {
      if (laplaceScore >= blurThreshold) {
        blurIndicatorColor = Colors.green;
      } else {
        blurIndicatorColor = Colors.red;
      }

      if (laplaceScore >= maxBlurScore) {
        blurScore = maxBlurScore;
      } else {
        blurScore = laplaceScore;
      }
    });
  }

  lightCheck(image) async {
    int light = await lightDetection(
        _mlService.cropFace(image, _faceDetectorService.faces[0]));
    print("LIGHT SCORE " + light.toString());

    setState(() {
      if (light >= lightThreshold) {
        lightIndicatorColor = Colors.green;
      } else {
        lightIndicatorColor = Colors.red;
      }

      if (light >= 500) {
        lightScore = 500;
      } else {
        lightScore = light;
      }
    });
  }

/////===============
  void addData(double newData) {
    counterForPrintLiveness = counterForPrintLiveness + 1;
    dataQueue.add(newData);
    if (dataQueue.length > 10) {
      dataQueue.removeFirst();
    }
    if (counterForPrintLiveness == 5) {
      counterForPrintLiveness = 0;
      print("AVERAGE LIVENESS = " + calculateThreshold(dataQueue).toString());
    }
  }

  double calculateThreshold(Queue<double> data) {
    double sum = 0;
    int count = 0;
    double previousValue = 0;

    for (var value in data) {
      if (count > 0) {
        sum += (value - previousValue).abs();
      }
      previousValue = value;
      count++;
    }

    if (count > 1) {
      double average = sum / (count - 1);
      return average;
    }

    return 0;
  }

/////===============

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    this._start();
    _start();
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
            Positioned(
              top: 50,
              left: 50,
              child:
                  indicatorWidget(), // Gauge indicators displayed on top left
            ),
            Column(
              children: [
                CameraHeader(
                  widget.user.employee_name ?? "NO NAME",
                  onBackPressed: _onBackPressed,
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: !canRegister
        //BYPASS REGISTER CHECKER
        floatingActionButton: true
            ? AuthActionButton(
                onPressed: onShot,
                isLogin: false,
                reload: _reload,
              )
            : Container());
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
            child: Stack(
              children: [
                Container(
                  width: height *
                      _cameraService.cameraController!.value.aspectRatio,
                  height: height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CameraPreview(_cameraService.cameraController!),
                      CustomPaint(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(130),
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
              ],
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
  }

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

      print(ImagePhoto);

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

  Widget indicatorWidget() {
    return Container(
        width: 160,
        height: 400,
        child: Row(
          children: [
            LinearGauge(
              gaugeOrientation: GaugeOrientation.vertical,
              linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                  linearGaugeValueColor: blurIndicatorColor,
                  borderRadius: 30,
                  thickness: 10,
                  backgroundColor: Colors.white),
              start: 0,
              end: 500,
              customLabels: [
                CustomRulerLabel(text: "Gelap", value: 0),
                CustomRulerLabel(
                    text: "Cukup", value: lightThreshold.toDouble()),
                CustomRulerLabel(text: "Terang", value: 500)
              ],
              steps: 1,
              pointers: [
                WidgetPointer(
                    pointerPosition: PointerPosition.left,
                    value: lightScore.toDouble(),
                    child: Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.blue,
                    ))
              ],
              valueBar: [
                ValueBar(
                  value: lightScore.toDouble(),
                  color: lightIndicatorColor,
                )
              ],
              rulers: RulerStyle(
                textStyle: TextStyle(color: Colors.black, fontSize: 12),
                primaryRulerColor: Colors.blue,
                secondaryRulerColor: Colors.blue,
                showLabel: true,
                labelOffset: 10,
                rulerPosition: RulerPosition.left,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            LinearGauge(
              gaugeOrientation: GaugeOrientation.vertical,
              linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                  linearGaugeValueColor: blurIndicatorColor,
                  borderRadius: 30,
                  thickness: 10,
                  backgroundColor: Colors.white),
              start: 0,
              end: maxBlurScore.toDouble(),
              customLabels: [
                CustomRulerLabel(text: "Foto Blur", value: 0),
                CustomRulerLabel(
                    text: "Tidak Blur", value: blurThreshold.toDouble()),
                CustomRulerLabel(
                    text: "Foto Jelas", value: maxBlurScore.toDouble())
              ],
              steps: 1,
              pointers: [
                WidgetPointer(
                    pointerPosition: PointerPosition.right,
                    value: blurScore.toDouble(),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.blue,
                    ))
              ],
              valueBar: [
                ValueBar(
                  value: blurScore.toDouble(),
                  color: blurIndicatorColor,
                )
              ],
              rulers: RulerStyle(
                textStyle: TextStyle(color: Colors.black, fontSize: 12),
                primaryRulerColor: Colors.blue,
                secondaryRulerColor: Colors.blue,
                showLabel: true,
                labelOffset: 10,
                rulerPosition: RulerPosition.right,
              ),
            ),
          ],
        ));
  }
}
