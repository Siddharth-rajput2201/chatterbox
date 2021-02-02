import 'package:chatterbox/Widgets/customappbar.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:chatterbox/utils/utilitizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

//global
final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  User _currentUser;
  String intials;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  buildProfileDrawer() {
    return Drawer(
      child:  ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                UserCircle(text:intials),
                Text(_currentUser.email),
              ],
            ),
          ),
          RaisedButton(child: Text("SIGNOUT"),onPressed: ()
          => signOutUser()
            //.whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic>route) => false))
          )
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentUser = _repository.getCurrentUser();
      intials = Utils.getInitials(_currentUser.displayName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: buildProfileDrawer(),
      backgroundColor: UniversalColorVariables.darkBackGroundColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatFloatingButton(),
      body: Column(
        children: [
          Text("Chat List Screen"),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(BuildContext context)
  {
    return CustomAppBar(
        title: UserCircle(text:intials),
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
        leading: IconButton(
          icon: Icon(Icons.notifications,
            color: Colors.white,),
          onPressed: (){
          },
        ),
        centerTitle: true);
  }

  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }
}

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

class NewChatFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){},
      child: Container(
      decoration: BoxDecoration(
        gradient: UniversalColorVariables.fabGradient,
        borderRadius: BorderRadius.circular(50)
      ),
      width: 50,
      height: 50,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
    ),
    );

  }


}


