import 'dart:io';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPost extends ChangeNotifier
{
  File uploadPostImage;
  File get getUploadPstImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  File croppedPostImage;
  File get getCroppedPostImage =>  croppedPostImage;
  UploadTask userPostImageUploadTask;

  final picker = ImagePicker();

  uploadPostSelectionBottomWidget (BuildContext profilePageContext)
  {
    try{
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
                      Text("Upload Post",style: TextStyle(fontSize: 20),),
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
                                  //Provider.of<ProfileScreenUtils>(context,listen: false).pickUserImage(context, ImageSource.camera,profilePageContext);
                                  pickUserPostImage(context, ImageSource.camera,profilePageContext);
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
                                  pickUserPostImage(context, ImageSource.gallery,profilePageContext);
                                   Navigator.of(context).pop();
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
                    ],
                  )
                ],
              ),
            );
          }
      );
    }
    catch(error)
    {
      return Provider.of<ErrorDisplayWidget>(profilePageContext).showErrorSnackbar(profilePageContext,"UPLOAD POST ERROR");
    }

  }


  Future pickUserPostImage(BuildContext context, ImageSource source,BuildContext contextForError) async {
    try{
      final pickedUserImage = await picker.getImage(source: source ,imageQuality: 75);
      uploadPostImage = null;
      pickedUserImage == null ? print('SELECT IMAGE') : uploadPostImage = File(pickedUserImage.path);
      print(uploadPostImage.path);
      croppedPostImage = await ImageCropper.cropImage(sourcePath: uploadPostImage.path);
      if(uploadPostImage == null)
      {
        Navigator.pop(context);
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "NO IMAGE SELECTED");
      }
      else if(croppedPostImage == null)
      {
        Navigator.pop(context);
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "NO IMAGE SELECTED");
      }
      else
      {
      //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadPhotoScreen()));
      }
      //   croppedPostImage == null ? showErrorSnackbar(context, "NO IMAGE SELECTED") :
      //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadPhotoScreen()));
      // Provider.of<FirebaseMethods>(context, listen: false).uploadUserImage(context);

      notifyListeners();
    }
    on FlutterError catch (PlatformError)
    {
      print(PlatformError);
      {
        Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "Error");
      }
      return Future.value(null);
    }
    catch(error)
    {
      Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context, "IMAGE NOT SELECTED/UPLOADED");
    }

  }



  Future uploadUserPost() async {

  }


  // Future uploadUserImage(BuildContext context) async{
  //   try{
  //     Reference imageReference = FirebaseStorage.instance.ref().child('posts/${Provider.of<ProfileScreenUtils>(context,listen: false).getUserImage.path}/${TimeOfDay.now()}');
  //
  //     userPostImageUploadTask = imageReference.putFile(Provider.of<ProfileScreenUtils>(context,listen: false).getCroppedUserImage);
  //     // if(Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference!=null)
  //     // {
  //     //   deleteUserImage(context);
  //     // }
  //     userPostImageUploadTask.snapshotEvents.listen((snapshot) {
  //       print('Task state: ${snapshot.state}');
  //       print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  //     }, onError: (e) {
  //
  //       // The final snapshot is also available on the task via `.snapshot`,
  //       // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
  //       print(userPostImageUploadTask.snapshot);
  //       if (e.code == 'permission-denied') {
  //         print('User does not have permission to upload to this reference.');
  //       }
  //     });
  //     try {
  //       await userPostImageUploadTask;
  //       print('Upload complete.');
  //     } on FirebaseException catch (e) {
  //       if (e.code == 'permission-denied') {
  //         print('User does not have permission to upload to this reference.');
  //       }
  //       // ...
  //     }
  //
  //     // await userPostImageUploadTask.whenComplete((){
  //     //   // Navigator.of(context).pop();
  //     // });
  //
  //     Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference = 'gs://'+imageReference.bucket+'/'+imageReference.fullPath;
  //     print(Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference);
  //     imageReference.getDownloadURL().then((url) {
  //       Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl = url.toString();
  //       print('the user profile url => ${Provider.of<ProfileScreenUtils>(context,listen: false).userImageUrl}');
  //       updateUserProfileUrl(context);
  //       updateProfilePhoto(_auth.currentUser.uid, context);
  //       notifyListeners();
  //     });
  //   }
  //   catch(error)
  //   {
  //     Provider.of<ErrorDisplayWidget>(context,listen:false).showErrorSnackbar(context,"PROFILE IMAGE UPLOAD ERROR");
  //   }
  //
  // }

}