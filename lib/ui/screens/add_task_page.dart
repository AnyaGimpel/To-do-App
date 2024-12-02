import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/widgets/input_form_widget.dart';

/// AddTaskPage allows the user to add a new task to the list.
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskScreenState();
}

/// State class for AddTaskPage that handles the form logic for adding a new task.
class _AddTaskScreenState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController(); // Controller for title input
  final TextEditingController descriptionController = TextEditingController(); // Controller for description input
  DateTime? selectedDateTime; // Holds the selected date and time for the task

  final TaskService taskService = GetIt.instance<TaskService>(); // Get instance of TaskService using GetIt

  @override
  Widget build(BuildContext context) {
    // Builds the InputFormWidget that contains the task input fields
    return InputFormWidget(
      titleController: titleController,
      descriptionController: descriptionController,
      selectedDateTime: selectedDateTime,
      // Updates selectedDateTime when a date is picked
      onDateTimePicked: (dateTime) {
        setState(() {
          selectedDateTime = dateTime;
        });
      },
      // Defines the save behavior when the user clicks the save button
      onSave: () {
        // Validate that the title is not empty and a date is selected
        if (titleController.text.isEmpty || selectedDateTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill the fields')),
          );
          return;
        }

        // Get the current user from Firebase authentication
        final User? currentUser = FirebaseAuth.instance.currentUser;

        // Create a new Task object with the provided data
        final newTask = Task(
          id: '', 
          userId: currentUser!.uid, 
          title: titleController.text,
          description: descriptionController.text,
          dateTime: selectedDateTime!, 
          isCompleted: false, 
        );

        try {
          // Add the new task using TaskService
          taskService.addTask(newTask);
          // Navigate back to the HomePage after successful task addition
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } catch (e) {
          // Show an error message if task addition fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      appBarTitle: 'Add Task', 
    );
  }
}
