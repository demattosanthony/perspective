import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void checkIfExecuting() async {
    int n = 0;
    locator<AlbumManager>().joinAlbum.isExecuting.listen((isExecuting) async {
      if (isExecuting) {
        print('is executing');
      } else {
        n += 1;
        if (n == 2) Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    checkIfExecuting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Joining Album',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            Padding(padding: EdgeInsets.symmetric(vertical: 35)),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
