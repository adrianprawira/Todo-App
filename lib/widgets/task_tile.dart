import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:muslimpedia_todo_flutter/BLoC/database/database_bloc.dart';
import 'package:muslimpedia_todo_flutter/model/database/task_model.dart';
import 'package:muslimpedia_todo_flutter/utils/notification_services.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({this.task});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            BlocProvider.of<DatabaseBloc>(context).add(DeleteEvent(task: task));
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          title: Text(
            '${task.title}',
            style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500,
                decoration: task.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(
            '\n${DateFormat('dd MMM, yyyy').format(task.date)} in ${task.location} at ${DateFormat('HH:mm').format(task.date)} ⚫ ${task.priority}',
            style: TextStyle(
                decoration: task.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          trailing: Checkbox(
            value: task.status == 1 ? true : false,
            onChanged: (newVal) {
              task.status = newVal ? 1 : 0;
              BlocProvider.of<DatabaseBloc>(context).add(UpdateEvent(task: task));
            },
          ),
        ),
      ),
    );
  }
}
