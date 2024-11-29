import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_adapter.dart';
import 'task_screen.dart';
import 'task.dart';

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
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade200,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 5,
          backgroundColor: Colors.teal.shade300,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          elevation: 10,
          splashColor: Colors.tealAccent,
        ),
      ),
      home: TaskScreen(), // Navigate to the TaskScreen widget
    );
  }
}
