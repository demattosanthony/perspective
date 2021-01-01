
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/services/user_service.dart';

import 'ApiService.dart';

abstract class AlbumService {
  Future<List<Album>> getAlbums();
  Future<List<Photo>> getPhotos(int albumId);
  Future<String> createAlbum(String albumTitle);
  Future<int> joinAlbum(String sharedString);
}

class AlbumServiceImplementation implements AlbumService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";
  final ApiService _apiService = locator<ApiService>();

  Future<List<Photo>> _photos;
  Future<List<Photo>> get photos => _photos;

  @override
  Future<List<Album>> getAlbums() async {
    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    var url = host + 'getUserAlbums/$userId';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Album> myAlbums =
          (jsonResponse as List).map((data) => Album.fromJson(data)).toList();
      return myAlbums;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Future<String> createAlbum(String albumTitle) async {
    var url = host + 'createAlbum';

    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    var response = await http
        .post(url, body: {"title": albumTitle, "userId": userId.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create new album');
    }
  }

  @override
  Future<List<Photo>> getPhotos(int albumId) async {
    var url = host + "getImages/$albumId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Photo> photos =
          (jsonResponse as List).map((data) => Photo.fromJson(data)).toList();

      return photos;
    } else {
      throw Exception('Failed to fetch images');
    }
  }

  void deleteAlbum(albumId, isOwner) {
    _apiService.deleteAlbum(albumId, isOwner);
  }

  @override
  Future<int> joinAlbum(String sharedString) async {
    var client = http.Client();
    try {
      int userId = await locator<UserService>().getUserIdFromSharedPrefs();
      var url = host + "getAlbumIdFromShareString/$sharedString";
      var response = await http.get(url);
      var albumId = jsonDecode(response.body)[0]['album_id'];
      Map body = {"albumId": albumId.toString(), "userId": userId.toString()};
      var joinAlbumUrl = host + "joinAlbum";
      var joinAlbumRes = await http.post(joinAlbumUrl, body: body);
      if (joinAlbumRes.statusCode == 200) {
        return 200;
      } else if (joinAlbumRes.statusCode == 450) {
        //User already in album
        return 450;
      } else {
        return 400;
      }
    } catch (e) {
      throw Exception("Error joing album");
    } finally {
      client.close();
    }
  }
}
