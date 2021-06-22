import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';

class SelectAlbumButton extends StatefulWidget {
  const SelectAlbumButton({
    Key? key,
  }) : super(key: key);

  @override
  _SelectAlbumButtonState createState() => _SelectAlbumButtonState();
}

class _SelectAlbumButtonState extends State<SelectAlbumButton> {
  List<Album>? _myAblums;
  @override
  void initState() {
    super.initState();

    locator<AlbumManager>().getAlbums.isExecuting.listen((event) {
      _myAblums = locator<AlbumManager>().getAlbums.lastResult;
    });
  }

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
                  return SingleChildScrollView(
                    child: Column(
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
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _myAblums!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  locator<CameraManager>()
                                      .selectedAlbum(_myAblums![index]);
                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          _myAblums![index].title.toUpperCase(),
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    Divider()
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  );
                });
          },
          child: StreamBuilder<Album>(
            stream: locator<CameraManager>().selectedAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title.toUpperCase(),
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
