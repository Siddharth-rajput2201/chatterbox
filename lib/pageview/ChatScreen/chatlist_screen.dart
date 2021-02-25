import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

//global
final FirebaseRepository _repository = FirebaseRepository();
//User _currentUser;

class _ChatListScreenState extends State<ChatListScreen> {


  GlobalKey<ScaffoldState> _key = GlobalKey();


  @override
  void initState() {
    super.initState();
    setState(() {
     // _currentUser = _repository.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: UniversalColorVariables.darkBackGroundColor,
     // appBar: customAppBar(context),
      floatingActionButton: NewChatFloatingButton(),
      body: ChatListContainer(),
    );
  }

  // CustomAppBar customAppBar(BuildContext context)
  // {
  //   return CustomAppBar(
  //       title: UserCircle(text: intials),
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.search,
  //             color: Colors.white,),
  //           onPressed: (){
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.more_vert,
  //             color: Colors.white,),
  //           onPressed: (){
  //             _key.currentState.openDrawer();
  //           },
  //         ),
  //       ],
  //       leading: IconButton(
  //         icon: Icon(Icons.notifications,
  //           color: Colors.white,),
  //         onPressed: (){
  //         },
  //       ),
  //       centerTitle: true);
  // }

  Future<void> signOutUser() async
  {
    await _repository.signOutUser();
  }
}

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("CHAT SCREEN"),
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


