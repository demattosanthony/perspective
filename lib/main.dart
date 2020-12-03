import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'core/models/Event.dart';

import 'ui/router.dart';
import 'locator.dart';

void main() async {
  setupLocator(); 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Point of View',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      
    );
  }
}
