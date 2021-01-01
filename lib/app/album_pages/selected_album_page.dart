import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/widgets/selected_album_app_bar.dart';
import 'package:point_of_view/widgets/image_grid_item.dart';
import 'package:point_of_view/models/Photo.dart';

class SelectedAlbumPage extends StatefulWidget {
  const SelectedAlbumPage({this.album});

  final Album album;

  @override
  _SelectedAlbumPageState createState() => _SelectedAlbumPageState();
}

class _SelectedAlbumPageState extends State<SelectedAlbumPage> {
  bool isSelectingImages = false;

  @override
  void initState() {
    locator<AlbumManager>().getAlbumImages(widget.album.albumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SelectedAlbumAppBar(
          album: widget.album,
          setSelectingImages: false,
          isSelecting: isSelectingImages,
        ),
      ),
      body: StreamBuilder<List<Photo>>(
        stream: locator<AlbumManager>().getAlbumImages,
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
                  var imageUrl = snapshot.data[index].imageUrl;
                  var isSelected = snapshot.data[index].isSelected;
                  var imageId = snapshot.data[index].photoId;
                  return ImageGridItem(
                    imageUrl: imageUrl,
                    setSelectedImage: false,
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
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        fixedColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueAccent,
        currentIndex: 0,
        // onTap: (index) async {
        //   if (index == 2) {
        //     var success = await model.save();
        //     if (success) {
        //       showPlatformDialog(
        //           context: context,
        //           builder: (_) =>
        //               ShowAlert('Download Success!!', 'Complete.'));
        //     }
        //   }
        // },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo_rounded), label: 'Upload Images'),
          BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: isSelectingImages
                  ? 'Download Images'
                  : 'Download Album')
        ],
      ),
    );
  }
}
