// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_import, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'addscreen.dart';
import 'task.dart';

class TaskScreen extends StatefulWidget {
  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  Future<void> initializeHive() async {
    taskBox = await Hive.openBox<Task>('tasks');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: GoogleFonts.lobster(
            fontSize: 28,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade500, Colors.blueAccent.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 12,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 150,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No tasks here yet!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddEditTaskScreen(taskBox: taskBox)),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.teal,
                      elevation: 8,
                    ),
                    child: Text(
                      'Add Your First Task',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    task.isCompleted = !task.isCompleted;
                    task.save();
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: task!.isCompleted
                          ? [Colors.green.shade300, Colors.green.shade600]
                          : [Colors.white, Colors.blueGrey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: Offset(-3, -3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        task.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: task.isCompleted
                            ? Colors.white
                            : Colors.blue.shade400,
                        size: 30,
                        key: ValueKey(task.isCompleted),
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: task.isCompleted
                            ? Colors.white70
                            : Colors.grey.shade600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditTaskScreen(
                                  task: task, taskBox: taskBox),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AddEditTaskScreen(taskBox: taskBox)),
        ),
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.pinkAccent,
        elevation: 15,
      ),
    );
  }

  void deleteTask(int index) {
    final deletedTask = taskBox.getAt(index);
    taskBox.deleteAt(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task deleted successfully!'),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            if (deletedTask != null) {
              taskBox.add(deletedTask);
            }
          },
        ),
      ),
    );
  }
}
