import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';
import 'package:point_of_view/ui/widgets/AlbumRow.dart';
import '../base_view.dart';
import 'package:point_of_view/ui/views/Albums/CreateAlbumView.dart';

class MyAlbumsView extends StatelessWidget {
  const MyAlbumsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAlbumsModel>(
      builder: (context, model, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: PlatformAppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Albums',
                style: TextStyle(color: Colors.black),
              ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
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
