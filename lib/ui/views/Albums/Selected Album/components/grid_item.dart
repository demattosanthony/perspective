import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// ignore: must_be_immutable
class GridItem extends StatelessWidget {
  GridItem(
      {Key key,
      @required this.imageUrl,
      this.setSelectedImage,
      this.isSelectingImages,
      this.isSelected,
      this.imageId})
      : super(key: key);

  final imageUrl;
  final setSelectedImage;
  final isSelectingImages;
  final isSelected;
  final imageId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelectingImages) {
          setSelectedImage(imageId);
        } else {
          Navigator.of(context).pushNamed('imageView', arguments: imageUrl);
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
                decoration: !isSelected
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover))
                    : BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(.35),
                                BlendMode.color))),
              ),
              fadeInDuration: Duration(microseconds: 0),
              placeholder: (context, url) =>
                  PlatformCircularProgressIndicator(),
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          isSelected
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
