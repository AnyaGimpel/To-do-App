import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/screens/add_task_page.dart';
import 'package:todo_app/ui/screens/login_page.dart';
import 'package:todo_app/ui/widgets/task_card.dart';
import 'package:todo_app/ui/widgets/sort_filter_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskCubit>().loadTasksForBothLists();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final navigator = Navigator.of(context);
            try {
              await FirebaseAuth.instance.signOut();
              navigator.pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
        ),
      ),
      
      body: Column(
        children: [
          const FilterSortSection(),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskDualLoaded) {
                  final completedTasks = state.completedTasks;
                  final incompleteTasks = state.incompleteTasks;
                  final filter = state.currentFilter;
                  final sort = state.currentSort;

                  if (sort == 'Due date') {
                    completedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                    incompleteTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                  } else if (sort == 'Title') {
                    completedTasks.sort((a, b) => a.title.compareTo(b.title));
                    incompleteTasks.sort((a, b) => a.title.compareTo(b.title));
                  }

                  if (filter == 'All') {
                    return ListView(
                      children: [
                        _buildTaskSection('To-do', incompleteTasks),
                        const SizedBox(height: 16),
                        _buildTaskSection('Done', completedTasks),
                      ],
                    );
                  } else if (filter == 'To-do') {
                    return ListView(
                      children: [
                        _buildTaskSection('To-do', incompleteTasks),
                      ],
                    );
                  } else if (filter == 'Done') {
                    return ListView(
                      children: [
                        _buildTaskSection('Done', completedTasks),
                      ],
                    );
                  }
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('Please wait...'));
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No tasks available.'),
          )
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task);
            },
          ),
      ],
    );
  }
}