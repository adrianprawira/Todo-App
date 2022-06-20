import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:muslimpedia_todo_flutter/model/database/database_helper.dart';
import 'package:muslimpedia_todo_flutter/model/database/task_model.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc() : super(DatabaseInitialState());

  @override
  Stream<DatabaseState> mapEventToState(
    DatabaseEvent event,
  ) async* {
    final _dataBase = DatabaseHelper.instance;

    if (event is InitEvent) {
      yield DatabaseLoadingState();

      final taskList = await _dataBase.getTaskList();
      if (taskList == null) yield DatabaseStateFailure();

      yield DatabaseLoadedState(taskList: taskList);
    } else if (event is GetTaskEvent) {
      yield DatabaseLoadingState();

      final taskList = await _dataBase.getTaskList();
      if (taskList == null) yield DatabaseStateFailure();

      yield DatabaseLoadedState(taskList: taskList);
    } else if (event is InsertEvent) {
      final res = await _dataBase.insertTask(event.task);
      if (res == null) yield DatabaseStateFailure();

      final taskList = await _dataBase.getTaskList();
      if (taskList == null) yield DatabaseStateFailure();

      yield DatabaseLoadedState(taskList: taskList);
    } else if (event is UpdateEvent) {
      final res = await _dataBase.updateTask(event.task);
      if (res == null) yield DatabaseStateFailure();

      final taskList = await _dataBase.getTaskList();
      if (taskList == null) yield DatabaseStateFailure();

      yield DatabaseLoadedState(taskList: taskList);
    } else if (event is DeleteEvent) {
      final res = await _dataBase.deleteTask(event.task.id);
      if (res == null) yield DatabaseStateFailure();

      final taskList = await _dataBase.getTaskList();
      if (taskList == null) yield DatabaseStateFailure();

      yield DatabaseLoadedState(taskList: taskList);
    }
  }
}
