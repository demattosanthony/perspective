class Photo {
  final int photoId;
  final String imageUrl;
  final int albumId;

  Photo({this.photoId, this.imageUrl, this.albumId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        photoId: json['photo_id'],
        imageUrl: json['image_url'],
        albumId: json['album_id']);
  }
}
