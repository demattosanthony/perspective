import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/services/album_service.dart';

abstract class DynamicLinkService {
  Future<Uri> createDynamicLink(String id, String albumTitle);
  Future<void> retreieveDynamicLink(BuildContext context);
}

class DynamicLinksServiceImplemenation implements DynamicLinkService {
  Future<Uri> createDynamicLink(String id, String albumTitle) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://perspective.page.link',
        link: Uri.parse('https://perspective.page.link.com/?id=$id'),
        iosParameters: IosParameters(
            bundleId: 'APD-APPS.perspective',
            minimumVersion: '1',
            appStoreId: '123456789'),
        socialMetaTagParameters:
            SocialMetaTagParameters(title: 'Join Album: $albumTitle'));
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

  Future<void> retreieveDynamicLink(BuildContext context) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          if (deepLink.queryParameters.containsKey('id')) {
            String albumId = deepLink.queryParameters['id'];
            locator<AlbumManager>().joinAlbum(albumId);

            Navigator.of(context).pushReplacementNamed('loadingPage');
          }
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String albumId = deepLink.queryParameters['id'];
          bool userInAlbum =
              await locator<AlbumService>().isUserInAlbum(albumId);
          if (!userInAlbum) {
            locator<AlbumManager>().joinAlbum(albumId);

            Navigator.of(context).pushReplacementNamed('loadingPage');
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
