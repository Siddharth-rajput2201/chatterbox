import 'package:chatterbox/Screens/Setting/SettingPage.dart';
import 'package:chatterbox/Screens/home_screen/homescreen_helper.dart';
import 'package:chatterbox/Screens/profile_screen/profile_screen.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PageViewHelper extends ChangeNotifier
{
  final FirebaseRepository _repository = FirebaseRepository();
  Widget  buildProfileDrawer(BuildContext context, User currentUser) {
    return Drawer(
      child:  ListView(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage()));
            },
            child: DrawerHeader(
              child: Column(
                children: [
                  //_currentUser.photoURL==null?Image.asset('assets/images/NouserImage.png',height: 40,width: 40,):
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 60,
                      maxWidth: 60,
                    ),
                    child: Stack(
                      children: [
                        GetUserPhotoUrlStream(currentUser.uid),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: UniversalColorVariables.onlineDotColor,
                              border: Border.all(
                                color: UniversalColorVariables.blackColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: Text("EMAIL : "+currentUser.email),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: Row(
                          children: [
                            Text("USERNAME : "),
                            GetUserNameStream(currentUser.uid),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          ElevatedButton(child: Text("SIGNOUT"),onPressed: ()
          => signOutUser(),
            //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
          ),
          ElevatedButton(child: Text("SETTING"),onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage()));
          }
          ),
        ],
      ),
    );
  }
  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }
}