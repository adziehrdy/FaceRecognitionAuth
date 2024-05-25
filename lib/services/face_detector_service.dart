import 'package:camera/camera.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectorService {
  CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
            performanceMode: FaceDetectorMode.fast,
            minFaceSize: 0.9,
            enableContours: false,
            enableClassification: false));
  }

  double compareSizePercentage(Size size1, Size size2) {
    double widthPercentage = (size1.width / size2.width) * 100;
    double heightPercentage = (size1.height / size2.height) * 100;
    return (widthPercentage + heightPercentage) / 2;
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation:
          _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.yuv_420_888,
      size: imageSize,
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    InputImage _firebaseVisionImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: _firebaseImageMetadata,
    );

    List<Face> _faces_preprocess =
        await _faceDetector.processImage(_firebaseVisionImage);

    if (_faces_preprocess.isNotEmpty) {
      double precentace = compareSizePercentage(
          imageSize,
          Size(_faces_preprocess[0].boundingBox.width.toDouble(),
              _faces_preprocess[0].boundingBox.height.toDouble()));

      print("COMPARE SIZE " + precentace.toString());

      if (precentace > 230 && precentace < 350) {
        print("FACE_SIZE =" + precentace.toString());
        _faces = _faces_preprocess;
      } else {
        _faces = [];
      }
    }
  }

  dispose() {
    _faceDetector.close();
  }
}
