import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import '../widgets/profile_icon.dart';
import 'base_view.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: PlatformAppBar(
                  backgroundColor: Colors.white,
                  title: Text('Profile'),
                  trailingActions: [
                    GestureDetector(
                        onTap: model.signOut, child: Icon(Icons.settings))
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: model.user == null
                          ? Container()
                          : Text(
                              '${model.user['name']}'.capitalize(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: model.user == null
                          ? Container()
                          : Text(
                              '@${model.user['username']}',
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                    ),
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
                            children: [
                              Column(
                                children: [
                                  model.user == null
                                      ? Container()
                                      : Text('${model.user['followingCount']}'),
                                  Text(
                                    'Following',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  model.user == null
                                      ? Container()
                                      : Text('${model.user['followersCount']}'),
                                  Text(
                                    'Followers',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
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
