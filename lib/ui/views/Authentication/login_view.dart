import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/services/auth_service.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';
import 'package:page_transition/page_transition.dart';


class LoginView extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final  _passwordcontroller = TextEditingController();

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
                        CustomTextField('Username', _usernameController, false),
                        CustomTextField('Password', _passwordcontroller, true),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () async {
                            var response = await locator<AuthService>()
                                .login(_usernameController.text,
                                    _passwordcontroller.text);
                            if (response == 200) {
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
  
    );
  }
}
