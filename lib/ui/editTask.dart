import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

///BloC
import '../BLoC/database/database_bloc.dart';

/// Db
import '../model/database/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  EditTaskScreen(this.task);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  String? _priority;
  TextEditingController _titleController = TextEditingController(),
      _dateController = TextEditingController();
  final dateTimeFormat = DateFormat("dd MMM yyyy, HH:mm");
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final _globalKey = GlobalKey<ScaffoldState>();
  late Task _task;
  late DateTime _dateValue;

  @override
  void initState() {
    _task = widget.task;
    super.initState();
    _dateValue = _task.date!;
    _titleController.text = _task.title!;
    _dateController.text = dateTimeFormat.format(_dateValue);
    _priority = _task.priority;
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
                    onTap: Navigator.of(context).pop,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 27,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Edit Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _titleController,
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
                    controller: _dateController,
                    onChanged: (value) => setState(() => _dateValue = value!),
                    onShowPicker: (context, dateTimeValue) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: dateTimeValue!,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(dateTimeValue));
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
                    onChanged: (String? value) {
                      setState(() => _priority = value);
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
                    onTap: () {
                      final _title = _titleController.text;
                      final _date = _dateValue;

                      if (_title.trim().isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('Please set a task title'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Task task = Task.withID(
                          id: _task.id,
                          title: _title,
                          date: _date,
                          priority: _priority,
                          location: _task.location,
                          status: _task.status,
                        );

                        BlocProvider.of<DatabaseBloc>(context)
                            .add(UpdateEvent(task: task));

                        Navigator.pop(context, true);
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
                        'Update Task',
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
