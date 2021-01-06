import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository
{
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<User> signInWithGoogle() => _firebaseMethods.signInWithGoogle();
  Future<bool> authenticateUser(User user) => _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);
  Future<void> signOutUser() =>_firebaseMethods.signOutUser();
  Future<bool> checkCurrentUserID() => _firebaseMethods.checkCurrentUserId();
}
