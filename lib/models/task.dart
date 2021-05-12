class Task {
  final String todoId;
  final int id;
  final String title;
  bool isCompleted;
  Task({this.isCompleted = false, this.id, this.todoId, this.title});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': isCompleted,
    };
  }

  static List<Task> getTaskList(List<dynamic> tasks, String todoId) {
    List<Task> transformedList = [];
    if (tasks == null) return transformedList;
    tasks.forEach((taskData) {
      transformedList.add(fromJson(taskData, todoId));
    });
    return transformedList;
  }

  static List<Map<String, dynamic>> covertTaskList(List<Task> tasks) {
    List<Map<String, dynamic>> transformedList = [];
    if (tasks == null) return transformedList;
    tasks.forEach((task) {
      transformedList.add(task.toJson());
    });
    return transformedList;
  }

  static Task fromJson(Map<String, dynamic> data, String todoId) {
    return Task(
      todoId: todoId,
      id: data['id'],
      title: data['title'],
      isCompleted: data['completed'],
    );
  }
}
