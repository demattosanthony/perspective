import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Photo.dart';

// ignore: must_be_immutable
class ImageGridItem extends StatefulWidget {
  ImageGridItem(
      {Key key,
      @required this.imageUrl,
      this.isSelectingImages,
      this.isSelected,
      this.photos,
      this.index,
      @required this.albumId})
      : super(key: key);

  final String imageUrl;
  bool isSelectingImages;
  bool isSelected;
  List<Photo> photos;
  var index;
  final int albumId;

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isSelectingImages) {
          setState(() {
            if (widget.isSelected) {
              locator<AlbumManager>()
                  .deleteFromSelectedPhotos(widget.photos[widget.index]);
              widget.isSelected = false;
            } else {
              locator<AlbumManager>()
                  .addToSelectedPhotos(widget.photos[widget.index]);
              widget.isSelected = true;
            }
          });
        } else {
          Navigator.of(context).pushNamed('imageView', arguments: [
            widget.photos[widget.index],
            widget.albumId,
            widget.photos
          ]);
        }
      },
      onLongPress: () {
        // print(isSelected);
      },
      child: GridTile(
          child: Stack(
        children: [
          Container(
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                decoration: !widget.isSelected
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover))
                    : BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.transparent.withOpacity(.65),
                                BlendMode.color))),
              ),
              fadeInDuration: Duration(microseconds: 0),
              placeholder: (context, url) =>
                  Center(child: PlatformCircularProgressIndicator()),
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          widget.isSelected
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.check,
                    color: Colors.blueAccent,
                    size: 40,
                  ))
              : Container(),
        ],
      )),
    );
  }
}
