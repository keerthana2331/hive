import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final Box<Task> taskBox;

  AddEditTaskScreen({this.task, required this.taskBox});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: GoogleFonts.poppins(fontSize: 28, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent.shade200, Colors.indigo.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade50, Colors.lightBlue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Hero(
                tag: 'taskIcon',
                child: Icon(
                  Icons.task_alt,
                  size: 100,
                  color: Colors.indigo.shade300,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: GoogleFonts.poppins(color: Colors.blueGrey.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: GoogleFonts.poppins(color: Colors.blueGrey.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.task == null) {
                      widget.taskBox.add(
                        Task(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          isCompleted: false,
                        ),
                      );
                    } else {
                      widget.task!.title = _titleController.text;
                      widget.task!.description = _descriptionController.text;
                      widget.task!.save();
                    }
                    Navigator.pop(context); // Close the screen after saving.
                  }
                },
                child: Text(
                  widget.task == null ? 'Create Task' : 'Save Changes',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  iconColor: Colors.deepPurpleAccent, // Updated to match gradient
                  disabledIconColor: Colors.white, // Text color
                  shadowColor: Colors.indigo.shade400,
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
