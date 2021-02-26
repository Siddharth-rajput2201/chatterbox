import 'package:chatterbox/Screens/home_screen/homescreen_helper.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  User _currentUser;
  final FirebaseRepository _repository = FirebaseRepository();
  @override
  void initState() {
    _currentUser = _repository.getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalColorVariables.blackColor,
        title: Text("Profile"),
      ),
      body: Builder(
        builder: (context)=>
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          maxRadius: 80,
                          backgroundColor: Colors.grey,
                          backgroundImage: _currentUser.photoURL == null ? AssetImage('assets/images/NouserImage.png'):
                          NetworkImage(_currentUser.photoURL) ,
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan[400],
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt,
                                color: Colors.white,),
                              onPressed: (){
                                  Provider.of<ProfileScreenUtils>(context,listen: false).photoSelectionBottomWidget(context);
                              },
                            ),
                          ),
                        ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right : 15.0,left: 10),
                        child: Icon(Icons.account_circle,size: 45,),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Username"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 8.0),
                              child: GetUserNameStream(_currentUser.uid),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right : 10.0),
                        child: IconButton(icon: Icon(Icons.edit,size: 30,color: Colors.cyan[300]),onPressed: (){}, ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(color: Colors.white,),
            ),
                 Container(
                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left : 10.0,right: 15.0),
                        child: Icon(Icons.email,size: 45,),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Email"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 10.0),
                              child: Text(_currentUser.email),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
