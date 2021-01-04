import 'package:point_of_view/models/Photo.dart';
import 'package:rx_command/rx_command.dart';

abstract class AlbumManager {
  void addToSelectedPhotos(Photo photo);
  void deleteFromSelectedPhotos(Photo photo);
  List<Photo> getSelectedImages();
}

class AlbumManagerImplmenetation implements AlbumManager {
  List<Photo> _selectedPhotos = [];

  void addToSelectedPhotos(Photo photo) {
    if (_selectedPhotos
        .where((element) => element.imageId == photo.imageId)
        .isEmpty) {
      _selectedPhotos.add(photo);
    } else {
      print('already in list');
    }
    print(_selectedPhotos);
  }

  void deleteFromSelectedPhotos(Photo photo) {
    _selectedPhotos.removeWhere((element) => element.imageId == photo.imageId);
  }

  List<Photo> getSelectedImages() {
    return _selectedPhotos;
  }

}
