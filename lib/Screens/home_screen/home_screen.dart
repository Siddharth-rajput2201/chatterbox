import 'dart:async';
import 'package:chatterbox/Screens/home_screen/homescreen_helper.dart';
import 'package:chatterbox/Screens/profile_screen/profile_screen.dart';
import 'package:chatterbox/Screens/Setting/SettingPage.dart';
import 'package:chatterbox/pageview/ChatScreen/chatlist_screen.dart';
import 'package:chatterbox/pageview/FeedScreen/UploadPost/uploadpost.dart';
import 'package:chatterbox/pageview/FeedScreen/feed_screen.dart';
import 'package:chatterbox/pageview/UserPost/userpost_screen.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:chatterbox/utils/utilitizes.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';





class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _title = "ChatterBox";
  IconData _leadingicon = Icons.add_box_outlined;
  Function actionPressed;
  bool _showLeadingAction = true;
  final FirebaseRepository _repository = FirebaseRepository();
  User _currentUser;
 //  Timer _timer;
 // bool _isemailverified ;
 //bool _displayEmailVerificationSendButton = true;
  PageController pageController;
  int _page = 2;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String intials;

  @override
  void initState() {
    // _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
    //   checkVerification();
    // });
    super.initState();
    setState(() {
      _currentUser = _repository.getCurrentUser();
      //intials = Utils.getInitials(_currentUser.displayName,_currentUser.email);
    });
    pageController = PageController(initialPage: 2);

  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
   //double _width = MediaQuery.of(context).size.width;
    _currentUser = _repository.getCurrentUser();
    return //homePage(_width);
     chatScreen();
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
                  //_currentUser.photoURL==null?Image.asset('assets/images/NouserImage.png',height: 40,width: 40,):
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 60,
                      maxWidth: 60,
                    ),
                    child:
                    Stack(
                      children: [
                        GetUserPhotoUrlStream(_currentUser.uid),
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
                        child: Text("EMAIL : "+_currentUser.email),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: Row(
                          children: [
                            Text("USERNAME : "),
                            GetUserNameStream(_currentUser.uid),
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
          => signOutUser()
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
            title: Text(_title),
            //_currentUser.photoURL==null?Image.asset('assets/images/NouserImage.png',height: 40,width: 40,):
            // Container(
            //   constraints: BoxConstraints(
            //     maxHeight: 40,
            //     maxWidth: 40,
            //   ),
            //   child: Stack(
            //     children: [
            //       GetUserPhotoUrlStream(_currentUser.uid),
            //       Align(
            //         alignment: Alignment.bottomRight,
            //         child: Container(
            //           height: 15,
            //           width: 15,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: UniversalColorVariables.onlineDotColor,
            //             border: Border.all(
            //               color: UniversalColorVariables.blackColor,
            //               width: 2,
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            leading: IconButton(

              icon: Icon(_leadingicon,
                color: Colors.white,),
              onPressed : _showLeadingAction ?  ()=> Provider.of<UploadPost>(context,listen: false).uploadPostSelectionBottomWidget(context) : null,
            ),
            actions: [
              // IconButton(
              //   icon: Icon(_icon,
              //     color: Colors.white,),
              //   onPressed: (){
              //   },
              // ),
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
              Center(child: Text("CONTACTS")),
              Center(child: Text("CALLS LOG"),),
              FeedScreen(),
              Center(child: ChatListScreen(),),
              UserPostScreen(),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: Container(
            child: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 0)?Colors.lightBlue:Colors.grey,),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)?Colors.green:Colors.grey,),
                ),

                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                    color: (_page == 2)?Colors.white:Colors.grey,),
                ),

                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 3)?Colors.yellowAccent:Colors.grey,),
                ),

                BottomNavigationBarItem(
                  icon:
                  Icon(
                    EvaIcons.heart,
                    color: (_page == 4)?Colors.red:Colors.grey,),
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

  // Widget verifyScreen(double _width)
  // {
  //   return WillPopScope(
  //     onWillPop: _onBackPressed,
  //     child: SafeArea(
  //       top: true,
  //       bottom: true,
  //       child: Scaffold(
  //         body: Builder(
  //           builder: (context)=>
  //               Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Text("VERIFICATION",style: TextStyle(fontSize: 30),),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Container(
  //                         margin: EdgeInsets.only(top:20),
  //                         decoration: BoxDecoration(
  //                             color:Colors.grey[800],
  //                             borderRadius: BorderRadius.circular(20)
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Center(child: Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: Text("PLEASE VERIFY YOUR EMAIL : \n ${_currentUser.email}",style: TextStyle(fontSize: 20),),
  //                             )),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 GestureDetector(
  //                                   onTap:()=>{
  //                                     signOutUser()
  //                                     //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
  //                                   },
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(bottom : 15.0),
  //                                     child: Container(
  //                                       width: _width*0.30,
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.cyan,
  //                                         borderRadius: BorderRadius.circular(30),
  //                                         border: Border.all(
  //                                           width: 2,
  //                                           color: Colors.cyan[800],
  //                                         ),
  //                                       ),
  //                                       child: Align(
  //                                         alignment: Alignment.center,
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(15.0),
  //                                           child: Text("LOG OUT"),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 _displayEmailVerificationSendButton ? GestureDetector(
  //                                   onTap:()=>{
  //                                     verifyEmail(_currentUser, context)
  //                                     //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
  //                                   },
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(bottom : 15.0),
  //                                     child: Container(
  //                                       width: _width*0.30,
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.orange,
  //                                         borderRadius: BorderRadius.circular(30),
  //                                         border: Border.all(
  //                                           width: 2,
  //                                           color: Colors.orange[600],
  //                                         ),
  //                                       ),
  //                                       child: Align(
  //                                         alignment: Alignment.center,
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(15.0),
  //                                           child: Text("SEND"),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ):CircularProgressIndicator(),
  //                               ],
  //                             ),
  //                           ],
  //                         )
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //         ),
  //       ),
  //     ),
  //   );
  // }


  // Widget waiting()
  // {
  //   return Center(child: CircularProgressIndicator());
  // }

  void onPageChanged(int page)
  {
    String _temptitle = "";
    IconData _tempicon;
    bool _tempShowLeadingActionButton;
    //Color _tempColor;
    switch (page) {
      case 0:
        _temptitle = "Contacts";
        _tempicon = null;
        _tempShowLeadingActionButton = false;
     //   _tempColor = Colors.pink;
        break;
      case 1:
        _temptitle = "Call Log";
        _tempicon = null;
        _tempShowLeadingActionButton = false;
   //     _tempColor = Colors.green;
        break;
      case 2:
        _temptitle = "ChatterBox";
          _tempicon = Icons.add_box_outlined;
        _tempShowLeadingActionButton = true;
     //   _tempColor = Colors.deepPurple;
        break;
      case 3:
        _temptitle = "Chats";
        _tempicon = null;
        _tempShowLeadingActionButton = false;
        //   _tempColor = Colors.deepPurple;
        break;
      case 4:
        _temptitle = "Profile";
        _tempicon = null;
        _tempShowLeadingActionButton = false;
        //   _tempColor = Colors.deepPurple;
        break;
    }
    setState(() {
      _title = _temptitle;
      _leadingicon = _tempicon;
      _showLeadingAction = _tempShowLeadingActionButton;
      _page = page;
    });
  }

  void navigationTapped(int page)
  {
    pageController.jumpToPage(page);
  }
  //
  // Future<void> checkVerification() async
  // {
  //     await _currentUser.reload();
  //     if (_currentUser.emailVerified) {
  //       setState(() {
  //         _repository.updateEmailVerificationStatus(_currentUser.emailVerified, _currentUser.uid);
  //         _isemailverified = true;
  //       });
  //       _timer.cancel();
  //     }
  //     else {
  //       setState(() {
  //         _isemailverified = false;
  //       });
  //     }
  // }
  //
  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }

  // Future<void> verifyEmail( User _currentUser , BuildContext context ) async
  // {
  //   setState(() {
  //     _displayEmailVerificationSendButton = false;
  //   });
  //   await _repository.sendEmailVerification(_currentUser, context);
  //   setState(() {
  //     _displayEmailVerificationSendButton = true;
  //   });
  // }

  Future<bool> _onBackPressed()
  {
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("DO YOU REALLY WANT TO EXIT THE APP"),
        actions: <Widget>[
          TextButton(
            child: Text("NO"),
            onPressed: ()=>Navigator.pop(context,false),
          ),
          TextButton(
            child: Text("YES"),
            onPressed: ()=>SystemNavigator.pop(),
          ),
        ],
      )
    );
  }
}