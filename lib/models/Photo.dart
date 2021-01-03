import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final int photoId;
  final String imageUrl;
  final int albumId;
  bool isSelected;

  Photo({this.photoId, this.imageUrl, this.albumId, this.isSelected = false});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        photoId: json['photo_id'],
        imageUrl: json['image_url'],
        albumId: json['album_id']);
  }

  factory Photo.fromSnap(DocumentSnapshot doc) {
    Map data = doc.data();
    return Photo(
      imageUrl: data['imageUrl'],
    );
  }
}
