
import 'package:point_of_view/models/Photo.dart';
import 'package:rx_command/rx_command.dart';

abstract class AlbumManager {
  RxCommand<Photo, List<Photo>> getSelectedImages;
}

class AlbumManagerImplmenetation implements AlbumManager {

  List<Photo> _selectedPhotos = [];

  AlbumManagerImplmenetation() {


    getSelectedImages = RxCommand.createSync((photo) {    
      _selectedPhotos.add(photo);
      return _selectedPhotos;
    });
  }

  @override
  RxCommand<Photo, List<Photo>> getSelectedImages;
}
