import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/services/auth_service.dart';
import 'package:point_of_view/locator.dart';
import 'dart:io';

import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:point_of_view/widgets/CustomTextField.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';

// ignore: must_be_immutable
class RegisterView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _usernamecontroller = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: Text('Register', style: TextStyle(color: Colors.black)),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 65),
                child: Text(
                  'Perspective',
                  style: TextStyle(fontSize: 80, fontFamily: 'Billabong'),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: StreamBuilder(
                                    stream: locator<AuthManager>().getImage,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                            radius: 60,
                                            backgroundImage: FileImage(
                                              File(snapshot.data),
                                            ));
                                      } else {
                                        return CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.white,
                                            backgroundImage: AssetImage(
                                                'assets/images/profile_icon.png'));
                                      }
                                    }),
                              ),
                              FractionalTranslation(
                                translation: Offset(0, 0.5),
                                child: Align(
                                  child: GestureDetector(
                                    onTap: () =>
                                        locator<AuthManager>().getImage(),
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Icon(Icons.edit,
                                          size: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    CustomTextField('Name', _nameController, false),
                    CustomTextField('Username', _usernamecontroller, false),
                    CustomTextField('Email', _emailController, false),
                    CustomTextField('Password', _passwordcontroller, true),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          var responseCode = await locator<AuthService>()
                              .register(
                                  _usernamecontroller.text,
                                  _passwordcontroller.text,
                                  _emailController.text,
                                  _nameController.text,
                                  "");

                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User user) {
                            if (user != null) {
                              Navigator.of(context).pushReplacement(PageTransition(
                                  child: BottomNavBar(),
                                  type: PageTransitionType.fade));
                            }
                          });

                          if (responseCode == 'email-already-in-use') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => ShowAlert(
                                    'Email Already in use.', 'Try again'));
                          } else if (responseCode == 'weak-password') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => ShowAlert(
                                    'Password is too weak.', 'Try again'));
                          } else if (responseCode == 'username-taken') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) => ShowAlert(
                                    'Username is taken.', 'Try again'));
                          } else if (responseCode == 'invalid-email') {
                            showPlatformDialog(
                                context: context,
                                builder: (_) =>
                                    ShowAlert('Invalid Email.', 'Try again'));
                          }
                        },
                        child: Text('Register',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
