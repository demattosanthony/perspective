import 'package:adv_camera/adv_camera.dart';

abstract class CameraManager {
  void onCameraCreated(AdvCameraController cameraController);
}

class CameraManagerImplementation implements CameraManager {
  AdvCameraController _cameraController;
  bool _flashIsOn = false;
  bool _isUploading = false;
  String imagePath;

  AdvCameraController get cameraController => _cameraController;
  bool get flashIsOn => _flashIsOn;
  bool get isUploading => _isUploading;

  onCameraCreated(AdvCameraController cameraController) {
    _cameraController = cameraController;

    _cameraController.setFlashType(FlashType.off);
  }
}
