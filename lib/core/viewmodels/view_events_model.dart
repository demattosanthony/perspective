import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/cloud_firestore_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import '../models/Event.dart';

class ViewEventsModel extends BaseModel {
  //CloudFirestoreService _cloudFirestoreService =
    //  locator<CloudFirestoreService>();

  List<Event> _myEvents;
  List<Event> get myEvents => _myEvents;

  void getEvents() async {
    setState(ViewState.Busy);
    //List<String> eventIds = await _cloudFirestoreService.getEventIdsList();

    // //for (var id in eventIds) {
    //   //print(id);
    // }
    //var eventList = await _cloudFirestoreService.getEvents(eventIds);
    // _myEvents = eventList;
    // for (var event in eventList) {
    //   print(event.address);
    // }
    setState(ViewState.Idle);
  }

  ViewEventsModel() {
    print('here');
    getEvents();
  }
}
