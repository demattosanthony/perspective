import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/locator.dart';
import '../models/Event.dart';

class CloudFirestoreService {
  final AuthService _authService = locator<AuthService>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getEventIdsList() async {
    var firebaseUser = _authService.getCurrentUser();

    var snapshot = await _firestore
        .collection('users')
        .doc('${firebaseUser.uid}')
        .collection('myEvents')
        .get();

    /*List<Map<dynamic, dynamic>> eventIdsList =
        snapshot.docs.map((e) => e.data()).toList();*/

    List<String> eventIdsList =
        snapshot.docs.map((e) => e['event_id'].toString()).toList();

    return eventIdsList;
  }

  Future<List<Event>> getEvents(List<String> ids) async {
    var query = _firestore.collection('events').where('id', whereIn: ids);
    var events = await query.get();

    var eventList = events.docs
        .map((doc) => Event(
            id: doc['id'],
            title: doc['title'],
            startDate: doc['startDate'],
            endDate: doc['endDate'],
            startTime: doc['startTime'],
            endTime: doc['endTime'],
            latitude: doc['latitude'],
            longitude: doc['longitude'],
            locationTitle: doc['locationTitle'],
            details: doc['details'],
            address: doc['address']))
        .toList();

    return eventList;
  }

  Future<String> createEvent(Event event) async {
    var firebaseUser = _authService.getCurrentUser();
    DocumentReference event_ref =
        await _firestore.collection('events').add(event.toJson());

    /*DocumentReference event_ref = await _firestore
        .collection('users')
        .doc('${firebaseUser.uid}')
        .collection('myEvents')
        .add(event.toJson());*/

    _firestore
        .collection('events')
        .doc('${event_ref.id}')
        .update({'id': event_ref.id});

    _firestore
        .collection('users')
        .doc('${firebaseUser.uid}')
        .collection('myEvents')
        .doc('${event_ref.id}')
        .set({'event_id': event_ref.id});

    if (event_ref != null)
      return event_ref.id;
    else
      return null;
  }

  Future<String> getProfileImage() async {
    var firebaseUser = _authService.getCurrentUser();
    var profileImageUrl;
    profileImageUrl = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        print(documentSnapshot['profileImage']);
        return documentSnapshot['profileImage'];
      }
    });
    return profileImageUrl;
  }

  Future<DocumentSnapshot> getUserInfo() async {
    var firebaseUser = _authService.getCurrentUser();
    return await _firestore.collection("users").doc(firebaseUser.uid).get();
  }
}
