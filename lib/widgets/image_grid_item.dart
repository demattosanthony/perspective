
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
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
            widget.photos,
            widget.index
          ]);
        }
      },
      onLongPress: () {
        // print(isSelected);
      },
      child: GridTile(
          child: Stack(
        children: [
          OptimizedCacheImage(
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
            imageUrl: widget.imageUrl,
            placeholder: (context, url) => PlatformCircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Visibility(
            visible: widget.isSelected,
            child: Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.check,
                  color: Colors.blueAccent,
                  size: 40,
                )),
          )
        ],
      )),
    );
  }
}
