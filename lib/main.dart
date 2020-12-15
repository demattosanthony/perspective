import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'core/models/Event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/router.dart';
import 'locator.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: Router.generateRoute,
  ));
}
