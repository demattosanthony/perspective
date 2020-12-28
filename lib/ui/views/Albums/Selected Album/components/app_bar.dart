import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';

class AlbumViewAppBar extends StatelessWidget {
  const AlbumViewAppBar({
    Key key,
    @required this.album,
  }) : super(key: key);

  final Album album;

  @override
  Widget build(BuildContext context) {
    return PlatformAppBar(
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
    );
  }
}
