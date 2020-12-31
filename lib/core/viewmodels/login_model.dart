import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';

import 'package:flutter/material.dart';

class LoginModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  AlbumService albumService = locator<AlbumService>();

  var _usernameController = TextEditingController();
  var _passwordcontroller = TextEditingController();

  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordcontroller;

  Future<bool> login() async {
    setState(ViewState.Busy);

    var success = await _authService.login(_usernameController.text, _passwordcontroller.text);

    setState(ViewState.Idle);
    return success==200;
  }
}
