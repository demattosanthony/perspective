
class Photo {
  final int imageId;
  final String imageUrl;
  final int albumId;
  bool isSelected;
  final int userId;

  Photo(
      {this.imageId,
      this.imageUrl,
      this.albumId,
      this.isSelected = false,
      this.userId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        imageId: json['photo_id'],
        imageUrl: json['photo_url'],
        albumId: json['album_id'],
        userId: json['user_id']);
  }

  
}
