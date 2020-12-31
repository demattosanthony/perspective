import 'dart:io';

import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:adv_camera/adv_camera.dart';
import 'package:point_of_view/locator.dart';

class AdvCameraModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  AdvCameraController _cameraController;
  List<String> _pictureSizes = [];
  List<Album> _myAlbums = [];
  Album _selctedAlbum;
  bool isUploading = false;
  String imagePath;
  bool _flashIsOn = false;

  AdvCameraController get cameraController => _cameraController;
  List<Album> get myAlbums => _myAlbums;
  Album get selectedAlbum => _selctedAlbum;
  bool get flashIsOn => _flashIsOn;

  onCameraCreated(AdvCameraController cameraController) {
    setState(ViewState.Busy);
    _cameraController = cameraController;

    // _cameraController
    //     .getPictureSizes()
    //     .then((pictureSizes) => {_pictureSizes = pictureSizes});
    _cameraController.setFlashType(FlashType.off);
    setState(ViewState.Idle);
  }

  void toggleFlash() {
    setState(ViewState.Busy);
    if (!_flashIsOn) {
      _flashIsOn = true;
      _cameraController.setFlashType(FlashType.on);
    } else {
      _flashIsOn = false;
      _cameraController.setFlashType(FlashType.off);
    }
    setState(ViewState.Idle);
  }

  void getAlbums() async {
    setState(ViewState.Busy);
    _myAlbums = await _apiService.getAlbums();
    setState(ViewState.Idle);
  }

  void uploadImage(File image) async {
    setState(ViewState.Busy);
    isUploading = true;
    var reponseCode = await _apiService.uploadImage(
        image, _selctedAlbum.title, _selctedAlbum.albumId);

    if (reponseCode != null) isUploading = false;
    setState(ViewState.Idle);
  }

  void setSelectedAlbum(album) {
    setState(ViewState.Busy);
    _selctedAlbum = album;
    setState(ViewState.Idle);
  }

  void setImagePathAndUpload(String path) {
    setState(ViewState.Busy);
    imagePath = path;
    uploadImage(File(imagePath));
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  AdvCameraModel() {
    getAlbums();
    print('reopned');
  }
}
