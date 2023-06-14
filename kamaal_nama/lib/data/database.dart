import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  // list of tasks
  List toDoList = [];

  // reference our box
  final _mybox = Hive.box('tasks');

  // method to be run if first time ever opening app
  void createInitialData() {
    toDoList = [
      ['Check the checkbox to mark a task completed', false],
      ['Swipe left to delete a task', false],
      ['Tap the floating button to add new tasks', false],
    ];
  }

  // load data from database
  void loadData() {
    toDoList = _mybox.get('TODOLIST');
  }

  // update database
  void updateData() {
    _mybox.put('TODOLIST', toDoList);
  }
}
