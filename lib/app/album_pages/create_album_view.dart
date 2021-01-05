import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:point_of_view/widgets/album_widgets/create_album_button.dart';
import 'package:point_of_view/widgets/CustomTextField.dart';

class CreateAlbumView extends StatelessWidget {
  final TextEditingController _albumTitleController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .10,
              child: CustomTextField('Album Title', _albumTitleController,
                  false, TextStyle(fontSize: 22))),
          Divider(
            thickness: 1,
          ),
          CreateAlbumButton(title: _albumTitleController),
        ],
      ),
    );
  }
}
