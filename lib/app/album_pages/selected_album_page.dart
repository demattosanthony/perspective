import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:optimized_cached_image/widgets.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/widgets/selected_album_app_bar.dart';
import 'package:point_of_view/widgets/image_grid_item.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/widgets/selected_album_bottom_nav_bar.dart';
import 'package:flutter/services.dart';

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
          photos: _photos,
        ),
      ),
      body: StreamBuilder<List<Photo>>(
        stream: locator<AlbumManager>().getAlbumImages,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orientation = MediaQuery.of(context).orientation;
            return GridView.builder(
                addAutomaticKeepAlives: false,
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 4 : 6),
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
                        heroTag: '${user.userId}',
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
                        child: Container(
                            height: 52,
                            width: 52,
                            child: user.profileImageUrl == ''
                                ? Image.asset('assets/images/profile_icon.png')
                                : OptimizedCacheImage(
                                    imageUrl: user.profileImageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider)),
                                    ),
                                    placeholder: (context, url) => Center(
                                        child:
                                            PlatformCircularProgressIndicator()),
                                    height: 100,
                                    width: 100,
                                  )),
                        backgroundColor: Colors.white,
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
      ),
    );
  }
}
