// import 'package:face_net_authentication/locator.dart';
// import 'package:face_net_authentication/services/camera.service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class FaceDetectorService {
//   CameraService _cameraService = locator<CameraService>();

//   late FaceDetector _faceDetector;
//   FaceDetector get faceDetector => _faceDetector;

//   List<Face> _faces = [];
//   List<Face> get faces => _faces;
//   bool get faceDetected => _faces.isNotEmpty;

//   void initialize() {
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.fast,
//       ),
//     );

//     // _faceDetector = FaceDetector(
//     //     options: FaceDetectorOptions(
//     //         performanceMode: FaceDetectorMode.fast,
//     //         enableContours: true,
//     //         enableClassification: true));
//   }

//   Future<void> detectFacesFromImage(CameraImage image) async {
//     // Combine all the bytes from the image planes
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();

//     // Create the InputImageMetadata using image properties
//     final InputImageMetadata metadata = InputImageMetadata(
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       rotation:
//           _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
//       format: InputImageFormatValue.fromRawValue(image.format.raw) ??
//           InputImageFormat.yuv_420_888,
//       bytesPerRow: image.planes[0]
//           .bytesPerRow, // Assuming the first plane holds the row stride
//     );

//     // Create InputImage using bytes and metadata
//     final InputImage _firebaseVisionImage = InputImage.fromBytes(
//       bytes: bytes,
//       metadata: metadata,
//     );

//     // Process the image to detect faces
//     _faces = await _faceDetector.processImage(_firebaseVisionImage);
//   }

//   Future<List<Face>> detect(
//       CameraImage image, InputImageRotation rotation) async {
//     final faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.accurate,
//         enableLandmarks: true,
//       ),
//     );

//     // Combine all the bytes from the image planes
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();

//     // Define the size of the image
//     final Size imageSize =
//         Size(image.width.toDouble(), image.height.toDouble());

//     // Define the input image format
//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(image.format.raw) ??
//             InputImageFormat.yuv_420_888;

//     // Create metadata for the input image
//     final InputImageMetadata metadata = InputImageMetadata(
//       size: imageSize,
//       rotation: rotation,
//       format: inputImageFormat,
//       bytesPerRow: image.planes[0]
//           .bytesPerRow, // Assuming the first plane holds the row stride
//     );

//     // Process the image using the face detector
//     return faceDetector.processImage(
//       InputImage.fromBytes(
//         bytes: bytes,
//         metadata: metadata,
//       ),
//     );
//   }

//   ///for new version
//   // Future<void> detectFacesFromImage(CameraImage image) async {
//   //   // InputImageData _firebaseImageMetadata = InputImageData(
//   //   //   imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
//   //   //   inputImageFormat: InputImageFormatMethods ?? InputImageFormat.nv21,
//   //   //   size: Size(image.width.toDouble(), image.height.toDouble()),
//   //   //   planeData: image.planes.map(
//   //   //     (Plane plane) {
//   //   //       return InputImagePlaneMetadata(
//   //   //         bytesPerRow: plane.bytesPerRow,
//   //   //         height: plane.height,
//   //   //         width: plane.width,
//   //   //       );
//   //   //     },
//   //   //   ).toList(),
//   //   // );
//   //
//   //   final WriteBuffer allBytes = WriteBuffer();
//   //   for (Plane plane in image.planes) {
//   //     allBytes.putUint8List(plane.bytes);
//   //   }
//   //   final bytes = allBytes.done().buffer.asUint8List();
//   //
//   //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//   //
//   //   InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;
//   //
//   //   final inputImageData = InputImageData(
//   //     size: imageSize,
//   //     imageRotation: imageRotation,
//   //     inputImageFormat: InputImageFormat.yuv420,
//   //     planeData: image.planes.map(
//   //           (Plane plane) {
//   //         return InputImagePlaneMetadata(
//   //           bytesPerRow: plane.bytesPerRow,
//   //           height: plane.height,
//   //           width: plane.width,
//   //         );
//   //       },
//   //     ).toList(),
//   //   );
//   //
//   //   InputImage _firebaseVisionImage = InputImage.fromBytes(
//   //     bytes: bytes,
//   //     inputImageData: inputImageData,
//   //   );
//   //
//   //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
//   // }

//   dispose() {
//     _faceDetector.close();
//   }
// }
