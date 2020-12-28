import 'package:flutter/material.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';
import 'package:point_of_view/ui/views/Albums/My Albums/components/AlbumRow.dart';
import '../../base_view.dart';
import 'package:point_of_view/ui/views/Albums/My Albums/components/app_bar.dart';

class MyAlbumsView extends StatelessWidget {
  const MyAlbumsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAlbumsModel>(
      builder: (context, model, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: MyAlbumsViewAppBar(),
          ),
          body: model.myAlbums == null
              ? Container()
              : RefreshIndicator(
                  onRefresh: () async {
                    model.getAlbums();
                  },
                  child: FutureBuilder(
                    future: model.myAlbums,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AlbumRow(snapshot.data, model.getPhotos,
                            model.deleteAlbum, model.getAlbums);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return Container();
                    },
                  )),),
                
    );
  }
}


