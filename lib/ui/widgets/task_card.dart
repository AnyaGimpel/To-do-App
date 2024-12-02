import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/screens/view_task.dart';

/// A widget that represents a card displaying task details with options to 
/// mark as completed, delete, or view the task in more detail.
class TaskCard extends StatelessWidget {
  final Task task;

  /// Constructor for [TaskCard] that takes a [Task] object to display.
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Formats the task's date and time into a human-readable string.
    String formattedDate = DateFormat('dd.MM.yy, HH:mm').format(task.dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),  
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              // Update task completion status when checkbox is changed
              context.read<TaskCubit>().updateTaskCompletion(task.id, value);
            }
          },
        ),
        title: Text(task.title),  
        subtitle: Text(formattedDate),  
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),  
          onPressed: () {
            // Delete task when delete button is pressed
            context.read<TaskCubit>().deleteTask(task.id);
          },
        ),
        onTap: () {
          // Navigate to task details page when the card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewTask(task: task),  // Pass task to the next screen
            ),
          );
        },
      ),
    );
  }
}
