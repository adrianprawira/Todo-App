part of 'database_bloc.dart';

abstract class DatabaseEvent {}

class InitEvent extends DatabaseEvent {}

class InsertEvent extends DatabaseEvent {
  Task task;

  InsertEvent({@required this.task});
}

class UpdateEvent extends DatabaseEvent {
  Task task;

  UpdateEvent({@required this.task});
}

class DeleteEvent extends DatabaseEvent {
  Task task;

  DeleteEvent({@required this.task});
}
