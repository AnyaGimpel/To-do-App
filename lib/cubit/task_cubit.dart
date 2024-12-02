import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing task-related state and logic.
class TaskCubit extends Cubit<TaskState> {
  /// Instance of TaskService for performing task-related operations.
  final TaskService _taskService;

  /// Current filter applied to the task list.
  String _currentFilter = 'All';

  /// Current sorting order applied to the task list.
  String _currentSort = 'Default';

  /// Constructor initializing the cubit with a TaskService instance.
  TaskCubit(this._taskService) : super(TaskInitial());

  /// Loads both completed and incomplete tasks and emits the result.
  Future<void> loadTasksForBothLists() async {
    emit(TaskLoading()); // Emitting loading state.
    try {
      final completedTasks = await _taskService.fetchTasks(isCompleted: true);
      final incompleteTasks = await _taskService.fetchTasks(isCompleted: false);
      emit(TaskDualLoaded(completedTasks, incompleteTasks, _currentFilter, _currentSort)); // Emitting loaded state.
    } catch (e) {
      emit(TaskError(e.toString())); // Emitting error state in case of failure.
    }
  }

  /// Updates the completion status of a task and updates the state accordingly.
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _taskService.updateTaskCompletion(taskId, isCompleted);

      final currentState = state;
      if (currentState is TaskDualLoaded) {
        // Making mutable copies of task lists.
        final updatedCompletedTasks = List<Task>.from(currentState.completedTasks);
        final updatedIncompleteTasks = List<Task>.from(currentState.incompleteTasks);

        Task task;
        if (isCompleted) {
          // Moving task from incomplete to completed list.
          task = updatedIncompleteTasks.firstWhere((task) => task.id == taskId);
          updatedIncompleteTasks.remove(task);
          task.isCompleted = isCompleted;
          updatedCompletedTasks.add(task);
        } else {
          // Moving task from completed to incomplete list.
          task = updatedCompletedTasks.firstWhere((task) => task.id == taskId);
          updatedCompletedTasks.remove(task);
          task.isCompleted = isCompleted;
          updatedIncompleteTasks.add(task);
        }

        // Emitting updated state.
        emit(TaskDualLoaded(updatedCompletedTasks, updatedIncompleteTasks, _currentFilter, _currentSort));
      }
    } catch (e) {
      emit(TaskError(e.toString())); // Emitting error state.
    }
  }

  /// Updates the details of a task and refreshes the state.
  Future<void> updateTask(Task updatedTask) async {
    try {
      await _taskService.updateTask(updatedTask);

      final currentState = state;
      if (currentState is TaskDualLoaded) {
        // Making mutable copies of task lists.
        final updatedCompletedTasks = List<Task>.from(currentState.completedTasks);
        final updatedIncompleteTasks = List<Task>.from(currentState.incompleteTasks);

        if (updatedTask.isCompleted) {
          // Updating task in completed list.
          final index = updatedCompletedTasks.indexWhere((task) => task.id == updatedTask.id);
          if (index != -1) {
            updatedCompletedTasks[index] = updatedTask;
          }
        } else {
          // Updating task in incomplete list.
          final index = updatedIncompleteTasks.indexWhere((task) => task.id == updatedTask.id);
          if (index != -1) {
            updatedIncompleteTasks[index] = updatedTask;
          }
        }

        // Emitting updated state.
        emit(TaskDualLoaded(updatedCompletedTasks, updatedIncompleteTasks, _currentFilter, _currentSort));
      }
    } catch (e) {
      emit(TaskError('Error updating task: $e')); // Emitting error state.
    }
  }

  /// Deletes a task by its ID and updates the state.
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      final currentState = state;
      if (currentState is TaskDualLoaded) {
        // Removing the task from respective lists.
        final updatedCompletedTasks = currentState.completedTasks
            .where((task) => task.id != taskId)
            .toList();
        final updatedIncompleteTasks = currentState.incompleteTasks
            .where((task) => task.id != taskId)
            .toList();
        emit(TaskDualLoaded(updatedCompletedTasks, updatedIncompleteTasks, _currentFilter, _currentSort)); // Emitting updated state.
      }
    } catch (e) {
      emit(TaskError('Error deleting task: $e')); // Emitting error state.
    }
  }

  /// Updates the task filter and emits a new state.
  void updateTaskFilter(String filter) {
    _currentFilter = filter;

    final currentState = state;
    if (currentState is TaskDualLoaded) {
      emit(TaskDualLoaded(
        currentState.completedTasks,
        currentState.incompleteTasks,
        _currentFilter,
        _currentSort,
      ));
    }
  }

  /// Updates the task sort order and emits a new state.
  void updateTaskSort(String sort) {
    _currentSort = sort;

    final currentState = state;
    if (currentState is TaskDualLoaded) {
      emit(TaskDualLoaded(
        currentState.completedTasks,
        currentState.incompleteTasks,
        _currentFilter,
        _currentSort,
      ));
    }
  }

  /// Getter for the current filter value.
  String get currentFilter => _currentFilter;

  /// Getter for the current sort value.
  String get currentSort => _currentSort;
}

/// Abstract class representing the state of TaskCubit.
abstract class TaskState {}

/// Initial state of TaskCubit.
class TaskInitial extends TaskState {}

/// State representing a loading process in TaskCubit.
class TaskLoading extends TaskState {}

/// State representing successfully loaded tasks.
class TaskLoaded extends TaskState {
  /// List of tasks loaded.
  final List<Task> tasks;

  /// Constructor for [TaskLoaded].
  TaskLoaded(this.tasks);
}

/// State representing an error in TaskCubit.
class TaskError extends TaskState {
  /// Error message.
  final String message;

  /// Constructor for [TaskError].
  TaskError(this.message);
}

/// State representing both completed and incomplete tasks.
class TaskDualLoaded extends TaskState {
  /// List of completed tasks.
  final List<Task> completedTasks;

  /// List of incomplete tasks.
  final List<Task> incompleteTasks;

  /// Current filter applied to the tasks.
  final String currentFilter;

  /// Current sort order applied to the tasks.
  final String currentSort;

  /// Constructor for [TaskDualLoaded].
  TaskDualLoaded(this.completedTasks, this.incompleteTasks, this.currentFilter, this.currentSort);
}
