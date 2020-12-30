import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/ui/views/Authentication/login_view.dart';
import 'package:point_of_view/ui/views/Profile/components/profile_list_tile.dart';
import 'package:point_of_view/ui/views/Profile/components/profile_pic.dart';
import 'package:point_of_view/ui/views/Profile/components/sign_out_button.dart';
import '../base_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: FutureBuilder(
                  future: model.userInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 25)),
                          ProfilePic(
                            snapshot: snapshot,
                            updateProfileImg: model.updateProfileImage,
                            selectImg: model.selectImage,
                          ),
                          ProfileListTile(
                            icon: Icons.person,
                            title: 'My Account',
                          ),
                          ProfileListTile(
                            icon: Icons.photo_album_rounded,
                            title: 'Created Albums',
                            press: () {
                              Navigator.of(context)
                                  .pushNamed('createdAlbumsView');
                            },
                          ),
                          ProfileListTile(
                            icon: Icons.add_a_photo,
                            title: 'Joined Albums',
                            press: () {
                              Navigator.of(context)
                                  .pushNamed('joinedAlbumsView');
                            },
                          ),
                          ProfileListTile(
                            icon: Icons.settings,
                            title: 'Settings',
                          ),
                          ProfileListTile(
                            icon: Icons.logout,
                            title: 'Log Out',
                            press: () {
                              model.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: LoginView(),
                                      type: PageTransitionType.fade));
                            },
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container();
                  },
                ),
              ),
            ));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
