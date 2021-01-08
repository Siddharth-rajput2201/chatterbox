import 'package:chatterbox/Screens/home_screen.dart';
import 'package:chatterbox/Screens/login_screen.dart';
//import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection("users").doc().set({
    //   "name":"The Noob"
    // });
    return MaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        // home:  FutureBuilder(
        //   future: _repository.getCurrentUser(),
        //   builder: (context,AsyncSnapshot<User> snapshot){
        //     if(snapshot.hasData)
        //       {
        //         return HomeScreen();
        //       }
        //     else
        //       {
        //         return LoginScreen();
        //       }
        //     },
        home: LandingPage());
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              //print("USER ID IF USER IS NOT NULL :  " + user.uid);
              return HomeScreen();
            } else {
              //print("USER ID IF THE USER IS NULL :  " + user.uid);
              return LoginScreen();
            }
      },
    );
  }
}

