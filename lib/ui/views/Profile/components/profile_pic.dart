import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/ui/views/Profile/profile_view.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic(
      {Key key, this.snapshot, this.updateProfileImg, this.selectImg})
      : super(key: key);

  final AsyncSnapshot<dynamic> snapshot;
  final UpdateProfileImg updateProfileImg;
  final SelectImg selectImg;
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
              backgroundImage: snapshot.data[0].profileImageUrl == 'null'
                  ? AssetImage('assets/profile_icon.png')
                  : NetworkImage(snapshot.data[0].profileImageUrl)),
          Positioned(
              right: -12,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      String imgPath = await selectImg();
                      updateProfileImg(imgPath);
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

typedef UpdateProfileImg = Function(String image);
typedef SelectImg = Function();
