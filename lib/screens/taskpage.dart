import 'package:flutter/material.dart';
import 'package:todo_app/api/firebase_api.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';

import '../widgets/task_card.dart';

class TodoPage extends StatefulWidget {
  final Todo todo;
  final FirebaseApi firebaseApi;
  TodoPage({
    @required this.todo,
    @required this.firebaseApi,
  });

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool _isNewTodo = false;
  String _todoId = "";
  String _todoTitle = "";
  String _todoDescription = "";
  List<Task> _tasks = [];

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  FirebaseApi _firebaseApi;

  @override
  void initState() {
    _firebaseApi = widget.firebaseApi;
    if (widget.todo != null) {
      // Set visibility to true
      _contentVisible = true;
      _tasks = widget.todo.tasks ?? [];
      _todoTitle = widget.todo.title;
      _todoDescription = widget.todo.description;
      _todoId = widget.todo.id;
    } else {
      _isNewTodo = true;
      _todoId = _firebaseApi.newTodoId;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        handleBack();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 24.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: handleBack,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/back_arrow_icon.png'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _titleFocus,
                              onChanged: (value) {
                                setState(() => _todoTitle = value);
                              },
                              onFieldSubmitted: (value) async {
                                if (value.isNotEmpty)
                                  _descriptionFocus.requestFocus();
                              },
                              initialValue: _todoTitle,
                              decoration: InputDecoration(
                                hintText: "Enter Task Title",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildDescription(),
                    ..._tasks.map(
                      (task) => Card(
                        child: ListTile(
                          title: Text(task.title),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (val) {
                              setState(() {
                                task.isCompleted = val;
                                _firebaseApi.updateTask(task.todoId, task);
                              });
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => setState(() {
                              _tasks.remove(task);
                              _firebaseApi.deleteTask(task.todoId, task);
                            }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            child: Icon(Icons.add),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                if (value.isNotEmpty) {
                                  Task _newTask = Task(
                                    title: value,
                                    id: _tasks.length,
                                    todoId: _todoId,
                                    isCompleted: false,
                                  );
                                  setState(() {
                                    _firebaseApi.addTask(_todoId, _newTask);
                                    _tasks.add(_newTask);
                                  });
                                  _todoFocus.requestFocus();
                                } else {
                                  print("Task doesn't exist");
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Add item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!_isNewTodo)
                          GestureDetector(
                            onTap: () async {
                              handleBack();
                            },
                            child: Card(
                              color: Colors.green,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  height: 50.0,
                                  width: 110,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        'Update',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  )),
                            ),
                          ),
                        GestureDetector(
                          onTap: () async {
                            if (_isNewTodo) {
                              if (_todoTitle.isNotEmpty)
                                _firebaseApi.createTodo(
                                  Todo(
                                    createdTime: DateTime.now(),
                                    title: _todoTitle,
                                    description: _todoDescription,
                                    id: _todoId,
                                    isDone: false,
                                    tasks: _tasks,
                                  ),
                                );
                            } else
                              _firebaseApi.deleteTodo(widget.todo);
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            color:
                                _isNewTodo ? Colors.green : Color(0xFFFE3577),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 50.0,
                              width: _isNewTodo ? 100 : 50,
                              child: _isNewTodo
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 5),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    )
                                  : Image(
                                      image: AssetImage(
                                        "assets/images/delete_icon.png",
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Container(
        child: TextFormField(
          focusNode: _descriptionFocus,
          onChanged: (value) => setState(() => _todoDescription = value),
          onFieldSubmitted: (value) {
            _todoFocus.requestFocus();
          },
          initialValue: _todoDescription,
          decoration: InputDecoration(
            hintText: "Enter Description for the task...",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
          ),
        ),
      ),
    );
  }

  bool shouldUpdate() {
    if (_todoTitle != widget.todo.title) return true;
    if (_todoDescription != widget.todo.description) return true;
    if (_tasks.length != widget.todo.tasks.length) return true;
    for (Task task in _tasks) {
      if (widget.todo.tasks.singleWhere((t) => t.id == task.id).isCompleted !=
          task.isCompleted) return true;
    }
    return false;
  }

  void handleBack() {
    if (shouldUpdate())
      _firebaseApi.updateTodo(
        Todo(
          createdTime: widget.todo.createdTime,
          id: _todoId,
          title: _todoTitle,
          description: _todoDescription,
          tasks: _tasks,
        ),
      );
    Navigator.of(context).pop();
  }
}
