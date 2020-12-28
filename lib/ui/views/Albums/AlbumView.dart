import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/viewmodels/AlbumModel.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';

class AlbumView extends StatelessWidget {
  final Album album;

  AlbumView(this.album);

  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumModel>(
        builder: (context, model, child) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: PlatformAppBar(
                  title: Text(album.title),
                  trailingActions: [
                    PlatformButton(
                      child: Text('Share'),
                      onPressed: () {
                        showPlatformDialog(
                            context: context,
                            builder: (_) =>
                                ShowAlert("Share string:", album.shareString));
                      },
                      padding: EdgeInsets.all(0),
                    )
                  ],
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('imageView', arguments: imageUrl);
                            },
                            child: GridTile(
                                child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              
                            )),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Center(
                    child: PlatformCircularProgressIndicator(),
                  );
                },
              ),
            ));
  }
}
