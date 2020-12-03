import 'package:flutter/material.dart';
import 'dart:io';
import 'package:point_of_view/core/viewmodels/register_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';

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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        controller: model.nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (input) => null,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        controller: model.usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (input) => null,
                      ),
                    ),
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
                        var success =
                            await model.createUserWithEmailAndPassword(
                                model.emailController.text,
                                model.passwordController.text,
                                model.usernameController.text,
                                model.nameController.text);

                        if (success==200) {
                          Navigator.pushNamed(context, '/');
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
