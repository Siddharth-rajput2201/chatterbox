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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            //flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width*0.6,
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
                ],
              ),
            ),
          ),

          Expanded(
              //flex: 1,
              child: Container(
                //color: Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.18,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: UniversalColorVariables.darkBlackColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 70.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                           width: MediaQuery.of(context).size.width*0.18,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: UniversalColorVariables.darkBlackColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 70.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.18,
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: UniversalColorVariables.darkBlackColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 70.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
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


  Widget middleProfile(BuildContext context , dynamic snapshot)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Container(

            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(2.0)
            ),
            child: Row(
              children: [
                Text('RECENTLY ADDED',style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                ),)
              ],
            ),
          ),
        SizedBox(height: 5,),
        Container(
          height: MediaQuery.of(context).size.height*0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: UniversalColorVariables.darkBlackColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context , dynamic snapshot)
  {
    return Padding(
      padding: const EdgeInsets.only(top : 16.0),
      child: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height * 0.65,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset('assets/images/NoInternetImage.png'),
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: UniversalColorVariables.darkBlackColor.withOpacity(0.4),
            borderRadius:  BorderRadius.circular(20.0)
          ),
        ),
      ),
    );
  }
}
