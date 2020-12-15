import 'package:flutter/material.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../services/auth_service.dart';
import '../../locator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();

  var _emailcontorller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _usernamecontroller = TextEditingController();
  var _nameController = TextEditingController();

  TextEditingController get emailController => _emailcontorller;
  TextEditingController get passwordController => _passwordcontroller;
  TextEditingController get usernameController => _usernamecontroller;
  TextEditingController get nameController => _nameController;

  String _image;
  String get image => _image;

  final picker = ImagePicker();

  Future<int> createUserWithEmailAndPassword() async {
    setState(ViewState.Busy);

    var success = _authService.createUser(_usernamecontroller.text,
        _passwordcontroller.text, _emailcontorller.text, _nameController.text);
    setState(ViewState.Idle);
    return success;
  }

  Future getImage() async {
    setState(ViewState.Busy);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile.path;
    } else {
      print('No image selected.');
    }
    setState(ViewState.Idle);
  }
}
