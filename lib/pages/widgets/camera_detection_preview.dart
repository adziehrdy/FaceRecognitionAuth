import 'package:camera/camera.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:flutter/material.dart';

class CameraDetectionPreview extends StatelessWidget {
  CameraDetectionPreview({Key? key, required this.painterMode})
      : super(key: key);

  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();

  bool is_landscape = false;
  String painterMode;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        is_landscape = true;
        return landscapeLayout(context);
      } else {
        is_landscape = false;
        return portraitLayout(context);
      }
    });
  }

  Widget portraitLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                  if (_faceDetectorService.faceDetected)
                    CustomPaint(
                      painter: FacePainter(
                          face: _faceDetectorService.faces[0],
                          imageSize: _cameraService.getImageSize(),
                          painterMode: painterMode),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget landscapeLayout(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                  if (_faceDetectorService.faceDetected)
                    CustomPaint(
                      painter: FacePainter(
                          face: _faceDetectorService.faces[0],
                          imageSize: _cameraService.getImageSize(),
                          painterMode: painterMode),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
