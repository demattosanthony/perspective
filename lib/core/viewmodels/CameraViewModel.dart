import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:camera/camera.dart';
import 'package:point_of_view/locator.dart';
import 'dart:io';

class CameraViewModel extends BaseModel {
  ApiService _apiService = locator<ApiService>();
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  CameraDescription _camera;
  List<CameraDescription> _availableCameras;
  List<Album> _myAlbums = [];
  Album _selctedAlbum;
  bool isUploading = false;

  CameraDescription get camera => _camera;
  Future<void> get initalizeControllerFuture => _initializeControllerFuture;
  CameraController get controller => _controller;
  List<Album> get myAlbums => _myAlbums;
  Album get selectedAlbum => _selctedAlbum;

  void setUpCamera() async {
    setState(ViewState.Busy);
    final cameras = await availableCameras();
    _availableCameras = cameras;

    // Get a specific camera from the list of available cameras.
    _camera = cameras[0];

    _controller = CameraController(_camera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();
    setState(ViewState.Idle);
  }

  void getAlbums() async {
    setState(ViewState.Busy);
    _myAlbums = await _apiService.getAlbums();
    setState(ViewState.Idle);
  }

  void cameraToggle() {
    setState(ViewState.Busy);
    if (_camera == _availableCameras[0]) {
      _camera = _availableCameras[1];
    } else {
      _camera = _availableCameras[0];
    }
    _controller = CameraController(_camera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();
    setState(ViewState.Idle);
  }

  void uploadImage(File image) async {
    setState(ViewState.Busy);
    isUploading = true;
    var reponseCode = await _apiService.uploadAlbumImage(
        image, _selctedAlbum.title, _selctedAlbum.albumId);
    if (reponseCode != null) isUploading = false;
    setState(ViewState.Idle);
  }

  void setSelectedAlbum(album) {
    setState(ViewState.Busy);
    _selctedAlbum = album;
    setState(ViewState.Idle);
  }

  CameraViewModel() {
    setUpCamera();
    getAlbums();
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposing");
    _controller.dispose();
  }
}
