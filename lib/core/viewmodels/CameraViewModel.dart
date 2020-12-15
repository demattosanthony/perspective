import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:camera/camera.dart';

class CameraViewModel extends BaseModel {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  CameraDescription _camera;

  CameraDescription get camera => _camera;
  Future<void> get initalizeControllerFuture => _initializeControllerFuture;
  CameraController get controller => _controller;

  void setUpCamera() async {
    setState(ViewState.Busy);
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    _camera = cameras[1];

    _controller = CameraController(_camera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();
    setState(ViewState.Idle);
  }

  CameraViewModel() {
    setUpCamera();
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposing");
    _controller.dispose();
  }
}
