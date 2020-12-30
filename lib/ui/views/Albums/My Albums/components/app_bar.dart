import 'package:flutter/material.dart';
import 'package:point_of_view/ui/views/Albums/Create%20Album/CreateAlbumView.dart';

class MyAlbumsViewAppBar extends StatelessWidget {
  const MyAlbumsViewAppBar({
    Key key,
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
