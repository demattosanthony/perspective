import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String profileImageUrl;

  ProfileIcon(this.profileImageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: ClipRRect(
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(
            profileImageUrl,
          ),
        ),
      ),
    );
  }
}
