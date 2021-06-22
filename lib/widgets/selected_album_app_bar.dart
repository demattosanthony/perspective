import 'package:flutter/material.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';

class SelectedAlbumAppBar extends StatefulWidget {
  SelectedAlbumAppBar(
      {Key? key,
      @required this.album,
      this.isSelecting,
      this.setSelectingImages,
      this.photos})
      : super(key: key);

  final Album? album;
  final isSelecting;
  final SetSelctingImagesCallBack? setSelectingImages;
  final List<Photo>? photos;

  @override
  _SelectedAlbumAppBarState createState() => _SelectedAlbumAppBarState();
}

class _SelectedAlbumAppBarState extends State<SelectedAlbumAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.album!.title.toUpperCase(),
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('slideshow', arguments: widget.album);
                },
                child: Icon(
                  Icons.slideshow,
                  size: 30,
                ))),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            child: GestureDetector(
              onTap: () {
                widget.setSelectingImages!();
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
    );
  }
}

typedef SetSelctingImagesCallBack = Function();
