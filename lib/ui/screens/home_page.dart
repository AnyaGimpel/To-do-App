import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/screens/add_task_page.dart';
import 'package:todo_app/ui/screens/login_page.dart';
import 'package:todo_app/ui/widgets/task_card.dart';
import 'package:todo_app/ui/widgets/sort_filter_section.dart';

/// HomePage widget where the main task list and filtering options are displayed
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load tasks when the page is built
    context.read<TaskCubit>().loadTasksForBothLists();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        automaticallyImplyLeading: false, 
        actions: [
          // Logout button to sign out the user
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              try {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();
                // Navigate to the login page after sign out
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                // Show error message in case of any error during sign out
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800), 
            child: Column(
              children: [
                const FilterSortSection(), // Section to filter and sort tasks
                Expanded(
                  child: BlocBuilder<TaskCubit, TaskState>( // Listen to task state
                    builder: (context, state) {
                      // When tasks are loaded successfully
                      if (state is TaskDualLoaded) {
                        final completedTasks = state.completedTasks;
                        final incompleteTasks = state.incompleteTasks;
                        final filter = state.currentFilter;
                        final sort = state.currentSort;

                        // Sorting tasks based on the selected sorting option
                        if (sort == 'Due date') {
                          completedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                          incompleteTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                        } else if (sort == 'Title') {
                          completedTasks.sort((a, b) => a.title.compareTo(b.title));
                          incompleteTasks.sort((a, b) => a.title.compareTo(b.title));
                        }

                        // Display tasks based on the selected filter
                        if (filter == 'All') {
                          return ListView(
                            children: [
                              _buildTaskSection('To-do', incompleteTasks), // Incomplete tasks section
                              const SizedBox(height: 16),
                              _buildTaskSection('Done', completedTasks), // Completed tasks section
                            ],
                          );
                        } else if (filter == 'To-do') {
                          return ListView(
                            children: [
                              _buildTaskSection('To-do', incompleteTasks), // Only incomplete tasks
                            ],
                          );
                        } else if (filter == 'Done') {
                          return ListView(
                            children: [
                              _buildTaskSection('Done', completedTasks), // Only completed tasks
                            ],
                          );
                        }
                      } else if (state is TaskError) {
                        // Show error message if there is an error loading tasks
                        return Center(child: Text(state.message));
                      }

                      // Show loading message while waiting for tasks to load
                      return const Center(child: Text('Please wait...'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Floating action button to add a new task
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

  /// Helper method to build task section with a title and a list of tasks
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
        // If there are no tasks, show a message
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No tasks available.'),
          )
        else
          // If tasks are available, display them in a list
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Prevent scrolling for individual sections
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task); // Display individual task in a card
            },
          ),
      ],
    );
  }
}
