class Photo {
  final int imageId;
  final String imageUrl;
  final int albumId;
  bool isSelected;
  final String userId;
  final String userProfImg;

  Photo(
      {required this.imageId,
      required this.imageUrl,
      required this.albumId,
      this.isSelected = false,
      required this.userId,
      required this.userProfImg});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        imageId: json['photo_id'],
        imageUrl: json['photo_url'],
        albumId: json['album_id'],
        userId: json['user_id'],
        userProfImg: json['user_profile_img']);
  }
}
