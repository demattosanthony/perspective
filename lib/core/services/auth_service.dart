import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  var host = "http://localhost:3000/";

  var userId;
  bool isSignedIn = false;

  Future<int> createUser(String username, String password, String email) async {
    var url = host + 'addUser';
    var response = await http.post(url,
        body: {'username': username, 'password': password, 'email': email});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) isSignedIn = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);

    return response.statusCode;
  }

  //Logs user in by query database for user_id where is equal to username and password
  //sets is_logged_in value in db to true for user_id
  Future<int> login(String username, String password) async {
    var client = http.Client();
    try {
      var url = host + 'login/$username/$password';
      var url2 = host + 'setLoginState';
      var response = await client.get(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse[0]['user_id']);
        userId = jsonResponse[0]['user_id'];
        prefs.setInt('userId', userId);
        var response2 = await client.put(url2,
            body: {'isLoggedIn': 'true', 'userId': userId.toString()});
        if (response2.statusCode == 200) {
          isSignedIn = true;
          prefs.setBool('isLoggedIn', true);
          return 200;
        } else {
          print('Request failed with status: ${response.statusCode}.');
          return 400;
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return 400;
      }
    } finally {
      client.close();
    }
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
