//import 'package:chatterbox/pageview/pageview_helper.dart';
import 'package:chatterbox/pageview/UserPost/UserPostHelper.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class UserPostScreen extends StatefulWidget {
  @override
  _UserPostScreenState createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
           // height:  MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
             // color: UniversalColorVariables.darkBlackColor,
              //borderRadius: BorderRadius.circular(15.0),
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator(),);
                  }
                else
                  {
                    return Column(
                      children: [
                        Provider.of<UserPostHelper>(context).headerProfile(context, snapshot),
                        Divider(thickness: 2,color: Colors.white30,),
                        Provider.of<UserPostHelper>(context).middleProfile(context, snapshot),
                        Provider.of<UserPostHelper>(context).footerProfile(context, snapshot),
                      ],
                    );
                  }
            },
            ),
          ),
        ),
      )
    );
  }
}
