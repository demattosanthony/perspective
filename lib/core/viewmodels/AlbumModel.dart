import 'package:point_of_view/core/models/Photo.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';

class AlbumModel extends BaseModel {
  final AlbumService _albumService = locator<AlbumService>();

  Future<List<Photo>> get photos => _albumService.photos;
  

}
