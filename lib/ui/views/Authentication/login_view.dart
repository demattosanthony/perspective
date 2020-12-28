import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';
import 'package:page_transition/page_transition.dart';


import '../base_view.dart';


class LoginView extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Perspective',
                    style: TextStyle(fontSize: 80, fontFamily: 'Billabong'),
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField('Username', model.usernameController, false),
                        CustomTextField('Password', model.passwordController, true),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () async {
                            var loginSuccess = await model.login();
                            if (loginSuccess) {
                              Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: BottomNavBar(),
                                  type: PageTransitionType.fade));
                            } else {
                              showPlatformDialog(
                                  context: context,
                                  builder: (_) => ShowAlert(
                                      'Invalid Username or Password!',
                                      'Try again.'));
                            }
                          },
                          child: PlatformText('Login',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.blue,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          PlatformText("OR"),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                        ]),
                        FlatButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, 'register'),
                          child: PlatformText(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
