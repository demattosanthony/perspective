import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';

class SelectAlbumButton extends StatelessWidget {
  const SelectAlbumButton({
    Key key,
    @required this.myAlbums,
    @required this.setSelectedAlbum,
    @required this.selectedAlbum,
  }) : super(key: key);

  final List<Album> myAlbums;
  final SetSelectedAlbumCallBack setSelectedAlbum;
  final Album selectedAlbum;

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
                            setSelectedAlbum(myAlbums[index]);
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
          child: Text(
            selectedAlbum == null ? 'Select Album' : selectedAlbum.title.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          color: Colors.grey.withOpacity(0.30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
  }
}

typedef SetSelectedAlbumCallBack = void Function(Album album);
