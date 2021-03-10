import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository
{
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  User getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<User> signInWithGoogle(context) => _firebaseMethods.signInWithGoogle(context);
  Future<User> signUpWithGoogle(context) => _firebaseMethods.signUpWithGoogle(context);
  Future<bool> authenticateUser(User user) => _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);
  Future<void> signOutUser() =>_firebaseMethods.signOutUser();
  Future<bool> checkCurrentUserID() => _firebaseMethods.checkCurrentUserId();
  Future<User> signUpWithEmailAndPassword(signUpEmail, signUpPassword, context) =>_firebaseMethods.signUpWithEmailAndPassword(signUpEmail, signUpPassword, context);
  Future<User> signInWithEmailAndPassword(signInEmail, signInPassword, context) =>_firebaseMethods.signInWithEmailAndPassword(signInEmail, signInPassword, context);
  Future<void> forgetPassword(email,context) => _firebaseMethods.forgetPassword(email,context);
  Future<void> sendEmailVerification(currentUser , context) => _firebaseMethods.sendEmailVerification(currentUser, context);
  Future<void> updateEmailVerificationStatus(bool status,String documentID )=>_firebaseMethods.updateEmailVerificationStatus(status, documentID);
}
