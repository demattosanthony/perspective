class Album {
  final int albumId;
  final String title;
  final int ownerId;
  final String shareString;
  final String profileImgUrl;

  Album(
      {this.albumId,
      this.title,
      this.ownerId,
      this.shareString,
      this.profileImgUrl});

  Map<String, dynamic> toJson() =>
      {'albumId': albumId, 'title': title, 'shareString': shareString};

  // Album.fromJson(Map<String, dynamic> parsedJSON)
  //     : albumId = parsedJSON['album_id'],
  //       title = parsedJSON['title'],
  //       shareString = parsedJSON['share_string'];

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumId: json['album_id'],
        title: json['title'],
        ownerId: json['ownerId'],
        shareString: json['share_string'],
        profileImgUrl: json['profile_img_url']);
  }
}
