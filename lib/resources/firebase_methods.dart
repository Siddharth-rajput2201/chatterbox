import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:chatterbox/utils/utilitizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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


  Future<User> signUpWithGoogle(BuildContext context) async
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
      UserCredential _userCredential = await _auth.signInWithCredential(credential);
      User user = _userCredential.user;
      await addDataToDb(user);
      print(user.uid);
      return user;
    }



    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    catch (error) {
      switch(error.code)
      {
        case 'network_error':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "CHECK YOUR INTERNET CONNECTIVITY");
          break;
      }
      return Future.value(null);
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

      UserCredential _userCredential = await _auth.signInWithCredential(credential);
      User user = _userCredential.user;
      print(user.uid);
      return user;
    }



    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "SIGNUP/LOGIN FAILED");
      }
      return Future.value(null);
    }

    catch (error) {
      switch(error.code)
      {
        case 'network_error':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "CHECK YOUR INTERNET CONNECTIVITY");
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
        user.photoURL,
        user.emailVerified,
    );
    firebaseFirestore.collection("users").doc(user.uid).set(
        modelUser.toMap(modelUser));
  }

  Future <void> getDataFromDB (User user) async {

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
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }
    catch (error) {
      print(error.code);
        switch (error.code)
        {
          case 'invalid-email':
            Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "INVALID EMAIL");
            break;
          case 'email-already-in-use':
            Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EMAIL ALREADY IN USE ! PLEASE LOGIN IN");
            break;
          case 'operation-not-allowed':
            Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "AN ERROR OCCURED!PLEASE TRY AGAIN LATER");
            break;
          case 'network-request-failed':
            Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
            break;
          case 'unknown':
            Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "ERROR");
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
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EITHER THE EMAIL OR PASSWORD IS INCORRECT");
          break;

        case 'too-many-requests':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;

        case 'unknown':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "ERROR");
          break;

        case 'invalid-email':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "INVALID EMAIL");
          break;

        case 'email-already-in-use':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EMAIL ALREADY IN USE ! PLEASE LOGIN IN");
          break;

        case 'operation-not-allowed':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "AN ERROR OCCURED!PLEASE TRY AGAIN LATER");
          break;

        case 'user-not-found':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;

        case 'network-request-failed':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
      }
      return Future.value(null);
    }
  }

  Future<void> forgetPassword(String email,BuildContext context) async
  {
    try {
       await _auth.sendPasswordResetEmail(email: email);
       Provider.of<ErrorDisplayWidget>(context,listen:false).showProgressSnackbar(context,"PASSWORD RESET LINK SENT PLEASE CHECK YOUR EMAIL!");
    }
    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }
    catch(error)
    {
      switch(error.code){
        case 'user-not-found':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;
        case 'network-request-failed':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
        case 'unknown':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "ERROR");
          break;
        case 'invalid-email':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "INVALID EMAIL");
          break;
        case 'too-many-requests':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;
      }
    }
  }

  Future<void> sendEmailVerification(User currentUser , BuildContext context) async
  {
    try {
      await currentUser.sendEmailVerification();
      Provider.of<ErrorDisplayWidget>(context,listen:false).showProgressSnackbar(context, "EMAIL VERIFICATION SENT! PLEASE CHECK YOUR EMAIL");
    }
    on PlatformException catch (PlatformError)
    {
      print(PlatformError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }

    on NoSuchMethodError catch (noSuchMethodError)
    {
      print(noSuchMethodError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PASSWORD RESET REQUEST FAILED");
      }
      return Future.value(null);
    }
    catch(error)
    {
      switch(error.code)
      {
        case 'user-not-found':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "EMAIL NOT FOUND");
          break;
        case 'network-request-failed':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PLEASE CHECK YOUR INTERNET CONNECTION");
          break;
        case 'unknown':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "ERROR");
          break;
        case 'invalid-email':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "INVALID EMAIL");
          break;
        case 'too-many-requests':
          Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "TOO MANY ATTEMPTS TRY AGAIN LATER");
          break;
      }
    }
  }

  Widget uploadImageBox(BuildContext context,)
  {
    return StreamBuilder<UploadTask>(
      builder: (_,snapshot){
        var event = snapshot?.data?.snapshot;
        double progressPercent = event != null
            ? event.bytesTransferred / event.totalBytes
            : 0;
        return Column(

          children: [
            // Progress bar
            LinearProgressIndicator(value: progressPercent),
            Text(
                '${(progressPercent * 100).toStringAsFixed(2)} % '
            ),
          ],
        );
      },
    );
  }


  UploadTask imageUploadTask;
  Future uploadUserImage(BuildContext context) async{
      try{
        Reference imageReference = FirebaseStorage.instance.ref().child('${Provider.of<ProfileScreenUtils>(context,listen: false).getUserImage.path}/${TimeOfDay.now()}');

        imageUploadTask = imageReference.putFile(Provider.of<ProfileScreenUtils>(context,listen: false).getCroppedUserImage);
        if(Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference!=null)
        {
          deleteUserImage(context);
        }
        imageUploadTask.snapshotEvents.listen((snapshot) {
          print('Task state: ${snapshot.state}');
          print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
          }, onError: (e) {

          // The final snapshot is also available on the task via `.snapshot`,
          // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
          print(imageUploadTask.snapshot);
          if (e.code == 'permission-denied') {
            print('User does not have permission to upload to this reference.');
          }
        });
        try {
          await imageUploadTask;
          print('Upload complete.');
        } on FirebaseException catch (e) {
          if (e.code == 'permission-denied') {
            print('User does not have permission to upload to this reference.');
          }
          // ...
        }

        // await imageUploadTask.whenComplete((){
        //   // Navigator.of(context).pop();
        // });

        Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference = 'gs://'+imageReference.bucket+'/'+imageReference.fullPath;
        print(Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference);
        imageReference.getDownloadURL().then((url) {
          Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl = url.toString();
          print('the user profile url => ${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}');
          updateUserProfileUrl(context);
          updateProfilePhoto(_auth.currentUser.uid, context);
          notifyListeners();
        });
      }
      catch(error)
    {
      Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context,"PROFILE IMAGE UPLOAD ERROR");
    }

  }





  // Widget uploadProgressIndicator(BuildContext context)
  // {
  //   UploadTask task = Provider.of<FirebaseMethods>(context).imageUploadTask;
  //   if(task!=null)
  //     {
  //       task.snapshotEvents.listen((snapshot) {
  //         print('Task state: ${snapshot.state}');
  //         print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  //
  //       return LinearProgressIndicator(
  //         value: (snapshot.bytesTransferred / snapshot.totalBytes) * 100,
  //       );
  //       });
  //       // return StreamBuilder (
  //       //   stream: task.snapshotEvents.listen((Snapshot) {}),
  //       //   builder: (context,snapshot){
  //       //     var event = snapshot?.data?.snapshot;
  //       //     double progressPercent = event != null
  //       //         ? event.bytesTransferred / event.totalBytes
  //       //         : 0;
  //       //     return Column(
  //       //       children: [
  //       //         // Progress bar
  //       //         LinearProgressIndicator(value: progressPercent),
  //       //         Text(
  //       //             '${(progressPercent * 100).toStringAsFixed(2)} % '
  //       //         ),
  //       //       ],
  //       //     );
  //       //   },
  //       // );
  //     }
  //   else{
  //     return Container();
  //   }
  //
  // }

  Future<void> cancelUpload(UploadTask task) async
  {
    if(task != null)
      {
        bool cancelled = await task.cancel();

        print('cancelled, $cancelled');
      }

  }

  Future deleteUserImage(BuildContext context) async {
    try{
      if('${Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference}'!=null)
      {
        await FirebaseStorage.instance.refFromURL('${Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference}').delete();
        Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference = null;
      }
    }
   catch(error)
    {
      Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "NO USER PROFILE PHOTO FOUND");
    }
  }


  void updateUserProfileUrl(BuildContext context)
  {
    try{
      var user = _auth.currentUser;
      user.updateProfile(displayName: user.displayName , photoURL: '${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}').then((_) {
        Navigator.pop(context);
        Navigator.pop(context);
        Provider.of<ErrorDisplayWidget>(context,listen:false).showProgressSnackbar(context, "PROFILE IMAGE UPDATED");
        //showProgressSnackbar(context, "UPLOAD SUCCESSFUL");
      });
    }
    catch(error)
    {
      Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "PROFILE IMAGE UPLOAD FAILED");
    }

  }

  Future<void> removeUserPhotoUrl(BuildContext context) async
  {
    try{
      var user = _auth.currentUser;
      DocumentReference users = FirebaseFirestore.instance.collection('users').doc(user.uid);
      users.update({'profilePhoto':'https://firebasestorage.googleapis.com/v0/b/chatterbox-9ed41.appspot.com/o/data%2Fuser%2F0%2Fcom.example.chatterbox%2Fcache%2FNouserImage.png?alt=media&token=b6c69a75-6f82-41b1-b9f5-df895cd9a20c'}).then((_){
        Navigator.pop(context);
      });
      await deleteUserImage(context);
      notifyListeners();
    }
    catch(error)
    {
      Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "NO USER IMAGE FOUND");
    }

  }



  Future<void>updateProfilePhoto(String documentId,BuildContext context)
  {
    try{
      DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
      return users.update({'profilePhoto': '${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}'});
    }
   catch(error)
    {
     return Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context,"PROFILE PHOTO UPDATE ERROR ! CODE:503");
    }
  }

  Future<void>updateUserName(String documentId,BuildContext context,String userName)
  {
    try{
      DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
      return users.update({'username': '$userName'}).then((_){
        Navigator.pop(context);
        Provider.of<ErrorDisplayWidget>(context,listen:false).showProgressSnackbar(context, "USERNAME UPDATED SUCCESSFULLY");
      });
    }
    catch(error)
    {
     return Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "USERNAME UPDATE FAILED");
    }

  }
  
  Future<void>updateEmailVerificationStatus(bool status,String documentID)
  {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentID);
    return users.update({'emailVerified': status});
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
