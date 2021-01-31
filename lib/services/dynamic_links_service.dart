import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DynamicLinkService {
  Future<Uri> createDynamicLink(String id, String albumTitle, String ownerId);
  Future<void> retreieveDynamicLink(BuildContext context);
}

class DynamicLinksServiceImplemenation implements DynamicLinkService {
  Future<Uri> createDynamicLink(
      String id, String albumTitle, String ownerId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://perspective.page.link',
      link: Uri.parse(
          'https://perspective.page.link.com/?albumId=$id&ownerId=$ownerId'),
      iosParameters: IosParameters(
          bundleId: 'APD-APPS.perspective',
          minimumVersion: '1',
          appStoreId: '123456789'),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

  Future<void> retreieveDynamicLink(BuildContext context) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          if (deepLink.queryParameters.containsKey('albumId')) {

            String albumId = deepLink.queryParameters['albumId'];
            String ownerId = deepLink.queryParameters['ownerId'];
            //locator<AlbumManager>().joinAlbum(int.parse(albumId));

            // int userId =
            //     await locator<UserService>().getUserIdFromSharedPrefs();
             String userId = FirebaseAuth.instance.currentUser.uid;
            if (userId != ownerId)
              Navigator.of(context)
                  .pushReplacementNamed('loadingPage', arguments: albumId);
          }
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String linkHasBeenOpened = prefs.getString('dynamicLinkUrl');
      if (linkHasBeenOpened != deepLink.toString()) {
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('albumId')) {

          prefs.setString('dynamicLinkUrl', deepLink.toString());
          String albumId = deepLink.queryParameters['albumId'];
          String ownerId = deepLink.queryParameters['ownerId'];
          String userId = FirebaseAuth.instance.currentUser.uid;
            if (userId != ownerId)
            Navigator.of(context)
                .pushReplacementNamed('loadingPage', arguments: albumId);
          //locator<AlbumManager>().joinAlbum(int.parse(albumId));

        }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
