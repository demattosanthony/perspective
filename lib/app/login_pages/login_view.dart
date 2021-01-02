import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/services/auth_service.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:point_of_view/widgets/CustomTextField.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:page_transition/page_transition.dart';

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
                          var response = await locator<AuthService>().login(
                              _emailController.text, _passwordcontroller.text);

                          if (response == 'user-not-found') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => ShowAlert('User not found.',
                                    'No user with that email.'));
                          } else if (response == 'wrong-password') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) =>
                                    ShowAlert('Wrong password!', 'Try again.'));
                          } else if (response == 'invalid-email') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) =>
                                    ShowAlert('Invalid Email.', 'Try again.'));
                          } else if (response == 'success') {
                            Navigator.of(context).pushReplacement(PageTransition(
                                child: BottomNavBar(),
                                type: PageTransitionType.fade));
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
