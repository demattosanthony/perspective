import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/view_events_model.dart';
import 'package:point_of_view/ui/widgets/event_home_screen_preview.dart';
import 'base_view.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ViewEventsModel>(
        builder: (context, model, child) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: PlatformAppBar(
                  backgroundColor: Colors.white,
                  title: Text('Events'),
                  automaticallyImplyLeading: false,
                ),
              ),
              body: EventHomeScreenPreview(model.myEvents),
            ));
  }
}
