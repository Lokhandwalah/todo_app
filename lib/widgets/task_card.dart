import 'package:flutter/material.dart';

import '../models/todo.dart';

class TaskCardWidget extends StatelessWidget {
  final Todo todo;
  final String title;
  final String desc;
  final Function(Todo) onCheckBoxTapped;

  TaskCardWidget({
    @required this.title,
    @required this.desc,
    @required this.todo,
    @required this.onCheckBoxTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? "(Unnamed Task)",
                  style: TextStyle(
                    color: Color(0xFF211551),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                  value: todo.isDone,
                  onChanged: (val) {
                    onCheckBoxTapped(todo);
                  })
            ],
          ),
          if (desc?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Text(
                desc,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF86829D),
                  height: 1.5,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
