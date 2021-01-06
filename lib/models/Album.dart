import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String albumId;
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
        albumId: json['albumId'],
        title: json['title'],
        ownerId: json['userId'],
        attendeeIds: json['attendeeIds']);
  }

  factory Album.fromSnap(DocumentSnapshot doc) {
    Map data = doc.data();

    return Album(
      albumId: data['albumId'],
      title: data['title'],
      ownerId: data['userId'],
      attendeeIds: data['attendeeIds'],
      profileImgUrl: data['profileImgUrl']
    );
  }
}
