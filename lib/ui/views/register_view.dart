import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:io';
import 'package:point_of_view/core/viewmodels/register_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/widgets/CustomTextField.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';

class RegisterView extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Perspective',
                style: TextStyle(fontSize: 80, fontFamily: 'Billabong'),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
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
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: model.image == null
                                    ? AssetImage('assets/profile_icon.png')
                                    : FileImage(File(model.image)),
                              ),
                            ),
                            FractionalTranslation(
                              translation: Offset(0, 0.5),
                              child: Align(
                                child: RawMaterialButton(
                                  onPressed: model.getImage,
                                  elevation: 2.0,
                                  fillColor: Colors.blue,
                                  child: Icon(Icons.edit,
                                      size: 15.0, color: Colors.white),
                                  shape: CircleBorder(),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  CustomTextField('Name', model.nameController),
        
                  CustomTextField('Username', model.usernameController),
                  CustomTextField('Email', model.emailController),
                  CustomTextField('Password', model.passwordController),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () async {
                      var responseCode =
                          await model.createUserWithEmailAndPassword();

                      if (responseCode == 200) {
                        Navigator.pushNamed(context, '/');
                      } else if (responseCode == 400) {
                        showPlatformDialog(
                            context: context,
                            builder: (_) =>
                                ShowAlert('Invalid Email', 'Try again'));
                      } else if (responseCode == 475) {
                        showPlatformDialog(
                            context: context,
                            builder: (_) =>
                                ShowAlert('Email already exists', 'Try again'));
                      } else if (responseCode == 450) {
                        showPlatformDialog(
                            context: context,
                            builder: (_) =>
                                ShowAlert('Username is taken', 'Try again'));
                      }
                    },
                    child:
                        Text('Register', style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
