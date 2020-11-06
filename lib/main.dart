import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Router;


import 'package:firebase_core/firebase_core.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:provider/provider.dart';

import 'ui/router.dart';
import 'locator.dart';

void main() async {
  setupLocator(); 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: FirebaseAuth.instance.authStateChanges()),
        
        ],
          child: MaterialApp(
        title: 'Point of View',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
