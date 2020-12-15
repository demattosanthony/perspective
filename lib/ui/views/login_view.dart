import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';

import 'base_view.dart';
import 'dart:io' show Platform;

class LoginView extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    'Perspective',
                    style: TextStyle(fontSize: 80, fontFamily: 'Billabong'),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Platform.isIOS
                            ? CupertinoTextField(
                                controller: model.emailController,
                                placeholder: "Email",
                              )
                            : TextFormField(
                                controller: model.emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                                validator: (input) => !input.contains('@')
                                    ? 'Please enter valid email'
                                    : null,
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Platform.isIOS
                            ? CupertinoTextField(
                                controller: model.passwordController,
                                placeholder: "Password",
                              )
                            : TextFormField(
                                controller: model.passwordController,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                validator: (input) => input.length < 6
                                    ? 'Must be at least 6 characters'
                                    : null,
                                obscureText: true,
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () async {
                          var loginSuccess = await model.login(
                              model.emailController.text,
                              model.passwordController.text);
                          if (loginSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          } else {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => ShowAlert('Invalid Username or Password!', 'Try again.'));
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
    );
  }
}
