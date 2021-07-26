part of 'database_bloc.dart';

abstract class DatabaseState {}

class DatabaseInitialState extends DatabaseState {}

class DatabaseLoadingState extends DatabaseState {}

class DatabaseLoadedState extends DatabaseState {
  List<Task> taskList;

  DatabaseLoadedState({this.taskList});
}
