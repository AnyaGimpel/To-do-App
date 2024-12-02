import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget{
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('dd.MM.yy, HH:mm').format(task.dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              context.read<TaskCubit>().updateTaskCompletion(task.id, value);
            }
          },
        ),
        title: Text(task.title),
        subtitle: Text(formattedDate),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),  
          onPressed: () {
            context.read<TaskCubit>().deleteTask(task.id);
          },
        ),
      ),
    );
  }
}