import 'package:flutter/material.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';

class ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
      builder: (context, model, child) => Container(
        width: MediaQuery.of(context).size.width / 2,
        child: ClipRRect(
          child: model.profileImage == null
              ? Container()
              : CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    model.profileImage,
                  ),
                ),
        ),
      ),
    );
  }
}
