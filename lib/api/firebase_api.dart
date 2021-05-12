import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/provider/user.dart';

import '../utils.dart';

class FirebaseApi extends ChangeNotifier {
  final String _userEmail;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = _db.collection('users');
  CollectionReference get _todoCollection =>
      _userCollection.doc(_userEmail).collection('todo');

  FirebaseApi(this._userEmail);

  Future<void> createTodo(Todo todo) async {
    await _todoCollection.doc(todo.id).set(todo.toJson());
  }

  Future<void> toggleTodo(Todo todo) async {
    todo.isDone = !todo.isDone;
    _db.runTransaction((transaction) async =>
        transaction.update(_todoCollection.doc(todo.id), {
          'completed': todo.isDone,
        }));
  }

  Stream<List<Todo>> readTodos() => _todoCollection
      .orderBy(Todo.createdAt, descending: true)
      .snapshots()
      .transform(
        Utils.transformer(Todo.fromJson),
      );

  Future<Todo> getTodo(String todoId) async {
    final doc = await _todoCollection.doc(todoId).get();
    return Todo.fromJson(doc.data());
  }

  Future updateTodo(Todo todo) async {
    final docTodo = _todoCollection.doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  Future deleteTodo(Todo todo) async {
    final docTodo = _todoCollection.doc(todo.id);
    await docTodo.delete();
  }

  Future addTask(String todoId, Task task) async {
    final taskDoc = await _todoCollection.doc(todoId).get();
    _db.runTransaction((transaction) async {
      List<dynamic> tasks = taskDoc.data()['tasks'];
      if (tasks == null) tasks = [];
      tasks.add(task.toJson());
      transaction.update(taskDoc.reference, {'tasks': tasks});
    });
  }

  Future updateTask(String todoId, Task updatedTask) async {
    final taskDoc = await _todoCollection.doc(todoId).get();
    _db.runTransaction((transaction) async {
      List<dynamic> tasks = taskDoc.data()['tasks'];
      if (tasks == null) tasks = [];
      final int index = tasks.indexWhere(
          (task) => Task.fromJson(task, todoId).id == updatedTask.id);
      tasks[index] = updatedTask.toJson();
      bool allTaskCompleted = true;
      for (var task in tasks) {
        if (!Task.fromJson(task, todoId).isCompleted) {
          allTaskCompleted = false;
          break;
        }
      }
      transaction.update(taskDoc.reference, {
        if (allTaskCompleted) 'completed': true,
        'tasks': tasks,
      });
    });
  }

  Future deleteTask(String todoId, Task deletedTask) async {
    final taskDoc = await _todoCollection.doc(todoId).get();
    _db.runTransaction((transaction) async {
      List<dynamic> tasks = taskDoc.data()['tasks'];
      if (tasks != null) {
        if (tasks.isNotEmpty)
          tasks.removeWhere(
              (task) => Task.fromJson(task, todoId).id == deletedTask.id);
      } else
        tasks = [];
      transaction.update(taskDoc.reference, {'tasks': tasks});
    });
  }

  String get newTodoId => _todoCollection.doc().id;

  Future<void> createMyUser(MyUser user) async =>
      await _userCollection.doc(user.email).set({
        'email': user.email,
        'name': user.name,
      });

  static Future<MyUser> getMyUser(String email) async {
    final DocumentSnapshot userDoc = await _userCollection.doc(email).get();
    return MyUser(
      email: userDoc.data()['email'],
      name: userDoc.data()['name'],
    );
  }
}
