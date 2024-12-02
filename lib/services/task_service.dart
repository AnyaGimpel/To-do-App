import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task.dart';

/// Service class to handle task-related operations with Firestore.
class TaskService {
  /// Instance of FirebaseFirestore for interacting with Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches tasks from Firestore based on the completion status.
  ///
  /// [isCompleted] is an optional parameter. If provided, it filters the tasks 
  /// by their completion status. If `null`, all tasks are fetched regardless of 
  /// their completion status.
  /// 
  /// Returns a list of [Task] objects.
  Future<List<Task>> fetchTasks({bool? isCompleted}) async {
    try {
      // Reference to the 'tasks' collection.
      Query query = _firestore.collection('tasks');
      final User? currentUser = FirebaseAuth.instance.currentUser;

      // Apply completion status filter if provided.
      if (isCompleted != null) {
        query = query.where('isCompleted', isEqualTo: isCompleted);
      }

      // Filter tasks by the current user's ID.
      query = query.where('userId', isEqualTo: currentUser!.uid);

      final querySnapshot = await query.get();

      // Map Firestore documents to Task model and return as a list.
      return querySnapshot.docs
          .map((doc) => Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  /// Updates the completion status of a task.
  ///
  /// [id] is the ID of the task to be updated, and [isCompleted] is the new completion status.
  Future<void> updateTaskCompletion(String id, bool isCompleted) async {
    try {
      // Update the 'isCompleted' field of the task document in Firestore.
      await _firestore.collection('tasks').doc(id).update({'isCompleted': isCompleted});
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  /// Adds a new task to Firestore.
  ///
  /// [task] is the task object that will be added to the database.
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add({
      'userId': task.userId,
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime,
      'isCompleted': task.isCompleted,
    });
  }

  /// Updates an existing task in Firestore.
  ///
  /// [task] is the task object containing updated information.
  Future<void> updateTask(Task task) async {
    try {
      // Update task details in Firestore.
      await _firestore.collection('tasks').doc(task.id).update({
        'title': task.title,
        'description': task.description,
        'dateTime': task.dateTime,
      });
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  /// Deletes a task from Firestore.
  ///
  /// [taskId] is the ID of the task to be deleted.
  Future<void> deleteTask(String taskId) async {
    try {
      // Delete the task document from Firestore.
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
}
