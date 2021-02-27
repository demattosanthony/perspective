import 'package:flutter/material.dart';
import 'package:optimized_cached_image/widgets.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OptimizedCacheImage(
      imageUrl:
          'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
    ));
  }
}
