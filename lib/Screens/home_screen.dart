import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:flutter/material.dart';
//import 'package:chatterbox/Screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Screen"),
            RaisedButton(child: Text("SIGNOUT"),onPressed: ()
            => signOutUser()
                //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
            )],
        ),
      ),
    );
  }

  Future<void> signOutUser() async
  {
    await _firebaseRepository.signOutUser();
  }

}
