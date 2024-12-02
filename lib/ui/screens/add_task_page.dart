import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/widgets/input_form_widget.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDateTime;

  final TaskService taskService = GetIt.instance<TaskService>();

  @override
  Widget build(BuildContext context) {
    return InputFormWidget(
      titleController: titleController,
      descriptionController: descriptionController,
      selectedDateTime: selectedDateTime,
      onDateTimePicked: (dateTime) {
        setState(() {
          selectedDateTime = dateTime;
        });
      },
      onSave: ()  {
        if (titleController.text.isEmpty || selectedDateTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill the fields')),
          );
          return;
        }

        final User? currentUser = FirebaseAuth.instance.currentUser;

        final newTask = Task(
          id: '', 
          userId: currentUser!.uid, 
          title: titleController.text,
          description: descriptionController.text,
          dateTime: selectedDateTime!,
          isCompleted: false,
        );

        try {
          taskService.addTask(newTask);
          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      appBarTitle: 'Add Task',
    );
  }
}
