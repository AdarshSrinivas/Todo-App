import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/todo.dart';


Future getDisplayName() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  return user;
}

Future getuserId() async {
  return FirebaseAuth.instance.currentUser!.uid;
}
class DbService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String userId;

  DbService(this.userId);
  

  Future<QuerySnapshot> loadTodo () {
    final docs = db.collection('users').doc(userId).collection('todo').get();
    return docs;
  }

  Future<QuerySnapshot> getAllTodo(int index) {
    final docs = db.collection('users').doc(userId).collection('todo').doc('todo$index').collection('item').get();
    return docs;
  }

  void deletedSelected(int i) {
    print('deleted selected');
    final path = db.collection('users').doc(userId);
    path.collection('todo').doc('todo$i').delete();
  }

  void deleteAll () {
    print('delete');
    final path = db.collection('users').doc(userId);
    path.collection('todo').get().then((docs){docs.docs.forEach((element){
      element.reference.collection('item').get().then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      element.reference.delete();
    });
    });
  }

  void saveData(List<Todo> todos) {
    final path = db.collection('users').doc(userId);
    path.update({
      'todo_count':todos.length
    });

    for(int i=0; i<todos.length;i++){
      path.collection('todo').doc('todo$i').set({
        'cardColor': todos[i].color,
        'title': todos[i].title,
        'description': todos[i].description,
        'items': todos[i].items.length,
        'items_done':todos[i].isDone,
      });

      for (int j=0;j<todos[i].items.length;j++){
        path.collection('todo').doc('todo$i').collection('item').doc('item$j').set({
          'item_name': todos[i].items[j].itemName,
          'done' : todos[i].items[j].done,
        });
      }
    }
  }

}
