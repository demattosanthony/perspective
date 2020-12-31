import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:point_of_view/ui/views/Albums/Create%20Album/components/create_album_button.dart';
import 'package:point_of_view/ui/views/Albums/Create%20Album/components/join_album_button.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';

class CreateAlbumView extends StatelessWidget {
  final TextEditingController _albumTitleController = new TextEditingController();
  final TextEditingController _albumCodeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
              height: MediaQuery.of(context).size.height * .90,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * .10,
                      child: CustomTextField(
                          'Album Title',
                          _albumTitleController,
                          false,
                          TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  Divider(
                    thickness: 1,
                  ),
                  JoinAlbumButton(
                    albumCodeController: _albumCodeController,
                  ),
                  CreateAlbumButton(title: _albumTitleController.text),
                ],
              ),
            );
  }
}


