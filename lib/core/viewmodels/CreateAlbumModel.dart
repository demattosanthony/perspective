import 'package:flutter/material.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import 'package:image_picker/image_picker.dart';

class CreateAlbumModel extends BaseModel {
  final AlbumService _albumService = locator<AlbumService>();

  TextEditingController _albumTitleController = new TextEditingController();
  TextEditingController _albumCodeController = new TextEditingController();

  TextEditingController get albumTitleController => _albumTitleController;
  TextEditingController get albumCodeController => _albumCodeController;

  String _image;
  String get image => _image;

  final picker = ImagePicker();

  Future<int> joinAlbum(sharedString) async {
    setState(ViewState.Busy);
    var code = await _albumService.joinAlbum(sharedString);
    setState(ViewState.Idle);
    return code;
  }

  Future getImage() async {
    setState(ViewState.Busy);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile.path;
    } else {
      print('No image selected.');
    }
    setState(ViewState.Idle);
  }

  void uploadImage(String eventId) async {
    setState(ViewState.Busy);
    //_firebaseStorageService.uploadImage(
    //  _image, 'event_images/${_eventTextFieldController.text}', eventId);
    setState(ViewState.Idle);
  }

  Future<String> createAlbum() async {
    setState(ViewState.Busy);

    var shareString =
        await _albumService.createAlbum(_albumTitleController.text);
    _albumService.getAlbums();

    setState(ViewState.Idle);
    return shareString;
  }
}
