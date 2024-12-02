import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TaskCubit extends Cubit<TaskState> {
  final TaskService _taskService;
  String _currentFilter = 'All'; 
  String _currentSort = 'Default';

  TaskCubit(this._taskService) : super(TaskInitial());

  Future<void> loadTasksForBothLists() async {
    emit(TaskLoading());
    try {
      final completedTasks = await _taskService.fetchTasks(isCompleted: true);
      final incompleteTasks = await _taskService.fetchTasks(isCompleted: false);
      emit(TaskDualLoaded(completedTasks, incompleteTasks, _currentFilter, _currentSort));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _taskService.updateTaskCompletion(taskId, isCompleted);

      final currentState = state;
      if (currentState is TaskDualLoaded) {
        final updatedCompletedTasks = List<Task>.from(currentState.completedTasks);
        final updatedIncompleteTasks = List<Task>.from(currentState.incompleteTasks);

        Task task;
        if (isCompleted) {
          task = updatedIncompleteTasks.firstWhere((task) => task.id == taskId);
          updatedIncompleteTasks.remove(task);
          task.isCompleted = isCompleted;
          updatedCompletedTasks.add(task);
        } else {
          task = updatedCompletedTasks.firstWhere((task) => task.id == taskId);
          updatedCompletedTasks.remove(task);
          task.isCompleted = isCompleted;
          updatedIncompleteTasks.add(task);
        }

        emit(TaskDualLoaded(updatedCompletedTasks, updatedIncompleteTasks, _currentFilter,_currentSort));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      final currentState = state;
      if (currentState is TaskDualLoaded) {
        final updatedCompletedTasks = currentState.completedTasks
            .where((task) => task.id != taskId)
            .toList();
        final updatedIncompleteTasks = currentState.incompleteTasks
            .where((task) => task.id != taskId)
            .toList();
        emit(TaskDualLoaded(updatedCompletedTasks, updatedIncompleteTasks, _currentFilter, _currentSort));
      }
    } catch (e) {
      emit(TaskError('Error deleting task: $e'));
    }
  }

  void updateTaskFilter(String filter) {
    _currentFilter = filter;
    print('Текущий фильтр в кубите $filter');

    final currentState = state;
    if (currentState is TaskDualLoaded) {
      emit(TaskDualLoaded(
        currentState.completedTasks,
        currentState.incompleteTasks,
        _currentFilter,
        _currentSort
      ));
    }
  }

  void updateTaskSort(String sort) {
    _currentSort = sort;
    print('Текущая сортировка в кубите $sort');

    final currentState = state;
    if (currentState is TaskDualLoaded) {
      emit(TaskDualLoaded(
        currentState.completedTasks,
        currentState.incompleteTasks,
        _currentFilter,
        _currentSort
      ));
    }
  }

  String get currentFilter => _currentFilter;
  String get currentSort => _currentSort;
}



abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}

class TaskDualLoaded extends TaskState {
  final List<Task> completedTasks;
  final List<Task> incompleteTasks;
  final String currentFilter; // Новое поле для фильтрации
  final String currentSort;

  TaskDualLoaded(this.completedTasks, this.incompleteTasks, this.currentFilter, this.currentSort);
}
