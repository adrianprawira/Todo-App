import 'package:flutter/cupertino.dart';
import 'package:muslimpedia_todo_flutter/model/database/task_model.dart';

abstract class BlocEvent{}

class InsertEvent extends BlocEvent {
  String eventType = 'insert';
  Task task;

  InsertEvent({@required this.task});
}

class UpdateEvent extends BlocEvent {
  String eventType = 'update';
  Task task;

  UpdateEvent({@required this.task});
}

class DeleteEvent extends BlocEvent {
  String eventType = 'delete';
  Task task;

  DeleteEvent({@required this.task});
}
