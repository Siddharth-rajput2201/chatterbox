import 'dart:io';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreenUtils with ChangeNotifier{

  final picker = ImagePicker();
  File userImage;
  File croppedUserImage;
  File get getCroppedUserImage =>  croppedUserImage;
  File get getUserImage => userImage;
  String userImageUrl;
  String get getUserImageUrl => userImageUrl;
  String bucketImageReference;
  String get bucketImageReferenceUrl => bucketImageReference;

  Future pickUserImage(BuildContext context, ImageSource source,BuildContext contextForError) async {
    try{
      final pickedUserImage = await picker.getImage(source: source);
      pickedUserImage == null ? print('SELECT IMAGE') : userImage = File(pickedUserImage.path);
      print(userImage.path);
      croppedUserImage = await ImageCropper.cropImage(sourcePath: userImage.path);
      userImage == null ? showErrorSnackbar(contextForError, "NO IMAGE SELECTED") :
      Provider.of<FirebaseMethods>(context, listen: false).uploadUserImage(context);
      notifyListeners();
    }
    on FlutterError catch (PlatformError)
    {
      print(PlatformError);
      {
        showErrorSnackbar(context, "Error");
      }
      return Future.value(null);
    }
    catch(error)
    {
      showErrorSnackbar(context, "ERROR");
    }

  }

  Future<void> userNameSelectionBottomWidget(BuildContext context, String currentUserID)
  {
    final _userNameChangeKey = GlobalKey<FormState>();
    TextEditingController _userNameController = TextEditingController();
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('Enter New Username',style: TextStyle(fontSize: 20),),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Column(
                  children: [
                    Form(
                      key: _userNameChangeKey,
                      child: TextFormField(
                      validator: (String userNameText) {
                      if(userNameText.length>30) {
                        return "Too Long";
                      }
                      else if(userNameText.length<2)
                        {
                          return "Too Short";
                        }
                      return null;
                      } ,
                        decoration: InputDecoration(
                            hintText: 'New Username'
                        ),
                        maxLength: 30,
                        controller: _userNameController,
                        autofocus: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top : 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(child: Text("CANCEL"),onPressed: (){Navigator.of(context).pop();},),
                          ElevatedButton(child: Text("SUBMIT"),onPressed: (){
                            if(_userNameChangeKey.currentState.validate())
                              {
                                Provider.of<FirebaseMethods>(context,listen: false).updateUserName(currentUserID, context,_userNameController.text);
                              }
                             else
                               {
                                 return null;
                               }
                            },),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }


   Future<void> photoSelectionBottomWidget (BuildContext profilePageContext)
  {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
                            },
                            ),
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
                            child: IconButton(icon : Icon(Icons.delete,size: 25,),onPressed: (){
                              Provider.of<FirebaseMethods>(context,listen: false).removeUserPhotoUrl(context);
                              // Navigator.of(context).pop();
                            },
                            ),
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

