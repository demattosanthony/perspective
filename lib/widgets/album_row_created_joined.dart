import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/album_service.dart';

class AlbumRow extends StatelessWidget {
  const AlbumRow({Key key, @required this.albums})
      : super(key: key);

  final List<Album> albums;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          var album = albums[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('albumView', arguments: album);
            },
            child: Container(
              height: 75,
              child: Card(
                  elevation: 5,
                  child: Center(
                    child: ListTile(
                      leading:  FutureBuilder(
                          future: locator<AlbumService>().getUserProfileImg(
                            album.ownerId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(snapshot.data));
                            }
                            return Container();
                          },
                        ),
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                                              child: Text(
                          album.title.toUpperCase(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  )),
            ),
          );
        });
  }
}

