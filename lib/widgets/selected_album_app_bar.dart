import 'package:flutter/material.dart';
import 'package:point_of_view/models/Album.dart';

class SelectedAlbumAppBar extends StatefulWidget {
  SelectedAlbumAppBar(
      {Key key,
      @required this.album,
      this.isSelecting,
      this.setSelectingImages})
      : super(key: key);

  final Album album;
  final  isSelecting;
  final SetSelctingImagesCallBack setSelectingImages;

  @override
  _SelectedAlbumAppBarState createState() => _SelectedAlbumAppBarState();
}

class _SelectedAlbumAppBarState extends State<SelectedAlbumAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.album.title.toUpperCase(),
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,

      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            child: GestureDetector(
              onTap: () {
                widget.setSelectingImages();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    color: Colors.black.withOpacity(.55)),
                child: Text(
                  widget.isSelecting ? 'Cancel' : 'Select',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ],
      // trailingActions: [
      //   PlatformButton(
      //     child: Text('Share'),
      //     onPressed: () {
      //       showPlatformDialog(
      //           context: context,
      //           builder: (_) =>
      //               ShowAlert("Share string:", album.shareString));
      //     },
      //     padding: EdgeInsets.all(0),
      //   ),

      // ],
    );
  }
}

typedef SetSelctingImagesCallBack = Function();
