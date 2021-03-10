import 'dart:async';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  final FirebaseRepository _repository = FirebaseRepository();
  bool _displayEmailVerificationSendButton = true;
  User _currentUser;
  Timer _timer;
  bool displaySignOutText = false;
 @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 3), (_timer) {
      checkEmailVerification();
    });
    super.initState();
    setState(() {
      _currentUser = _repository.getCurrentUser();
    });
  }
  //User _currentUser;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerification() async
  {
    await _repository.getCurrentUser().reload();
    if (_currentUser.emailVerified) {
      print(_currentUser.emailVerified);
      setState(() {
  //      _repository.updateEmailVerificationStatus(_currentUser.emailVerified, _currentUser.uid);
        displaySignOutText = true;
      });
      _timer.cancel();
    }
    else {
      print(_currentUser.emailVerified);
      setState(() {
        displaySignOutText = false;
       // _repository.updateEmailVerificationStatus(_currentUser.emailVerified, _currentUser.uid);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    _currentUser = _repository.getCurrentUser();
    return Scaffold(
      body: verifyScreen(_width)
    );
  }

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
                                child: Text("PLEASE VERIFY YOUR EMAIL : \n ${_repository.getCurrentUser().email}",style: TextStyle(fontSize: 20),),
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
                                      verifyEmail(_repository.getCurrentUser(), context)
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
                          ),
                      ),
                    ),
                    signOutText(),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget signOutText()
  {
    if(displaySignOutText)
      {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            margin: EdgeInsets.only(top:20),
            decoration: BoxDecoration(
                color:Colors.grey[800],
                borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("WE DONE SETTING UP YOUR ACCOUNT! KINDLY LOGOUT AND WE WILL VALIDATE YOUR SETTINGS ACCOUNT"),
            ),
          ),
        );
      }
    else
      {
       return Container();
      }
  }

  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }


}
