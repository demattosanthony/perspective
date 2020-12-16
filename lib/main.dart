import 'package:flutter/material.dart' hide Router;
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';
import 'package:provider/provider.dart';
import 'core/models/Album.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/router.dart';
import 'locator.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  final ApiService _apiService = locator<ApiService>();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => MyAlbumsModel(),)
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
     ));
}
