import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/auth_service.dart';
import 'package:point_of_view/widgets/profile_widgets/profile_list_tile.dart';
import 'package:point_of_view/widgets/profile_widgets/profile_pic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    locator<UserManager>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<UserAccount>(
          stream: locator<UserManager>().getUserInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 25)),
                  ProfilePic(user: snapshot.data),
                  ProfileListTile(
                    icon: Icons.person,
                    title: 'My Account',
                    press: () {
                      Navigator.of(context)
                          .pushNamed('myAccountView', arguments: snapshot.data);
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.photo_album_rounded,
                    title: 'Created Albums',
                    press: () {
                      Navigator.of(context).pushNamed('createdAlbumsView');
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.add_a_photo,
                    title: 'Joined Albums',
                    press: () {
                      Navigator.of(context).pushNamed('joinedAlbumsView');
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    press: () {
                      Navigator.of(context).pushNamed('settingsPage');
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    press: () {
                      locator<AuthService>().signOut();
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  child: PlatformCircularProgressIndicator());
            }

            return Container();
          },
        ),
      ),
    );
  }
}
