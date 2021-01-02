import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
    @required this.userSnapshot,
  }) : super(key: key);

  final AsyncSnapshot<dynamic> userSnapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          StreamBuilder(
            stream: locator<UserManager>().updateProfileImg.isExecuting,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: PlatformCircularProgressIndicator(),
                );
              } else {
                return CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: userSnapshot.data.profileImageUrl == 'null'
                        ? AssetImage('assets/images/profile_icon.png')
                        : NetworkImage(userSnapshot.data.profileImageUrl));
              }
            },
          ),
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
                      await locator<UserManager>().updateProfileImg(imgPath);
                      await locator<UserManager>().getUserInfo();
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
