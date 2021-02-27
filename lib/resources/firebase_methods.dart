import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:chatterbox/utils/utilitizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class FirebaseMethods with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ModelUser modelUser;

  User getCurrentUser()
  {
    try {
      User currentUser;
      currentUser = _auth.currentUser;
      print(currentUser.uid);
      return currentUser;
    }
    catch (error) {
      print(error);
      return null;
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
      await addDataToDb(user);
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

  Future <void> getDataFromDB (User user) async {

  }

  String getUserName (User user) {
    String username;

    /*   Query  */

    return username;
  }

  // void authenticateUser(User user)
  // {
  //   _repository.authenticateUser(user).then((isNewUser)
  //   {
  //     if(isNewUser)
  //     {
  //       _repository.addDataToDb(user).then((value){
  //         Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)
  //         {
  //           return HomeScreen();
  //         }));
  //       });
  //       //SnackBar(content: Text("USER DOES NOT EXIST PLEASE SIGN UP"),);
  //     }
  //     else
  //     {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)
  //       {
  //         return LoginScreen();
  //       }));
  //     }
  //   }
  //   );
  // }
  //


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
      await addDataToDb(user);
      return Future.value(user);
    }
    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
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

  Future<void> forgetPassword(String email,BuildContext context) async
  {
    try {
       await _auth.sendPasswordResetEmail(email: email);
       showProgressSnackbar(context,"PASSWORD RESET LINK SENT PLEASE CHECK YOUR EMAIL!");
    }
    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }
    catch(error)
    {
      switch(error.code){
        case 'user-not-found':
          showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;
        case 'network-request-failed':
          showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
        case 'unknown':
          showErrorSnackbar(context, "ERROR");
          break;
        case 'invalid-email':
          showErrorSnackbar(context, "INVALID EMAIL");
          break;
        case 'too-many-requests':
          showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;
      }
    }
  }

  Future<void> sendEmailVerification(User currentUser , BuildContext context) async
  {
    try {
      await currentUser.sendEmailVerification();
      showProgressSnackbar(context, "EMAIL VERIFICATION SENT! PLEASE CHECK YOUR EMAIL");
    }
    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }
    catch(error)
    {
      switch(error.code)
      {
        case 'user-not-found':
          showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;
        case 'network-request-failed':
          showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
        case 'unknown':
          showErrorSnackbar(context, "ERROR");
          break;
        case 'invalid-email':
          showErrorSnackbar(context, "INVALID EMAIL");
          break;
        case 'too-many-requests':
          showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;
      }
    }
  }


  Future uploadUserImage(BuildContext context) async{

    UploadTask imageUploadTask;

    Reference imageReference = FirebaseStorage.instance.ref().child('userProfileImage/${Provider.of<ProfileScreenUtils>(context,listen: false).getUserImage.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(Provider.of<ProfileScreenUtils>(context,listen: false).getUserImage);
    await imageUploadTask.whenComplete((){
      print("UPLOADED");
      //Navigator.of(context).pop();
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl = url.toString();
      print('the user profile url => ${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}');

      updateUserProfileUrl(context);
      updateProfilePhoto(_auth.currentUser.uid, context);
      notifyListeners();

    });

  }

  void updateUserProfileUrl(BuildContext context)
  {
    var user = _auth.currentUser;
    user.updateProfile(displayName: user.displayName , photoURL: '${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}').then((value) {
      print("Upload Completed");
      //showProgressSnackbar(context, "UPLOAD SUCCESSFUL");
    }).catchError((onError){
      print("upload Failed");
      //showErrorSnackbar(context,"UPLOAD FAILED");
    });
  }

  Future<void>updateProfilePhoto(String documentId,BuildContext context)
  {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
    return users.update({'profilePhoto': '${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}'});
  }

  Future<void>updateUserName(String documentId,BuildContext context,String userName)
  {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
    return users.update({'user': '$userName'});
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
