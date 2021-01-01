import 'package:flutter/material.dart';
import 'package:point_of_view/models/Album.dart';

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
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: album.profileImgUrl == 'null'
                            ? AssetImage('assets/profile_icon.png')
                            : NetworkImage(album.profileImgUrl),
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

