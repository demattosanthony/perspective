
import 'package:point_of_view/models/Album.dart';
import 'package:rx_command/rx_command.dart';

abstract class CameraManager {
  RxCommand<Album, Album> selectedAlbum;
}

class CameraManagerImplementation implements CameraManager {
  @override
  RxCommand<Album, Album> selectedAlbum;


  CameraManagerImplementation() {
    selectedAlbum = RxCommand.createSync((album) => album);

  }

}
