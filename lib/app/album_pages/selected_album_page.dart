import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/camera_widgets/selected_album_app_bar.dart';
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
  List<Photo> _photos;

  void setSelectingImages() {
    setState(() {
      isSelectingImages = !isSelectingImages;
    });
  }

  @override
  void initState() {
    locator<AlbumManager>().getAlbumImages(widget.album.albumId);
    locator<AlbumManager>().getAttendees(widget.album.albumId);
    super.initState();
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
        stream: locator<AlbumManager>().getAlbumImages,
        initialData: [],
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
                  Photo photo = snapshot.data[index];
                  String imageUrl = photo.imageUrl;
                  bool isSelected = photo.isSelected;
                  return ImageGridItem(
                    imageUrl: imageUrl,
                    isSelectingImages: isSelectingImages,
                    isSelected: isSelected,
                    photos: snapshot.data,
                    index: index,
                    albumId: widget.album.albumId,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: StreamBuilder<List<UserAccount>>(
        stream: locator<AlbumManager>().getAttendees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    UserAccount user = snapshot.data[index];
                    return Container(
                      padding: const EdgeInsets.all(3.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                  0,
                                  MediaQuery.of(context).size.height * .65,
                                  0,
                                  0),
                              items: [
                                PopupMenuItem(child: Text(user.name)),
                                PopupMenuItem(child: Text(user.username)),
                              ]);
                        },
                        child: FittedBox(
                          child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              backgroundImage: user.profileImageUrl == ""
                                  ? AssetImage('assets/images/profile_icon.png')
                                  : NetworkImage(user.profileImageUrl)),
                        ),
                      ),
                    );
                  }),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: SelectedAlbumBottomNavBar(
        widget: widget,
        isSelectingImages: isSelectingImages,
        album: widget.album,
        photos: _photos,
      ),
    );
  }
}
