import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/selected_album_app_bar.dart';
import 'package:point_of_view/widgets/image_grid_item.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/widgets/selected_album_bottom_nav_bar.dart';

class SelectedAlbumPage extends StatefulWidget {
  const SelectedAlbumPage({this.album});

  final Album album;

  @override
  _SelectedAlbumPageState createState() => _SelectedAlbumPageState();
}

class _SelectedAlbumPageState extends State<SelectedAlbumPage> {
  bool isSelectingImages = false;

  void setSelectingImages() {
    setState(() {
      isSelectingImages = !isSelectingImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SelectedAlbumAppBar(
          album: widget.album,
          isSelecting: isSelectingImages,
          setSelectingImages: setSelectingImages,
        ),
      ),
      body: StreamBuilder<List<Photo>>(
        stream: locator<AlbumService>().getPhotos(widget.album.albumId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orientation = MediaQuery.of(context).orientation;
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 4 : 3),
                itemBuilder: (context, index) {
                  String imageUrl = snapshot.data[index].imageUrl;
                  bool isSelected = snapshot.data[index].isSelected;
                  int imageId = snapshot.data[index].photoId;
                  return ImageGridItem(
                    imageUrl: imageUrl,
                    isSelectingImages: isSelectingImages,
                    isSelected: isSelected,
                    imageId: imageId,
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: Container(),
          );
        },
      ),
      bottomNavigationBar: SelectedAlbumBottomNavBar(
        widget: widget,
        isSelectingImages: isSelectingImages,
        album: widget.album,
      ),
    );
  }
}
