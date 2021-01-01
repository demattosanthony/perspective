import 'package:flutter/material.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';

class SelectAlbumButton extends StatelessWidget {
  const SelectAlbumButton({
    Key key,
    @required this.myAlbums,
  }) : super(key: key);

  final List<Album> myAlbums;

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
                  return ListView.builder(
                      itemCount: myAlbums.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            locator<CameraManager>()
                                .selectedAlbum(myAlbums[index]);
                            Navigator.of(context).pop();
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(myAlbums[index].title.toUpperCase(),
                                    style: TextStyle(fontSize: 18)),
                              ),
                              Divider()
                            ],
                          ),
                        );
                      });
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
