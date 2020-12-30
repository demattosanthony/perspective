import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ImageView extends StatelessWidget {
  final imageUrl;

  ImageView(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: PlatformAppBar(backgroundColor: Colors.black,),
      ),
      body: Image.network(imageUrl),
    );
  }
}
