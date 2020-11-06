import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';

import 'package:flutter/material.dart';

class LoginModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();

  var _emailcontorller = TextEditingController();
  var _passwordcontroller = TextEditingController();

  TextEditingController get emailController => _emailcontorller;
  TextEditingController get passwordController => _passwordcontroller;

  Future<bool> login(String email, String password) async {
    setState(ViewState.Busy);

    var success =
        await _authService.signInWithEmailAndPassword(email, password);

    setState(ViewState.Idle);
    return success;
  }
}
