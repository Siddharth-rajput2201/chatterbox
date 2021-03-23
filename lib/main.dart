
import 'package:chatterbox/Screens/home_screen/home_screen.dart';
import 'package:chatterbox/Screens/landing_screen/landing_screen.dart';
import 'package:chatterbox/Screens/profile_screen/profilePhotoUpload_screen/profilePhotoUploadScreen_helper.dart';
import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/Screens/verifyEmailScreen/verifyEmail_screen.dart';
import 'package:chatterbox/pageview/UserPost/UserPostHelper.dart';
import 'package:chatterbox/pageview/pageview_helper.dart';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
//import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
          home: SafeArea(child: LandingPage())
      ),
      providers: [
        ChangeNotifierProvider(create: (_)=>FirebaseMethods()),
        ChangeNotifierProvider(create: (_)=>ProfileScreenUtils()),
        ChangeNotifierProvider(create: (_)=>ProfilePhotoUploadScreen()),
        ChangeNotifierProvider(create: (_)=>PageViewHelper()),
        ChangeNotifierProvider(create: (_)=>UserPostHelper()),
        ChangeNotifierProvider(create: (_)=>ErrorDisplayWidget())
      ],
    );
  }
}



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}
class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              if(!snapshot.data.emailVerified)
                {
                  return  VerifyEmailScreen();
                }
              else
                {
                  return HomeScreen();
                }
            }
            else if(snapshot.hasError)
              {
                return CircularProgressIndicator();
              }
            else {
              return LoginScreen();
            }
      },
    );
  }

// Widget homePage(double _width)
// {
//   try {
//     if (_isemailverified) {
//       return chatScreen();
//     }
//     else if(!_isemailverified) {
//       return verifyScreen(_width);
//     }
//     else
//       {
//         return waiting();
//       }
//   }
//   catch(error)
//   {
//     return waiting();
//   }
// }

}

