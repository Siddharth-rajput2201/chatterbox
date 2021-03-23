import 'package:chatterbox/Screens/home_screen/homescreen_helper.dart';
import 'package:chatterbox/Screens/profile_screen/profile_screen.dart';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPostHelper with ChangeNotifier {
  Widget headerProfile(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              children: [
                GetUserPhotoUrlStream(Provider.of<FirebaseMethods>(context)
                    .getCurrentUser()
                    .uid),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GetUserNameStream(Provider.of<FirebaseMethods>(context)
                      .getCurrentUser()
                      .uid),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(Provider.of<FirebaseMethods>(context)
                      .getCurrentUser()
                      .email),
                ),
              ],
            ),
          ),

          Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: UniversalColorVariables.greyColor,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  color: UniversalColorVariables.greyColor,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 70.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: UniversalColorVariables.greyColor,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: UniversalColorVariables.greyColor,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 70.0,
                      width: 80.0,
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              color: UniversalColorVariables.greyColor,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            'Post',
                            style: TextStyle(
                              color: UniversalColorVariables.greyColor,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    OutlinedButton(onPressed:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage())), child: Text("Edit Profile"))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
