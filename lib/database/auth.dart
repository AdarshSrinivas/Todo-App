import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> logIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Logged In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> createAccount(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential userCred = (await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password));
      User? user = userCred.user;
      user!.updateDisplayName(name);

      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'username': name,
        'todo_count' : 1,
      });

      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('todo').doc('todo0').set({
        'cardColor': '0xff00ffff',
        'title': 'Welcome to TODO.',
        'description': 'Swipe to dimiss todo, long press to add item and press to edit ToDo.',
        'items': 1,
        'items_done': 0,
      });
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('todo').doc('todo0').collection('item').doc('item0').set({
        'item_name': 'This is a Task in ToDo.',
        'done':false,
      });
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Reset Link Sent";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
