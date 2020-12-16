import 'auth_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:point_of_view/core/models/Album.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ApiService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";

  Future<int> createAlbum(albumTitle) async {
    var url = host + 'createAlbum';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    Map<String, String> headers = {"Content-type": "application/json"};

    var response = await http
        .post(url, body: {"title": albumTitle, "userId": userId.toString()});
    print('Response status: ${response.statusCode}');

    return response.statusCode;
  }

  Future<List<Album>> getAlbums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var url = host + 'getUserAlbums/$userId';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List<Album> myAlbums =
          (jsonResponse as List).map((data) => Album.fromJson(data)).toList();
      return myAlbums;
      print(myAlbums[0].title);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<String> uploadImage(File image, String title) async {
    try {
      var client = http.Client();
      try {
        var url = host + 'generatePresignedUrl';
        String fileExtension = path.extension(image.path);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = prefs.getInt('userId');
        Map body = {
          "filetype": fileExtension,
          "userId": userId.toString(),
          "albumTitle": title
        };

        var response = await http.post(url, body: body);
        var result = convert.jsonDecode(response.body);
        print(result);
        var uploadUrl = result['uploadUrl'];
        var response2 =
            await http.put(uploadUrl, body: image.readAsBytesSync());
        print(response2.body);
        if (response2.statusCode == 200) {
          print("Uploaded");
          return result['downloadUrl'];
        } else {
          print('error uploading');
          return null;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      return null;      
    }
  }
}
