// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/todo.dart';

class DatabaseService {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('Todos');

  Future addTodo(String title) async {
    try {
      return await _todosCollection.add({
        'title': title,
        'isDone': false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future doneTodo(uid) async {
    try {
      await _todosCollection.doc(uid).update({
        'isDone': !(await _todosCollection
            .doc(uid)
            .get()
            .then((doc) => doc['isDone'])),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateTodo(uid, String text) async {
    try {
      await _todosCollection.doc(uid).update({
        'title': text,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteTodo(uid) async {
    try {
      await _todosCollection.doc(uid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs
          .map((doc) {
            return Todo(
              id: doc.id,
              title: doc['title'],
              isDone: doc['isDone'],
            );
          })
          .toList()
          .reversed
          .toList();
    } else {
      return [];
    }
  }

  Stream<List<Todo>> listTodos() {
    return _todosCollection.snapshots().map(todoFromFirestore);
  }
}
