import 'package:flutter/material.dart';
import 'package:point_of_view/core/managers/user_manager.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/locator.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
    @required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: snapshot.data.profileImageUrl == 'null'
                  ? AssetImage('assets/profile_icon.png')
                  : NetworkImage(snapshot.data.profileImageUrl)),
          Positioned(
              right: -12,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      String imgPath =
                          await locator<UserManager>().selectImage();
                      // updateProfileImg(imgPath);
                      locator<UserService>().changeProfileImage(imgPath);
                    },
                    color: Color(0xFFF5F6F9),
                    child: Icon(Icons.person),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              ))
        ],
      ),
    );
  }
}
