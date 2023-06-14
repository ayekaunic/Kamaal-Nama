import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamaal_nama/components/todo_tile.dart';
import 'package:kamaal_nama/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('tasks');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if first time ever create default data
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      // not the first time ever
      db.loadData();
    }

    super.initState();
  }

  // text controllor for adding tasks
  final _taskController = TextEditingController();

  // method for when checkbox is tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
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
                  db.toDoList.add([_taskController.text, false]);
                  _taskController.clear();
                });
                Navigator.of(context).pop();
                db.updateData();
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
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      floatingActionButton: FloatingActionButton.large(
        elevation: 6.3,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteMethod: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
