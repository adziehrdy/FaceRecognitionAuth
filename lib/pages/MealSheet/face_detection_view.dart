import 'package:camera/camera.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/MealSheet/detector_view.dart';
import 'package:face_net_authentication/pages/MealSheet/faceDetection_painter.dart';
import 'package:face_net_authentication/pages/MealSheet/success_mealsheet_page.dart';
import 'package:face_net_authentication/pages/fr_detected_page.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart' as intl;

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({Key? key, required this.MODE}) : super(key: key);

  final String MODE;
  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableTracking: false,
      performanceMode: FaceDetectorMode.fast,
      enableContours: false,
      enableLandmarks: false,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;
  MLService _mlService = locator<MLService>();

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
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLastLocation();
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

  getDateTimeNow() {
    setState(() {
      jamAbsensi = DateTime.now();
      intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss');
      textJamAbsensi = dateFormat.format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(
      CameraImage camImage, InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);

      if (faces.length != 0) {
        readyToReconize(
          camImage,
          faces[0],
        );
      }
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      // for (final face in faces) {
      //   text += 'face: ${face.boundingBox}\n\n';
      // }
      faces[0];

      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void readyToReconize(CameraImage camImage, Face face) {
    if (face.headEulerAngleY! > CONSTANT_VAR.headEulerY ||
        face.headEulerAngleY! < -CONSTANT_VAR.headEulerY ||
        face.headEulerAngleX! > CONSTANT_VAR.headEulerX ||
        face.headEulerAngleX! < -CONSTANT_VAR.headEulerX) {
      print("=== POSISI MUKA TIDAK BAGUS=== ");
    } else {
      _mlService.setCurrentPrediction(camImage, face);

      //SET FACE

      print("POSISI MUKA BAGUS");
      RECONIZE_FACE(camImage, face);
    }
  }

  RECONIZE_FACE(CameraImage image, Face face) async {
    if (enable_recognize_process) {
      // if (_faceDetectorService.faceDetected) {
      User? user = await _mlService.predict();
      if (user != null) {
        enable_recognize_process = false;
        //  await _cameraService.takePicture();
        getDateTimeNow();
        // pauseCameraAndMLKit();
        imglib.Image faceImage = _mlService.cropFace(image, face);

        //  //TESTING ABSENSI

        //  textJamAbsensi = "2024-01-04 01:51:46";
        //  jamAbsensi = DateTime.parse(textJamAbsensi!);

        //  //TESTING ABSENSI

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
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => successMealSheetPage(
                  jamAbsensi: DateTime.now(),
                  faceImage: convertImagelibToUint8List(faceImage),
                  user: user),
            ));

        // _reload();

        // resumeCameraAndMLKit();
        enable_recognize_process = true;
      }
      // namaReconized = user?.employee_name ?? "UNRECONIZE";

      // var bottomSheetController = scaffoldKey.currentState!
      //     .showBottomSheet((context) => signInSheet(user: user));
      // bottomSheetController.closed.whenComplete(_reload);
      // }
    }
  }
}
