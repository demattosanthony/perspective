import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/services/auth_service.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:point_of_view/widgets/CustomTextField.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      CustomTextField('Email', _emailController, false),
                      CustomTextField('Password', _passwordcontroller, true),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () async {
                          await locator<AuthService>().login(
                              _emailController.text, _passwordcontroller.text, context);

                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((user) {
                            if (user != null) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: BottomNavBar(),
                                      type: PageTransitionType.fade));
                            }
                          });

                          // if (response == 200) {
                          //   SharedPreferences prefs =
                          //       await SharedPreferences.getInstance();
                          //   prefs.setBool('isLoggedIn', true);
                          //   Navigator.pushReplacement(
                          //       context,
                          //       PageTransition(
                          //           child: BottomNavBar(),
                          //           type: PageTransitionType.fade));
                          // } else {
                          //   showPlatformDialog(
                          //       context: context,
                          //       builder: (_) => ShowAlert(
                          //           'Invalid Username or Password!',
                          //           'Try again.'));
                          // }
                        },
                        child: PlatformText('Login',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.blueAccent,
                      ),
                      LoginDivider(),
                      FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, 'register'),
                        child: PlatformText(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blueAccent,
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

class LoginDivider extends StatelessWidget {
  const LoginDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
      PlatformText("OR"),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }
}
