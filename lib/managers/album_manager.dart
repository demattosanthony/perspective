
abstract class AlbumManager {
  // RxCommand<void, List<Album>> getAlbums;
  // RxCommand<int, List<Photo>> getAlbumImages;
}

class AlbumManagerImplmenetation implements AlbumManager {
  // @override
  // RxCommand<void, List<Album>> getAlbums;

  @override
  // RxCommand<int, List<Photo>> getAlbumImages;

  AlbumManagerImplmenetation() {
    // getAlbums = RxCommand.createAsyncNoParam<List<Album>>(
    //     locator.get<AlbumService>().getAlbums);

    // getAlbumImages = RxCommand.createAsync(
    //     (albumId) => locator<AlbumService>().getPhotos(albumId));

  }

}
