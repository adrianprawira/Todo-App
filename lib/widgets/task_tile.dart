import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../BLoC/database/database_bloc.dart';
import '../model/database/task_model.dart';
import '../ui/editTask.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat('dd MMM, yyyy').format(task.date!);
    var formattedTime = DateFormat('HH:mm').format(task.date!);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () async {
            final result = await Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => EditTaskScreen(task)));

            if (result == true)
              return BlocProvider.of<DatabaseBloc>(context).add(GetTaskEvent());
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => BlocProvider.of<DatabaseBloc>(context)
              .add(DeleteEvent(task: task)),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListTile(
          title: Text(
            '${task.title}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: task.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(
            '\n$formattedDate in ${task.location} at $formattedTime ⚫ ${task.priority}',
            style: TextStyle(
                decoration: task.status == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          trailing: Checkbox(
            value: task.status == 1 ? true : false,
            onChanged: (newVal) {
              task.status = newVal! ? 1 : 0;
              BlocProvider.of<DatabaseBloc>(context)
                  .add(UpdateEvent(task: task));
            },
          ),
        ),
      ),
    );
  }
}
