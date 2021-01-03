import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String albumId;
  final String title;
  final String ownerId;
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
        ownerId: json['ownerid'],
        shareString: json['share_string'],
        profileImgUrl: json['profile_img_url']);
  }

  factory Album.fromSnap(DocumentSnapshot doc) {
    Map data = doc.data();

    return Album(
        albumId: data['albumId'],
        title: data['title'],
        ownerId: data['userId'],
        // shareString: data['share_string'],
        // profileImgUrl: data['profile_img_url']
        );
  }
}
