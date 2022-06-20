import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:muslimpedia_todo_flutter/constants/const.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../BLoC/database/database_bloc.dart';
import '../model/database/task_model.dart';
import '../utils/geo_location.dart';
import '../utils/notification_services.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var notifService = NotificationService();
  String? _location = GetLocation.getSpecificLoc;
  String? _title;
  String _priority = 'Medium';
  DateTime? _dateTime = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final dateTimeFormat = DateFormat("dd MMM yyyy, HH:mm");
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final _globalKey = GlobalKey<ScaffoldState>();

  late DatabaseBloc dbBloc;

  @override
  void initState() {
    dbBloc = context.read<DatabaseBloc>();
    GetLocation.determinePos();
    super.initState();
    tz.initializeTimeZones();
    _dateController.text = dateTimeFormat.format(_dateTime!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
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
                    onTap: Navigator.of(context).pop,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 27,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Add Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    onChanged: (value) => setState(() => _title = value),
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 20),
                  DateTimeField(
                    format: dateTimeFormat,
                    onChanged: (val) => setState(() => _dateTime = val),
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
                  SizedBox(height: 20),
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
                    onChanged: (String? value) {
                      setState(() => _priority = value!);
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
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (_title == null || _title!.trim().isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('Please set a task title',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (_location == null) {
                        final snackBar = SnackBar(
                          content: Text(
                              'Please activate location services at homepage menu',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (!FormStructure.is5MinutesAhead(_dateTime!)) {
                        final snackBar = SnackBar(
                          content: Text(
                              'User must insert datetime at least 5 minutes ahead'),
                          backgroundColor: Colors.red,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      final _task = Task(
                        title: _title,
                        date: _dateTime,
                        status: 0,
                        location: _location,
                        priority: _priority,
                      );

                      dbBloc.add(InsertEvent(task: _task));

                      dbBloc.stream.listen((state) async {
                        if (state is DatabaseLoadedState) {
                          await notifService.setNotificationSchedule(
                            _task.id ?? 0,
                            _task.title,
                            _task.date!.subtract(
                                Duration(minutes: 5, milliseconds: -500)),
                          );
                        }
                      });

                      Navigator.pop(context);
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
}
