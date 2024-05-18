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
    // _faceDetector = GoogleMlKit.vision.faceDetector(
    //   FaceDetectorOptions(
    //     performanceMode: FaceDetectorMode.fast,
    //     minFaceSize: 0.1,
    //   ),
    // );
// ====
    _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
            performanceMode: FaceDetectorMode.fast,
            minFaceSize: 0.9,
            enableContours: false,
            enableClassification: false));
    // /====
  }

  double compareSizePercentage(Size size1, Size size2) {
    double widthPercentage = (size1.width / size2.width) * 100;
    double heightPercentage = (size1.height / size2.height) * 100;
    return (widthPercentage + heightPercentage) / 2;
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    print(imageSize);
    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation:
          _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,

      // inputImageFormat: InputImageFormat.yuv_420_888,

      inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw)
          // InputImageFormatMethods.fromRawValue(image.format.raw)
          //for new version
          ??
          InputImageFormat.yuv_420_888,
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

    // for mlkit 13
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    InputImage _firebaseVisionImage = InputImage.fromBytes(
      // bytes: image.planes[0].bytes,
      bytes: bytes,
      inputImageData: _firebaseImageMetadata,
    );
    // for mlkit 13

    List<Face> _faces_preprocess =
        await _faceDetector.processImage(_firebaseVisionImage);

    // if (_faces_preprocess.isNotEmpty) {
    //     double precentace = compareSizePercentage(
    //         imageSize,
    //         Size(_faces_preprocess[0].boundingBox.width.toDouble(),
    //             _faces_preprocess[0].boundingBox.height.toDouble()));

    //     print("COMPARE SIZE " + precentace.toString());

    //     if (precentace > 300 && precentace < 500) {
    //       _faces = _faces_preprocess;
    //     }
    //   }
    // }
    _faces = _faces_preprocess;
  }

  // Future<List<Face>> detect(CameraImage image, InputImageRotation rotation) {
  //   final faceDetector = GoogleMlKit.vision.faceDetector(
  //     FaceDetectorOptions(
  //         performanceMode: FaceDetectorMode.fast,
  //         minFaceSize: 0.9,
  //         enableLandmarks: false,
  //         enableContours: false,
  //         // enableTracking: true,
  //         enableClassification: false),
  //   );
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();

  //   final Size imageSize =
  //       Size(image.width.toDouble(), image.height.toDouble());
  //   final inputImageFormat =
  //       InputImageFormatValue.fromRawValue(image.format.raw) ??
  //           InputImageFormat.yuv_420_888;

  //   final planeData = image.planes.map(
  //     (Plane plane) {
  //       return InputImagePlaneMetadata(
  //         bytesPerRow: plane.bytesPerRow,
  //         height: plane.height,
  //         width: plane.width,
  //       );
  //     },
  //   ).toList();

  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: rotation,
  //     inputImageFormat: inputImageFormat,
  //     planeData: planeData,
  //   );

  //   return faceDetector.processImage(
  //     InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData),
  //   );
  // }

  ///for new version
  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   // InputImageData _firebaseImageMetadata = InputImageData(
  //   //   imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
  //   //   inputImageFormat: InputImageFormatMethods ?? InputImageFormat.nv21,
  //   //   size: Size(image.width.toDouble(), image.height.toDouble()),
  //   //   planeData: image.planes.map(
  //   //     (Plane plane) {
  //   //       return InputImagePlaneMetadata(
  //   //         bytesPerRow: plane.bytesPerRow,
  //   //         height: plane.height,
  //   //         width: plane.width,
  //   //       );
  //   //     },
  //   //   ).toList(),
  //   // );
  //
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //
  //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  //
  //   InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;
  //
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: imageRotation,
  //     inputImageFormat: InputImageFormat.yuv420,
  //     planeData: image.planes.map(
  //           (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );
  //
  //   InputImage _firebaseVisionImage = InputImage.fromBytes(
  //     bytes: bytes,
  //     inputImageData: inputImageData,
  //   );
  //
  //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
  // }

  dispose() {
    _faceDetector.close();
  }
}
