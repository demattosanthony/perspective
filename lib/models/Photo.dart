import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final int imageId;
  final String imageUrl;
  final int albumId;
  bool isSelected;
  final String userId;

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
        albumId: json['album_id']);
  }

  factory Photo.fromSnap(DocumentSnapshot doc) {
    Map data = doc.data();
    return Photo(
        imageId: data['photoid'],
        albumId: data['albumid'],
        imageUrl: data['photourl'],
        isSelected: false);
  }

  factory Photo.fromQuerySnap(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Photo(
        imageId: data['imageId'],
        userId: data['userId'],
        imageUrl: data['imageUrl'],
        isSelected: false);
  }
}
