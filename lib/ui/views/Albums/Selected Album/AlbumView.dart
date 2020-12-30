import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/viewmodels/AlbumModel.dart';
import 'package:point_of_view/ui/views/Albums/Selected%20Album/components/app_bar.dart';
import 'package:point_of_view/ui/views/Albums/Selected%20Album/components/grid_item.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumView extends StatelessWidget {
  const AlbumView({this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumModel>(
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AlbumViewAppBar(
            album: album,
            setSelectingImages: model.setSelectingImages,
            isSelecting: model.isSelectingImages,
          ),
        ),
        body: FutureBuilder(
          future: model.photos,
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
                    return GridItem(
                      imageUrl: imageUrl,
                      setSelectedImage: model.setImageSelected,
                      isSelectingImages: model.isSelectingImages,
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
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo_rounded), label: 'Upload Images'),
            BottomNavigationBarItem(
                icon: Icon(Icons.download_rounded), label: 'Download Album')
          ],
        ),
      ),
    );
  }
}
