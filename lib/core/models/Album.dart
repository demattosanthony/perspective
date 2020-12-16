class Album {
  final int albumId;
  final String title;

  Album({this.albumId, this.title});

  Map<String, dynamic> toJson() => {'albumId': albumId, 'title': title};

  Album.fromJson(Map<String, dynamic> parsedJSON)
      : albumId = parsedJSON['album_id'],
        title = parsedJSON['title'];
}
