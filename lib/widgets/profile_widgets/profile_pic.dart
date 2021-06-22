import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:optimized_cached_image/widgets.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/User.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    @required this.user,
  }) : super(key: key);

  final UserAccount? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          StreamBuilder(
            stream: locator<UserManager>().updateProfileImg.isExecuting,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CupertinoActivityIndicator(),
                );
              } else {
                return user!.profileImageUrl == ''
                    ? Image.asset('assets/images/profile_icon.png')
                    : CircleAvatar(
                        backgroundImage: NetworkImage(user!.profileImageUrl));
                // : OptimizedCacheImage(
                //     imageUrl: user!.profileImageUrl,
                //     imageBuilder: (context, imageProvider) => Container(
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           image: DecorationImage(image: imageProvider)),
                //     ),
                //     placeholder: (context, url) =>
                //         Center(child: PlatformCircularProgressIndicator()),
                //   );

                // CircleAvatar(
                //     backgroundColor: Colors.white,
                //     backgroundImage: user.profileImageUrl == ''
                //         ? AssetImage('assets/images/profile_icon.png')
                //         : NetworkImage(user.profileImageUrl));
              }
            },
          ),
          // Positioned(
          //     right: -12,
          //     bottom: 0,
          //     child: SizedBox(
          //       height: 46,
          //       width: 46,
          //       child: FlatButton(
          //           padding: EdgeInsets.zero,
          //           onPressed: () async {
          //             String imgPath =
          //                 await locator<UserManager>().selectImage();

          //             File croppedImage = await ImageCropper.cropImage(
          //                 sourcePath: imgPath,
          //                 aspectRatioPresets: Platform.isAndroid
          //                     ? [
          //                         CropAspectRatioPreset.square,
          //                         CropAspectRatioPreset.ratio3x2,
          //                         CropAspectRatioPreset.original,
          //                         CropAspectRatioPreset.ratio4x3,
          //                         CropAspectRatioPreset.ratio16x9
          //                       ]
          //                     : [
          //                         CropAspectRatioPreset.original,
          //                         CropAspectRatioPreset.square,
          //                         CropAspectRatioPreset.ratio3x2,
          //                         CropAspectRatioPreset.ratio4x3,
          //                         CropAspectRatioPreset.ratio5x3,
          //                         CropAspectRatioPreset.ratio5x4,
          //                         CropAspectRatioPreset.ratio7x5,
          //                         CropAspectRatioPreset.ratio16x9
          //                       ],
          //                 cropStyle: CropStyle.circle,
          //                 androidUiSettings: AndroidUiSettings(
          //                     toolbarTitle: 'Cropper',
          //                     toolbarColor: Colors.deepOrange,
          //                     toolbarWidgetColor: Colors.white,
          //                     initAspectRatio: CropAspectRatioPreset.original,
          //                     lockAspectRatio: false),
          //                 iosUiSettings: IOSUiSettings(
          //                   title: 'Cropper',
          //                 ));

          //             locator<UserManager>().updateProfileImg(croppedImage);
          //           },
          //           color: Color(0xFFF5F6F9),
          //           child: Icon(Icons.person),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(50))),
          //     ))
        ],
      ),
    );
  }
}
