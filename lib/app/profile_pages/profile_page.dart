import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/auth_service.dart';
import 'package:point_of_view/widgets/profile_widgets/AlbumPreview.dart';
import 'package:point_of_view/widgets/profile_widgets/profile_list_tile.dart';
import 'package:point_of_view/widgets/profile_widgets/profile_pic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
      backgroundColor: Colors.blueAccent,
      body: StreamBuilder<UserAccount>(
        stream: locator<UserManager>().getUserInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.blueAccent,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * .25,
                    collapsedHeight: MediaQuery.of(context).size.height * .10,
                    forceElevated: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 25, right: 25),
                                      child: ProfilePic(user: snapshot.data!)),
                                  Container(
                                    margin: EdgeInsets.only(right: 25),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            '${snapshot.data!.name}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '@${snapshot.data!.username}',
                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 25, bottom: 25),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text(
                                          'Edit Profile'.toUpperCase(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      titlePadding: EdgeInsets.all(0),
                    ),
                  ),
                ];
              },
              // slivers: [
              // SliverToBoxAdapter(
              //   child: Container(
              //     color: Colors.blueAccent,
              //     child: Container(
              //       child: Text(''),
              //       height: 50,
              //       decoration: BoxDecoration(
              //           color: Colors.grey[50],
              //           borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(35),
              //               topRight: Radius.circular(35))),
              //     ),
              //   ),
              // ),
              //   SliverToBoxAdapter(
              //     child: Container(
              //       color: Colors.grey[50],
              //       padding: EdgeInsets.only(left: 15),
              //       child: Text(
              //         'My Albums',
              //         style:
              //             TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),

              //   SliverToBoxAdapter(
              //     child: AlbumPreview(),
              //   ),

              // SliverGrid(
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2),
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext context, int index) {
              //       return Container(
              //         alignment: Alignment.center,
              //         color: Colors.grey[50],
              //         child: Card(
              //             child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(),
              //         )),
              //       );
              //     },
              //   ),
              // )
              // ],
              body: Column(
                children: [
                  SliverPersistentHeader(
                      delegate: SliverPersistentHeaderDelegate()),
                  Container(
                    color: Colors.blueAccent,
                    child: Container(
                      child: Text(''),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35))),
                    ),
                  ),
                  AlbumPreview(),
                ],
              ),
            );

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        child: ProfilePic(user: snapshot.data!)),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            '${snapshot.data!.name}',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        ),
                        Container(
                          child: Text(
                            '@${snapshot.data!.username}',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
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
                            child: LoginView(), type: PageTransitionType.fade));
                  },
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator());
          }

          return Container();
        },
      ),
    );
  }
}
