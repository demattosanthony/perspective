import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';
import 'package:point_of_view/ui/widgets/AlbumRow.dart';
import 'base_view.dart';
import 'package:point_of_view/ui/views/CreateAlbumView.dart';
import 'package:point_of_view/core/models/Album.dart';

class MyAlbumsScreen extends StatelessWidget {
  const MyAlbumsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAlbumsModel>(
        builder: (context, model, child) => Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: PlatformAppBar(
                backgroundColor: Colors.white,
                title: Text('Albums'),
                automaticallyImplyLeading: false,
                trailingActions: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          builder: (builder) => CreateAlbumView());
                    },
                    child: Icon(Icons.add),
                  )
                ],
              ),
            ),
            body: model.myAlbums == null
                ? Container()
                : RefreshIndicator(
                    onRefresh: () async {
                      await model.getAlbums();
                    },
                    child: AlbumRow(model.myAlbums),
                  )));
  }
}
