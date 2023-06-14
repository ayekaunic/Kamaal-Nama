import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamaal_nama/components/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllor for adding tasks
  final _taskController = TextEditingController();

  // list of tasks to do
  List toDoList = [
    ['task 1', false],
    ['task 2', false],
    ['task 3', false],
  ];

  // method for when checkbox is tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  // method to create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Add a new task'),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.red[300],
              child: const Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  toDoList.add([_taskController.text, false]);
                  _taskController.clear();
                });
                Navigator.of(context).pop();
              },
              color: Colors.green[300],
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  // method to delete task
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteMethod: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
