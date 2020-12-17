import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import '../widgets/profile_icon.dart';
import 'base_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: PlatformAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Text('Profile'),
                  trailingActions: [
                    GestureDetector(
                        onTap: () {
                          model.signOut();
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: BottomNavBar(),
                                  type: PageTransitionType.fade));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PlatformText("Sign Out"),
                        ))
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * .30,
                        child: ProfileIcon()),
                    Container(
                        child: Text(
                      '@${model.username}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 15,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [],
                          ),
                        ),
                      ),
                    ),
                  ],
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
