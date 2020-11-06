import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/create_event_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/models/Event.dart';

class DatePicker extends StatelessWidget {
  final DatePickerCallBack selectDate;
  final TimePickerCallBack selectTime;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;

  DatePicker(
      {this.selectDate,
      this.selectTime,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            startDate == null
                ? PlatformButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async => {selectDate(context, 'start')},
                    child: Text(
                      'Select Date',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async => {selectDate(context, 'start')},
                      child: Text(
                        DateFormat('MM/dd/yyyy').format(startDate),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
            startTime == null
                ? PlatformButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async => {selectTime(context, 'start')},
                    child: Text(
                      'Select Time',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: () async => {selectTime(context, 'start')},
                      child: Text(
                        DateFormat('jm').format(startTime),
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
            endDate == null
                ? PlatformButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async => {selectDate(context, 'end')},
                    child: Text(
                      'Select Date',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async => {selectDate(context, 'end')},
                      child: Text(
                        DateFormat('MM/dd/yyyy').format(endDate),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
            endTime == null
                ? PlatformButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async => {selectTime(context, 'end')},
                    child: Text(
                      'Select Time',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: () async => {selectTime(context, 'end')},
                      child: Text(
                        DateFormat('jm').format(endTime),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
          ],
        ),
      ],
    ));
  }
}

typedef DatePickerCallBack = void Function(
    BuildContext context, String startOrEnd);
typedef TimePickerCallBack = void Function(
    BuildContext context, String startOrEnd);
