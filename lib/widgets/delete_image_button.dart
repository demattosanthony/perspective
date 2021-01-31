import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/services/album_service.dart';

import 'ImageView.dart';

class DeleteImageButton extends StatelessWidget {
  const DeleteImageButton({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ImageView widget;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
                  title: Text("Are you sure you want to delete this image?"),
                  actions: [
                    PlatformDialogAction(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    PlatformDialogAction(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        await locator<AlbumService>()
                            .deleteImage(widget.albumId, widget.photo.imageId);
                        await locator<AlbumManager>()
                            .getAlbumImages(widget.albumId);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      },
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Icon(Icons.delete, color: Colors.red)),
      backgroundColor: Colors.transparent,
    );
  }
}
