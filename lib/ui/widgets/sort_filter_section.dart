import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/task_cubit.dart';
import 'modal_bottom_sheet.dart'; 

/// A widget that provides options to filter and sort the tasks.
/// It allows users to filter tasks by status (All, To-do, Done) and sort tasks 
/// by different criteria (Default, Due date, Title).
class FilterSortSection extends StatelessWidget {
  const FilterSortSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filter button
              GestureDetector(
                onTap: () {
                  final currentFilter = context.read<TaskCubit>().currentFilter; 
                  final initialIndex = _mapFilterToIndex(currentFilter);

                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ModalBottomSheet(
                      title: 'Show tasks',
                      options: ['All', 'To-do', 'Done'],
                      initialSelectedIndex: initialIndex, 
                      onOptionSelected: (selectedIndex) {
                        final filter = _mapIndexToFilter(selectedIndex);
                        context.read<TaskCubit>().updateTaskFilter(filter);  
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Filter'),
                  ],
                ),
              ),
              // Sort button
              GestureDetector(
                onTap: () {
                  final currentSort = context.read<TaskCubit>().currentSort;
                  final initialSortIndex = _mapSortToIndex(currentSort);

                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ModalBottomSheet(
                        title: 'Sort by',
                        options: ['Default', 'Due date', 'Title'],
                        initialSelectedIndex: initialSortIndex,
                        onOptionSelected: (selectedIndex) {
                          final sort = _mapIndexToSort(selectedIndex);
                          context.read<TaskCubit>().updateTaskSort(sort);
                        },
                    )
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Sort'),
                  ],
                ),
              ),
            ],
          ),

          // Divider between filter/sort section and the content
          const Divider(
            color: Colors.grey, 
            thickness: 1, 
          ),
        ],
      ),
    );
  }

  /// Maps the selected index from the bottom sheet to a filter value.
  String _mapIndexToFilter(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'All';
      case 1:
        return 'To-do';
      case 2:
        return 'Done';
      default:
        return 'All';
    }
  }

  /// Maps the current filter value to an index for the bottom sheet.
  int _mapFilterToIndex(String filter) {
    switch (filter) {
      case 'All':
        return 0;
      case 'To-do':
        return 1;
      case 'Done':
        return 2;
      default:
        return 0;
    }
  }

  /// Maps the selected index from the bottom sheet to a sort value.
  int _mapSortToIndex(String sort) {
    switch (sort) {
      case 'Default':
        return 0;
      case 'Due date':
        return 1;
      case 'Title':
        return 2;
      default:
        return 0;
    }
  }

  /// Maps the selected index from the bottom sheet to a sort value.
  String _mapIndexToSort(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'Default';
      case 1:
        return 'Due date';
      case 2:
        return 'Title';
      default:
        return 'Default';
    }
  }
}
