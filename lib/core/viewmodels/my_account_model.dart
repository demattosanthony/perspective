import 'package:flutter/material.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountModel extends BaseModel {
  UserInfoService _userInfoService = locator<UserInfoService>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController;

  void updateUserInfo() async {
    setState(ViewState.Busy);
    print(_usernameController.text);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    _userInfoService.updateUserInfo(
        userId,
        _nameController.text == null ? "" : _nameController.text,
        _usernameController.text == null ? '' : _usernameController.text,
        _emailController.text== null ? '' : _emailController.text);
    setState(ViewState.Idle);
  }
}
