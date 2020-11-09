import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/cloud_firestore_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import '../models/Event.dart';

class ViewEventsModel extends BaseModel {
  CloudFirestoreService _cloudFirestoreService =
      locator<CloudFirestoreService>();

  List<Event> _myEvents;
  List<Event> get myEvents => _myEvents;

  void getEvents() async {
    setState(ViewState.Busy);
    List<Event> snapshot = await _cloudFirestoreService.getEventsList();
    _myEvents = snapshot;
    for (var event in snapshot) {
      print(event.address);
    }

    setState(ViewState.Idle);
  }
}
