import 'package:flutter/material.dart';
import 'package:point_of_view/app/album_pages/create_album_view.dart';

class MyAlbumsAppBar extends StatelessWidget {
  const MyAlbumsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Albums',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                builder: (builder) => CreateAlbumView());
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
