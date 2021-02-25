import 'dart:async';
import 'package:chatterbox/Screens/home_screen/homescreen_helper.dart';
import 'package:chatterbox/Screens/profile_screen/profile_screen.dart';
import 'package:chatterbox/Screens/Setting/SettingPage.dart';
import 'package:chatterbox/pageview/ChatScreen/chatlist_screen.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:chatterbox/utils/utilitizes.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class UserCircle extends StatelessWidget {

  final String text;

  const UserCircle({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration:  BoxDecoration(
          borderRadius:  BorderRadius.circular(50),
          color: UniversalColorVariables.separatorColor
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalColorVariables.lightBlueColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: UniversalColorVariables.blackColor,
                  width: 2,
                ),
                color: UniversalColorVariables.onlineDotColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseRepository _repository = FirebaseRepository();
  User _currentUser;
  Timer _timer;
  bool _isemailverified ;
  bool _displayEmailVerificationSendButton = true;
  PageController pageController;
  int _page = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String intials;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      checkVerification();
    });
    super.initState();
    setState(() {
      _currentUser = _repository.getCurrentUser();
      intials = Utils.getInitials(_currentUser.displayName,_currentUser.email);
    });
    pageController = PageController();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    _currentUser = _repository.getCurrentUser();
    return  homePage(_width);
  }


  buildProfileDrawer() {
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
                  _currentUser.photoURL==null?UserCircle(text: intials,):
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 60,
                      maxWidth: 60,
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              _currentUser.photoURL),
                        ),
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
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: Text("EMAIL : "+_currentUser.email),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: GetUserName(_currentUser.uid),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          RaisedButton(child: Text("SIGNOUT"),onPressed: ()
          => signOutUser()
            //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
          ),
          RaisedButton(child: Text("SETTING"),onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage()));
          }
          ),
        ],
      ),
    );

  }


  Widget homePage(double _width)
  {
    try {
      if (_isemailverified) {
        return chatScreen();
      }
      else if(!_isemailverified) {
        return verifyScreen(_width);
      }
      else
        {
          return waiting();
        }
    }
    catch(error)
    {
      return waiting();
    }
  }

  Widget chatScreen() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          key: _key,
          drawer: buildProfileDrawer(),
          appBar: AppBar(
            backgroundColor:  UniversalColorVariables.blackColor,
            elevation: 0,
            title:_currentUser.photoURL==null?UserCircle(text: intials,):
            Container(
              constraints: BoxConstraints(
                maxHeight: 40,
                maxWidth: 40,
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        _currentUser.photoURL),
                  ),
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
                  )
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.notifications,
                color: Colors.white,),
              onPressed: (){
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search,
                  color: Colors.white,),
                onPressed: (){
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert,
                  color: Colors.white,),
                onPressed: (){
                  _key.currentState.openDrawer();
                },
              ),
            ],
            centerTitle: true,
          ),
          body: PageView(
            children: [
              Center(child: Text("SOCIAL")),
              Center(child: ChatListScreen(),),
              Center(child: Text("CALLS LOG"),),
              Center(child: Text("CONTACTS"),),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: Container(
            child: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                    color: (_page == 0)?Colors.lightBlue:Colors.grey,),
                  label: "HOME",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 1)?Colors.lightBlue:Colors.grey,),
                  label: "CHATS",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 2)?Colors.lightBlue:Colors.grey,),
                  label: "CALLS",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 3)?Colors.lightBlue:Colors.grey,),
                  label: "CONTACTS",
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }

  Widget verifyScreen(double _width)
  {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Builder(
            builder: (context)=>
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("VERIFICATION",style: TextStyle(fontSize: 30),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          margin: EdgeInsets.only(top:20),
                          decoration: BoxDecoration(
                              color:Colors.grey[800],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("PLEASE VERIFY YOUR EMAIL : \n ${_currentUser.email}",style: TextStyle(fontSize: 20),),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap:()=>{
                                      signOutUser()
                                      //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom : 15.0),
                                      child: Container(
                                        width: _width*0.30,
                                        decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.cyan[800],
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text("LOG OUT"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _displayEmailVerificationSendButton ? GestureDetector(
                                    onTap:()=>{
                                      verifyEmail(_currentUser, context)
                                      //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom : 15.0),
                                      child: Container(
                                        width: _width*0.30,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.orange[600],
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text("SEND"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):CircularProgressIndicator(),
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }


  Widget waiting()
  {
    return Center(child: CircularProgressIndicator());
  }

  void onPageChanged(int page)
  {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page)
  {
    pageController.jumpToPage(page);
  }

  Future<void> checkVerification() async
  {
      await _currentUser.reload();
      if (_currentUser.emailVerified) {
        setState(() {
          _isemailverified = true;
        });
        _timer.cancel();
      }
      else {
        setState(() {
          _isemailverified = false;
        });
      }

  }
  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }

  Future<void> verifyEmail( User _currentUser , BuildContext context ) async
  {
    setState(() {
      _displayEmailVerificationSendButton = false;
    });
    await _repository.sendEmailVerification(_currentUser, context);
    setState(() {
      _displayEmailVerificationSendButton = true;
    });
  }

  Future<bool> _onBackPressed()
  {
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("DO YOU REALLY WANT TO EXIT THE APP"),
        actions: <Widget>[
          FlatButton(
            child: Text("NO"),
            onPressed: ()=>Navigator.pop(context,false),
          ),
          FlatButton(
            child: Text("YES"),
            onPressed: ()=>SystemNavigator.pop(),
          ),
        ],
      )
    );
  }
}