import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/widgets/input_form_widget.dart';

class ViewTask extends StatelessWidget{
  final Task task; 

  const ViewTask({super.key, required this.task});

@override
  Widget build(BuildContext context) {

    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);
    DateTime? selectedDateTime = task.dateTime; 
    
    void onSave() {
      final updatedTask = Task(
        userId: FirebaseAuth.instance.currentUser!.uid,
        id: task.id,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: selectedDateTime ?? task.dateTime,
        isCompleted: task.isCompleted, 
      );

      context.read<TaskCubit>().updateTask(updatedTask);

      // После сохранения обновляем данные и возвращаемся на главную страницу
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  
    return InputFormWidget(
      titleController: titleController,
      descriptionController: descriptionController,
      selectedDateTime: selectedDateTime,
      onDateTimePicked: (dateTime) {
        selectedDateTime = dateTime; 
      },
      onSave: onSave,
      appBarTitle: 'View task', 
    );
  }
}