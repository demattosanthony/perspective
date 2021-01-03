
import 'package:http/http.dart' as http;
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'dart:io';

class ApiService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";




  Future<String> uploadImage(File image, String title, int albumId) async {
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
        var result = jsonDecode(response.body);
        var uploadUrl = result['uploadUrl'];
        var response2 =
            await http.put(uploadUrl, body: image.readAsBytesSync());
        if (title == "profileImage") return result['downloadUrl'];
        var photoUploadUrl = host + "uploadImageUrl";
        Map photoBody = {
          "photoUrl": result['downloadUrl'],
          "albumId": albumId.toString()
        };
        var photoUploadUrlResponse =
            await http.post(photoUploadUrl, body: photoBody);

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

  // Future<List<User>> getUserInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userId = prefs.getInt('userId');
  //   var url = host + 'getUserInfo/$userId';
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     List<User> userInfo =
  //         (jsonResponse as List).map((data) => User.fromJson(data)).toList();
  //     return userInfo;
  //   } else {
  //     print("Request failed");
  //     return null;
  //   }
  // }



}