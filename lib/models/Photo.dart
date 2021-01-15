class Photo {
  final int imageId;
  final String imageUrl;
  final int albumId;
  bool isSelected;
  final int userId;
  final String userProfImg;

  Photo(
      {this.imageId,
      this.imageUrl,
      this.albumId,
      this.isSelected = false,
      this.userId, this.userProfImg});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        imageId: json['photo_id'],
        imageUrl: json['photo_url'],
        albumId: json['album_id'],
        userId: json['user_id'],
        userProfImg: json['user_profile_img']);
  }
}
