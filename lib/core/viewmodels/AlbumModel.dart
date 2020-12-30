import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/Photo.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';

class AlbumModel extends BaseModel {
  final AlbumService _albumService = locator<AlbumService>();

  Future<List<Photo>> get photos => _albumService.photos;

  bool isSelectingImages = false;

  void setSelectingImages() async {
    setState(ViewState.Busy);
    isSelectingImages = !isSelectingImages;
    if (isSelectingImages == false) {
      var photosList = await photos;
      for (var photo in photosList) {
        photo.isSelected = false;
      }
    }
    setState(ViewState.Idle);
  }

  void setImageSelected(int photoId) async {
    setState(ViewState.Busy);
    var photosList = await photos;
    for (var photo in photosList) {
      if (photo.photoId == photoId) {
        photo.isSelected = !photo.isSelected;
      }
    }
    setState(ViewState.Busy);
  }
}
