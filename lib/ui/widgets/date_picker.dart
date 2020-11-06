import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/create_event_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CreateEventModel>(
      builder: (context, model, child) => Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Start Date',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ),
              model.selectedStartDate == null
                  ? PlatformButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => model.selectDate(context, 'start'),
                      child: Text(
                        'Select Date',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => model.selectDate(context, 'start'),
                        child: Text(
                          DateFormat('MM/dd/yyyy')
                              .format(model.selectedStartDate),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
              model.selectedStartTime == null
                  ? PlatformButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => model.selectTime(context, 'start'),
                      child: Text(
                        'Select Time',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () => model.selectTime(context, 'start'),
                        child: Text(
                          DateFormat('jm').format(model.selectedStartTime),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
            ],
          ),
          Column(
            children: [
              Text(
                'End Date',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ),
              model.selectedEndDate == null
                  ? PlatformButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => model.selectDate(context, 'end'),
                      child: Text(
                        'Select Date',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => model.selectDate(context, 'end'),
                        child: Text(
                          DateFormat('MM/dd/yyyy')
                              .format(model.selectedEndDate),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
              model.selectedEndTime == null
                  ? PlatformButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => model.selectTime(context, 'end'),
                      child: Text(
                        'Select Time',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () => model.selectTime(context, 'end'),
                        child: Text(
                          DateFormat('jm').format(model.selectedEndTime),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
            ],
          ),
        ],
      )),
    );
  }
}
