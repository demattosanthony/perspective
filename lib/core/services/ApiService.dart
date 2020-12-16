import 'auth_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:point_of_view/core/models/Album.dart';

class ApiService {
  final AuthService _authService = locator<AuthService>();
  var host = "https://hidden-woodland-36838.herokuapp.com/";

  Future<int> createAlbum(albumTitle) async {
    var url = host + 'createAlbum';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    Map<String, String> headers = {"Content-type": "application/json"};

    var response = await http.post(url,
        headers: headers,
        body: '{"title": "$albumTitle", "userId": "$userId"}');
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
}
