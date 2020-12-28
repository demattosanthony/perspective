import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import 'package:point_of_view/core/viewmodels/register_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: PlatformAppBar(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
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
                                    backgroundImage: model.image == ""
                                        ? AssetImage('assets/profile_icon.png')
                                        : FileImage(File(model.image)),
                                  ),
                                ),
                                FractionalTranslation(
                                  translation: Offset(0, 0.5),
                                  child: Align(
                                    child: GestureDetector(
                                      onTap: model.getImage,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
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
                      CustomTextField('Name', model.nameController, false),
                      model.isLoading
                          ? CircularProgressIndicator()
                          : Container(),
                      CustomTextField(
                          'Username', model.usernameController, false),
                      CustomTextField('Email', model.emailController, false),
                      CustomTextField(
                          'Password', model.passwordController, true),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: FlatButton(
                          onPressed: () async {
                            var responseCode =
                                await model.createUserWithEmailAndPassword();

                            if (responseCode == 200) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: BottomNavBar(),
                                      type: PageTransitionType.fade));
                            } else if (responseCode == 400) {
                              showPlatformDialog(
                                  context: context,
                                  builder: (_) =>
                                      ShowAlert('Invalid Email', 'Try again'));
                            } else if (responseCode == 475) {
                              showPlatformDialog(
                                  context: context,
                                  builder: (_) => ShowAlert(
                                      'Email already exists', 'Try again'));
                            } else if (responseCode == 450) {
                              showPlatformDialog(
                                  context: context,
                                  builder: (_) => ShowAlert(
                                      'Username is taken', 'Try again'));
                            }
                          },
                          child: Text('Register',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.blue,
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
      ),
    );
  }
}
