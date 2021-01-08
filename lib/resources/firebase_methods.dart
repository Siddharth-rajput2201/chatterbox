import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:chatterbox/utils/utilitizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ModelUser modelUser;

  Future<User> getCurrentUser() async
  {
    try {
      User currentUser;
      currentUser = _auth.currentUser;
      print(currentUser.uid);
      return currentUser;
    }
    catch (error) {
      print(error);
      return Future.value(null);
    }
  }

  Future<bool> checkCurrentUserId() async
  {
    User currentUser;
    currentUser = _auth.currentUser;
    if (currentUser.uid != null) {
      return Future.value(true);
    }
    else {
      return Future.value(false);
    }
  }

  Future<User> signInWithGoogle(BuildContext context) async
  {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn
          .signIn(); // Calls box for email in google account
      GoogleSignInAuthentication _signInAuthentication = await _signInAccount
          .authentication; // authentication creadentials for google

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        // takes the required credentials
        idToken: _signInAuthentication.idToken,
      );
      UserCredential _userCredential = await _auth.signInWithCredential(
          credential);
      User user = _userCredential.user;
      print(user.uid);
      return user;
    }

    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    catch (error) {
      switch(error.code)
      {
        case 'network_error':
          showErrorSnackbar(context, "CHECK YOUR INTERNET CONNECTIVITY");
          break;
      }
      return Future.value(null);
    }
  }

  Future<bool> authenticateUser(User user) async
  {
    try {
      QuerySnapshot result = await firebaseFirestore
          .collection("users")
          .where("email", isEqualTo: user.email).get();
      final List<DocumentSnapshot> docs = result.docs;
      return docs.length == 0 ? true : false;
    }
    catch (error) {
      print(error);
      return Future.value(null);
    }
  }

  Future<void> addDataToDb(User user) async {
    String username = Utils.getUsername(user.email);
    modelUser = ModelUser(
        user.uid,
        user.displayName,
        user.email,
        username,
        null,
        null,
        user.photoURL);
    firebaseFirestore.collection("users").doc(user.uid).set(
        modelUser.toMap(modelUser));
  }

  Future<void> signOutUser() async {
    //  User user = await getCurrentUser();
    try {
      if (await _googleSignIn.isSignedIn() == true) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      }
      return await _auth.signOut();
    }
    catch (error) {
      print(error);
    }
  }

  Future<User> signUpWithEmailAndPassword(String signUpEmail,
      String signUpPassword, BuildContext context) async
  {
    try {
      UserCredential _signUpUser = await _auth.createUserWithEmailAndPassword(
          email: signUpEmail, password: signUpPassword);

      User user = _signUpUser.user;
      return Future.value(user);
    }
    catch (error) {
      print(error.code);
        switch (error.code)
        {
          case 'invalid-email':
            showErrorSnackbar(context, "INVALID EMAIL");
            break;
          case 'email-already-in-use':
            showErrorSnackbar(context, "EMAIL ALREADY IN USE ! PLEASE LOGIN IN");
            break;
          case 'operation-not-allowed':
            showErrorSnackbar(context, "AN ERROR OCCURED!PLEASE TRY AGAIN LATER");
            break;
          case 'network-request-failed':
            showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
            break;
          case 'unknown':
            showErrorSnackbar(context, "ERROR");
            break;
        }
        return Future.value(null);
    }
  }

  // Future<void> signInWithEmailAndPassword(String signInEmail,String signInPassword , BuildContext context) async
  // {
  //   print(signInEmail);
  //   print(signInPassword);
  // }


  Future<User> signInWithEmailAndPassword(String signInEmail,
      String signInPassword, BuildContext context) async
  {
    try {
      UserCredential _signInUser = await _auth.signInWithEmailAndPassword(
          email: signInEmail, password: signInPassword);

      User user = _signInUser.user;
      return Future.value(user);
    }
    catch (error) {
      print(error.code);
      switch (error.code)
      {
        case 'wrong-password':
          showErrorSnackbar(context, "EITHER THE EMAIL OR PASSWORD IS INCORRECT");
          break;

        case 'too-many-requests':
          showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;

        case 'unknown':
          showErrorSnackbar(context, "ERROR");
          break;

        case 'invalid-email':
          showErrorSnackbar(context, "INVALID EMAIL");
          break;

        case 'email-already-in-use':
          showErrorSnackbar(context, "EMAIL ALREADY IN USE ! PLEASE LOGIN IN");
          break;

        case 'operation-not-allowed':
          showErrorSnackbar(context, "AN ERROR OCCURED!PLEASE TRY AGAIN LATER");
          break;

        case 'user-not-found':
          showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;

        case 'network-request-failed':
          showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
      }
      return Future.value(null);
    }
  }

  Future<void> forgerPassword(String email,BuildContext context) async
  {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(error)
    {
      showErrorSnackbar(context, "ERROR");
    }
  }




}
  // print(user.providerData[1].providerId);
    // print(user.uid);
    // print(user.providerData[1].providerId);
    // if (user.providerData[1].providerId == 'google.com') {
    //   await _googleSignIn.disconnect();
    // }
    // await _auth.signOut();
    // if(await _googleSignIn.isSignedIn() == true)
    //   {
    //     print("true");
    //     await _googleSignIn.disconnect();
    //       await _googleSignIn.signOut();
    //       await _auth.signOut();
    //   }
    //    await _auth.signOut();
    //return Future.value(true);
