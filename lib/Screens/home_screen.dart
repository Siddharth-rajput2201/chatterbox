import 'dart:async';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:chatterbox/Screens/login_screen.dart';

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
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (_timer) {
      checkVerification();
    });
    super.initState();
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
          body: PageView(
            children: [
              Center(child: Column(
                children: [
                  Text("Chat List Screen"),
                  RaisedButton(child: Text("SIGNOUT"),onPressed: ()
                  => signOutUser()
                    //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
                  )
                ],
              ),),
              Center(child: Text("CALLS LOG"),),
              Center(child: Text("CONTACTS"),),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTabBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      color: (_page == 0)?Colors.lightBlue:Colors.grey,),
                    label: "CHATS",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      color: (_page == 1)?Colors.lightBlue:Colors.grey,),
                    label: "CALLS",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.contact_phone,
                      color: (_page == 2)?Colors.lightBlue:Colors.grey,),
                    label: "CONTACTS",
                  ),
                ],
                onTap: navigationTapped,
                currentIndex: _page,
              ),
            ),
          ),
        ),
      ),
    );
  }
    // Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text("Home Screen"),
    //           Text(_currentUser.email),
    //           RaisedButton(child: Text("SIGNOUT"),onPressed: ()
    //           => signOutUser()
    //             //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
    //           )
    //         ],
    //       ),
    //     );


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