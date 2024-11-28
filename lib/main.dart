import 'package:flutter/material.dart';
import 'package:hive_1/task_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_1/task_screen.dart';
import 'package:hive_1/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Hive.initFlutter(); // Initialize Hive for Flutter

  // Register the Hive adapter for the Task model
  Hive.registerAdapter(TaskAdapter());

  // Open the 'tasks' box
  await Hive.openBox<Task>('tasks');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskScreen(), // Navigate to the TaskScreen widget
    );
  }
}
