import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';

import '../utils.dart';

class Todo {
  final String id;
  final DateTime createdTime;
  final String title;
  final String description;
  List<Task> tasks;
  bool isDone;

  Todo({
    @required this.createdTime,
    @required this.title,
    this.description = '',
    this.id,
    this.tasks,
    this.isDone = false,
  });

  static const _keyNameCreatedTime = 'created_time';
  static const _keyNameDescription = 'description';
  static const _keyNameTitle = 'title';
  static const _keyNameId = 'id';
  static const _keyNameTasks = 'tasks';
  static const _keyNameIsDone = 'completed';

  static Todo fromJson(
    Map<String, dynamic> json,
  ) =>
      Todo(
          createdTime: Utils.toDateTime(json[_keyNameCreatedTime]),
          id: json[_keyNameId],
          title: json[_keyNameTitle],
          description: json[_keyNameDescription],
          isDone: json[_keyNameIsDone],
          tasks: Task.getTaskList(json[_keyNameTasks], json[_keyNameId]));

  Map<String, dynamic> toJson({String id}) => {
        _keyNameCreatedTime: Utils.fromDateTimeToJson(this.createdTime),
        _keyNameTitle: this.title,
        _keyNameDescription: this.description,
        _keyNameId: this.id ?? id,
        _keyNameIsDone: this.isDone,
        _keyNameTasks: []
      };

  static String get createdAt => _keyNameCreatedTime;
}
