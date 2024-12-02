import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/widgets/input_form_widget.dart';

/// ViewTask widget displays the task details and allows the user to edit and save changes.
class ViewTask extends StatelessWidget {
  final Task task;

  /// Constructor that accepts a Task object to display
  const ViewTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    // Controllers for the input fields, pre-populated with existing task details
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);
    
    // The initially selected date for the task
    DateTime? selectedDateTime = task.dateTime; 

    // Method to handle saving the task when the user clicks save
    void onSave() {
      // Check if the title is empty or if no date is selected
      if (titleController.text.isEmpty || selectedDateTime == null) {
        // Show an error if fields are not completed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill the fields')),
        );
        return;
      }

      // Create an updated task object with the new values
      final updatedTask = Task(
        userId: FirebaseAuth.instance.currentUser!.uid, 
        id: task.id, 
        title: titleController.text,
        description: descriptionController.text,
        dateTime: selectedDateTime ?? task.dateTime, 
        isCompleted: task.isCompleted, 
      );

      // Call the TaskCubit to update the task in the state
      context.read<TaskCubit>().updateTask(updatedTask);

      // Navigate back to the home page after saving the task
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }

    // Return the InputFormWidget, passing in necessary data and methods for editing the task
    return InputFormWidget(
      titleController: titleController,
      descriptionController: descriptionController,
      selectedDateTime: selectedDateTime,
      onDateTimePicked: (dateTime) {
        // Update the selectedDateTime when the user picks a date
        selectedDateTime = dateTime;
      },
      onSave: onSave, // Set the save callback
      appBarTitle: 'View task', 
    );
  }
}
