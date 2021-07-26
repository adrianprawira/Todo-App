import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

///BloC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslimpedia_todo_flutter/BLoC/database/database_bloc.dart';

import 'package:muslimpedia_todo_flutter/utils/geo_location.dart';

import 'package:intl/intl.dart';
import 'package:muslimpedia_todo_flutter/model/database/task_model.dart';

FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _location = GetLocation.getSpecificLoc;
  String _title;
  String _priority = 'Medium';
  DateTime _dateTime = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final dateTimeFormat = DateFormat("dd MMM yyyy, HH:mm");
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initializeNotification();
    tz.initializeTimeZones();
    _dateController.text = dateTimeFormat.format(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _globalKey,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 27,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Add Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DateTimeField(
                    format: dateTimeFormat,
                    onChanged: (val) {
                      setState(() {
                        _dateTime = val;
                      });
                    },
                    controller: _dateController,
                    onShowPicker: (context, dateTimeValue) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: dateTimeValue ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                dateTimeValue ?? DateTime.now()));
                        return DateTimeField.combine(date, time);
                      } else {
                        return dateTimeValue;
                      }
                    },
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        labelText: 'Set Date & Time',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: _priority,
                    items: _priorities
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority.toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _priority = value;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 25,
                    iconDisabledColor: Theme.of(context).primaryColor,
                    iconEnabledColor: Theme.of(context).primaryColor,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Set Importance',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_title == null || _title.trim().isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('Please set a task title'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (_location == null) {
                        final snackBar = SnackBar(
                          content: Text(
                              'Please activate location services at homepage menu'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Task task = Task();

                        task.title = _title;
                        task.date = _dateTime;
                        task.status = 0;
                        task.location = _location;
                        task.priority = _priority;

                        BlocProvider.of<DatabaseBloc>(context)
                            .add(InsertEvent(task: task));

                        showNotification(task.id, task.title, task.date);

                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Set Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initializeNotification() async {
    var android = AndroidInitializationSettings('ic_launcher');
      var initSetting = InitializationSettings(android: android);
      await notificationPlugin.initialize(initSetting);
  }

  Future<void> showNotification(int id, String title, DateTime date) async {
    int id = 0;
    id++;
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Todo List', 'Todo List', 'Todo List Notification');
      var notifDetails = NotificationDetails(android: androidPlatformChannelSpecifics);

    notificationPlugin.zonedSchedule(
      id,
      title,
      'U HAVE A TASK TO DO, MY FRIEND!',
      tz.TZDateTime.from(_dateTime, tz.local).add(Duration(minutes: -5)),
      notifDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
  }
}