class Album {
  final int albumId;
  final String title;
  final String shareString;

  Album({this.albumId, this.title, this.shareString});

  Map<String, dynamic> toJson() =>
      {'albumId': albumId, 'title': title, 'shareString': shareString};

  // Album.fromJson(Map<String, dynamic> parsedJSON)
  //     : albumId = parsedJSON['album_id'],
  //       title = parsedJSON['title'],
  //       shareString = parsedJSON['share_string'];

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumId: json['abum_id'],
        title: json['title'],
        shareString: json['share_string']);
  }
}
