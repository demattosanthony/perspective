import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:point_of_view/app/theme.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:point_of_view/services/dynamic_links_service.dart';
import 'package:share/share.dart';
import 'router.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();

  Widget _defautHome = new LoginView();

  // ignore: await_only_futures
  await FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      _defautHome = LoginView();
    } else {
      _defautHome = BottomNavBar();
    }
  });

  runApp(
    MaterialApp(
      theme: theme(),
      debugShowCheckedModeBanner: false,
      home: _defautHome,
      onGenerateRoute: Router.generateRoute,
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(const Duration(milliseconds: 1000), () {
        _dynamicLinkService.retreieveDynamicLink(context);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          width: 100,
          child: FutureBuilder<Uri>(
              future: _dynamicLinkService.createDynamicLink('testingtesting'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Uri uri = snapshot.data;
                  return FlatButton(
                    color: Colors.amber,
                    onPressed: () => Share.share(uri.toString()),
                    child: Text('Share'),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
