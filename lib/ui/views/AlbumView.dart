import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/AlbumModel.dart';
import 'package:point_of_view/ui/views/base_view.dart';

class AlbumView extends StatelessWidget {
  final int albumId;

  AlbumView(this.albumId);

  @override
  Widget build(BuildContext context) {
    return BaseView<AlbumModel>(
        builder: (context, model, child) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: PlatformAppBar(
                  trailingActions: [
                    PlatformButton(
                      child: Text('Share'),
                      onPressed: () {},
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
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 4 : 3),
                        itemBuilder: (context, index) {
                          return GridTile(
                              child: Image.network(
                            snapshot.data[index].imageUrl,
                            fit: BoxFit.cover,
                          ));
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
