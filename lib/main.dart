import 'package:chatterbox/Screens/home_screen/home_screen.dart';
import 'package:chatterbox/Screens/landing_screen/landing_screen.dart';
import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: LandingPage()
      ),
      providers: [
        ChangeNotifierProvider(create: (_)=>FirebaseMethods()),
        ChangeNotifierProvider(create: (_)=>ProfileScreenUtils())
      ],
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
             // print("USER ID IF USER IS NOT NULL :  " + user.uid);
              return HomeScreen();
            }
            else {
              //print("USER ID IF THE USER IS NULL :  " + user.uid);
              return LoginScreen();
            }
      },
    );
  }
}

