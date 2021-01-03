import 'package:flutter/material.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:rxdart/streams.dart';

class SelectAlbumButton extends StatelessWidget {
  const SelectAlbumButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 75,
        left: 20,
        child: RaisedButton(
          onPressed: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                context: context,
                builder: (builder) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .10,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey),
                        ),
                      ),
                      StreamBuilder(
                        stream: CombineLatestStream.list([
                          locator<AlbumService>().getCreatedAlbums(),
                          locator<AlbumService>().getJoinedAlbums()
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Album> createdAndJoinedAlbums =
                                snapshot.data[0] + snapshot.data[1];
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: createdAndJoinedAlbums.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      locator<CameraManager>().selectedAlbum(
                                          createdAndJoinedAlbums[index]);
                                      Navigator.of(context).pop();
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              createdAndJoinedAlbums[index]
                                                  .title
                                                  .toUpperCase(),
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  );
                                });
                          }

                          return Container();
                        },
                      ),
                    ],
                  );
                });
          },
          child: StreamBuilder<Album>(
            stream: locator<CameraManager>().selectedAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 18));
              } else {
                return Text('Select Album',
                    style: TextStyle(color: Colors.white, fontSize: 18));
              }
            },
          ),
          color: Colors.grey.withOpacity(0.30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
  }
}
