import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/ui/views/Profile/components/sign_out_button.dart';
import 'components/profile_icon.dart';
import '../base_view.dart';

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
                  title: Text(
                    'Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailingActions: [SignOutButton(signOut: model.signOut)],
                ),
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
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * .30,
                              child: ProfileIcon(
                                  snapshot.data[0].profileImageUrl)),
                          Container(
                              child: Text(
                            '@${snapshot.data[0].username}',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [],
                                ),
                              ),
                            ),
                          ),
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
