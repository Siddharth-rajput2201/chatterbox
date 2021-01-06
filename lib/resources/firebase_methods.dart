import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/utils/utilitizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods
{
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
    catch(error)
    {
      print(error);
    }
  }

  Future<bool> checkCurrentUserId() async
  {
    User currentUser;
    currentUser = _auth.currentUser;
    if(currentUser.uid != null)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  Future<User> signInWithGoogle() async
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
    catch(error)
    {
      print(error);
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
    catch(error){
      print(error);
    }
  }

  Future<void> addDataToDb(User user) async{
    String username = Utils.getUsername(user.email);
    modelUser = ModelUser(user.uid, user.displayName, user.email, username, null, null, user.photoURL);
    firebaseFirestore.collection("users").doc(user.uid).set(modelUser.toMap(modelUser));
  }

  Future<void> signOutUser() async {
  //  User user = await getCurrentUser();
    try {
      if (await _googleSignIn.isSignedIn() == false) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      return await _auth.signOut();
    }
    catch(error)
    {
      print(error);
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
}