
import 'package:flutter/material.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';

import 'base_view.dart';

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
                Text(
                  'Perspective',
                  style: TextStyle(fontSize: 50, fontFamily: 'Billabong'),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: TextFormField(
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
                        child: TextFormField(
                          controller: model.passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
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
                          }
                        },
                        child: Text('Login',
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
                        Text("OR"),
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
                        child: Text(
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
