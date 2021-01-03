import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

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
    print('retrieving');
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
      print(deepLink);

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          print(id);
          print('id');
          await FirebaseFirestore.instance
              .collection("albums")
              .doc(id)
              .update({"attendeeIds": [FirebaseAuth.instance.currentUser.uid]});
        } else {
         
          print(deepLink);
        }
      }
    } catch (e) {
       print('no');
      print(e.toString());
    }
  }
}
