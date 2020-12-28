import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/ui/views/Albums/Create%20Album/CreateAlbumView.dart';


class MyAlbumsViewAppBar extends StatelessWidget {
  const MyAlbumsViewAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Albums',
        style: TextStyle(color: Colors.black),
      ),
      automaticallyImplyLeading: false,
      trailingActions: [
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
            padding: const EdgeInsets.all(8.0),
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