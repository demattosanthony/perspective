import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:point_of_view/core/viewmodels/CreateAlbumModel.dart';
import 'package:point_of_view/ui/views/Albums/Create%20Album/components/create_album_button.dart';
import 'package:point_of_view/ui/views/Albums/Create%20Album/components/join_album_button.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';
import '../../base_view.dart';

class CreateAlbumView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAlbumModel>(
        builder: (context, model, child) => Container(
              height: MediaQuery.of(context).size.height * .90,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * .10,
                      child: CustomTextField(
                          'Album Title',
                          model.albumTitleController,
                          false,
                          TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  Divider(
                    thickness: 1,
                  ),
                  JoinAlbumButton(
                    albumCodeController: model.albumCodeController,
                    joinAlbum: model.joinAlbum,
                  ),
                  CreateAlbumButton(createAlbum: model.createAlbum,),
                ],
              ),
            ));
  }
}


