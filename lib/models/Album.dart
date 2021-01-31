
class Album {
  final int albumId;
  final String title;
  final String ownerId;
  final String shareString;
  final String profileImgUrl;
  final List attendeeIds;

  Album(
      {this.albumId,
      this.title,
      this.ownerId,
      this.shareString,
      this.profileImgUrl,
      this.attendeeIds});

  Map<String, dynamic> toJson() =>
      {'albumId': albumId, 'title': title, 'shareString': shareString};

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumId: json['album_id'],
        title: json['title'],
        ownerId: json['ownerid'],
        profileImgUrl: json['profile_img_url'],
        );
  }

 
}
