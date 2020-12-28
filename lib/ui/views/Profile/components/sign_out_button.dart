import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/ui/views/Authentication/login_view.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key key,
    this.signOut
  }) : super(key: key);

  final SignOutCallBack signOut;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          signOut();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LoginView(), type: PageTransitionType.fade));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Sign Out", style: TextStyle(color: Colors.black)),
          ),
        ));
  }
}

typedef SignOutCallBack = Function();