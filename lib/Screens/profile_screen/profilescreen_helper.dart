import 'dart:io';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreenUtils with ChangeNotifier{

  final picker = ImagePicker();
  File userImage;
  File get getUserImage => userImage;
  String userImageUrl;
  String get getUserImageUrl => userImageUrl;

  Future pickUserImage(BuildContext context, ImageSource source,BuildContext contextForError) async {
    final pickedUserImage = await picker.getImage(source: source);
    pickedUserImage == null ? print('SELECT IMAGE') : userImage = File(pickedUserImage.path);
    print(userImage.path);
    userImage == null ? showErrorSnackbar(contextForError, "NO IMAGE SELECTED") : Provider.of<FirebaseMethods>(context, listen: false).uploadUserImage(context);
    notifyListeners();
  }

   Future<void> photoSelectionBottomWidget (BuildContext profilePageContext)
  {
    return showModalBottomSheet(
      context: profilePageContext,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Profile Photo",style: TextStyle(fontSize: 20),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(icon : Icon(Icons.camera,size: 25,),onPressed: (){
                              Provider.of<ProfileScreenUtils>(context,listen: false).pickUserImage(context, ImageSource.camera,profilePageContext);
                              Navigator.of(context).pop();
                            },),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("CAMERA"),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(icon : Icon(Icons.photo,size: 25,),onPressed: (){
                              Provider.of<ProfileScreenUtils>(context,listen: false).pickUserImage(context, ImageSource.gallery,profilePageContext);
                             // Navigator.of(context).pop();
                            },),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("GALLERY"),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete,size: 25,),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("REMOVE"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}

