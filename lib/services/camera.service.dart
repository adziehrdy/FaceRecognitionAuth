import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraService {
  CameraController? _cameraController;
  CameraController? get cameraController => this._cameraController;

  InputImageRotation? _cameraRotation;
  InputImageRotation? get cameraRotation => this._cameraRotation;

  String? _imagePath;
  String? get imagePath => this._imagePath;
  bool landscape_mode = false;
  bool isSignupMode;

  // Constructor
  CameraService({required this.isSignupMode});

  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    landscape_mode = await prefs.getBool("LANDSCAPE_MODE") ?? false;

    if (_cameraController != null) return;
    CameraDescription description = await _getCameraDescription();
    if (landscape_mode) {
      await _setupCameraController(description: description);
      this._cameraRotation = rotationIntToImageRotation(
        0,
      );
    } else {
      await _setupCameraController(description: description);
      this._cameraRotation = rotationIntToImageRotation(
        description.sensorOrientation,
      );
    }
  }

  Future<CameraDescription> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
  }

  Future _setupCameraController({
    required CameraDescription description,
  }) async {
    // if (isSignupMode) {
    //   this._cameraController = CameraController(
    //     description,
    //     ResolutionPreset.max,
    //     enableAudio: false,
    //   );
    // } else {
    this._cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    // }

    await _cameraController?.initialize();
    await _cameraController?.setFocusMode(FocusMode.auto);
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<XFile?> takePicture() async {
    assert(_cameraController != null, 'Camera controller not initialized');
    await _cameraController?.stopImageStream();
    XFile? file = await _cameraController?.takePicture();
    _imagePath = file?.path;
    return file;
  }

  Size getImageSize() {
    assert(_cameraController != null, 'Camera controller not initialized');
    assert(
        _cameraController!.value.previewSize != null, 'Preview size is null');
    if (landscape_mode) {
      return Size(
        _cameraController!.value.previewSize!.width,
        _cameraController!.value.previewSize!.height,
      );
    } else {
      return Size(
        _cameraController!.value.previewSize!.height,
        _cameraController!.value.previewSize!.width,
      );
    }
  }

  dispose() async {
    await this._cameraController?.dispose();
    this._cameraController = null;
  }
}
