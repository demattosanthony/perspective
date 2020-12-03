import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:better_uuid/uuid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AuthService {
  var url = "http://localhost:3000/addUser";

  void createUser(String username, String password, String email) async {
    var query = url + "/" + username + "/" + password + "/" + email;
    var response = await http.post(query);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
