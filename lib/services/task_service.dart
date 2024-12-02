import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task.dart';

class TaskService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> fetchTasks({bool? isCompleted}) async {
  try {
    Query query = _firestore.collection('tasks');
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (isCompleted != null) {
      query = query.where('isCompleted', isEqualTo: isCompleted);
    }

    query = query.where('userId', isEqualTo: currentUser!.uid);

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    throw Exception('Error fetching tasks: $e');
  }
}


  Future<void> updateTaskCompletion (String id, bool isCompleted) async {
    try{
      await _firestore.collection('tasks').doc(id).update({'isCompleted': isCompleted,});
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  Future <void> addTask(Task task) async {
    await _firestore.collection('tasks').add({
      'userId': task.userId,
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime,
      'isCompleted': task.isCompleted,
    });
  }

  Future<void> updateTask(Task task) async {
  try {
    await _firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime,
    });
  } catch (e) {
    throw Exception('Error updating task: $e');
  }
}

  Future <void> deleteTask(String taskId) async {
    try{
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e){
      throw Exception('Error deleting task: $e');
    }
  } 
}