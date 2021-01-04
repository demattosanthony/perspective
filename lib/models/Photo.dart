import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String imageId;
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
        imageId: json['imageId'],
        imageUrl: json['image_url'],
        albumId: json['album_id']);
  }

  factory Photo.fromSnap(DocumentSnapshot doc) {
    Map data = doc.data();
    return Photo(
        imageId: data['imageId'],
        userId: data['userId'],
        imageUrl: data['imageUrl'],
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
