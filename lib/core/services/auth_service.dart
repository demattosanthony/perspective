import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";

  var userId;
  bool isSignedIn = false;

  Future<int> createUser(String username, String password, String email, String name) async {
    var url = host + 'addUser';
    var response = await http.post(url,
        body: {'username': username, 'password': password, 'email': email, 'name': name});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) isSignedIn = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);

    return response.statusCode;
  }

  Future<int> login(String username, String password) async {
    var client = http.Client();
    try {
      var url = host + 'login/$username/$password';
      //var url2 = host + 'setLoginState';
      var response = await client.get(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse[0]['user_id']);
        userId = jsonResponse[0]['user_id'];
        prefs.setInt('userId', userId);
          prefs.setBool('isLoggedIn', true);
        return 200;
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
