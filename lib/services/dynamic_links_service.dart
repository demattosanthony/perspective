import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';

abstract class DynamicLinkService {
  Future<Uri> createDynamicLink(String id);
  Future<void> retreieveDynamicLink(BuildContext context);
}

class DynamicLinksServiceImplemenation implements DynamicLinkService {
  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://perspective.page.link',
        link: Uri.parse('https://perspective.page.link.com/?id=$id'),
        iosParameters: IosParameters(
            bundleId: 'APD-APPS.perspective',
            minimumVersion: '1',
            appStoreId: '123456789'));
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

  Future<void> retreieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String albumId = deepLink.queryParameters['id'];
          locator<AlbumService>().joinAlbum(albumId);
        }
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          if (deepLink.queryParameters.containsKey('id')) {
            String albumId = deepLink.queryParameters['id'];
            locator<AlbumService>().joinAlbum(albumId);
          }
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
