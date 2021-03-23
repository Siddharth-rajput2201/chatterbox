
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePhotoUploadScreen with ChangeNotifier
{
 Future startUpload(BuildContext context) async
 {
    await Provider.of<FirebaseMethods>(context, listen: false).uploadUserImage(context);
 }
}

// Future uploadUserImage(BuildContext context) async{
//   try{
//     UploadTask imageUploadTask;
//
//     Reference imageReference = FirebaseStorage.instance.ref().child('${Provider.of<ProfileScreenUtils>(context,listen: false).getUserImage.path}/${TimeOfDay.now()}');
//
//     imageUploadTask = imageReference.putFile(Provider.of<ProfileScreenUtils>(context,listen: false).getCroppedUserImage);
//     if(Provider.of<ProfileScreenUtils>(context,listen: false).bucketImageReference!=null)
//     {
//       deleteUserImage(context);
//     }
//     imageUploadTask.snapshotEvents.listen((snapshot) {
//       print('Task state: ${snapshot.state}');
//       print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');}, onError: (e) {
//       // The final snapshot is also available on the task via `.snapshot`,
//       // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
//       print(imageUploadTask.snapshot);
//       if (e.code == 'permission-denied') {
//         print('User does not have permission to upload to this reference.');
//       }
//     });
//     try {
//       await imageUploadTask;
//       print('Upload complete.');
//     } on FirebaseException catch (e) {
//       if (e.code == 'permission-denied') {
//         print('User does not have permission to upload to this reference.');
//       }
//       // ...
//     }
//
//     // await imageUploadTask.whenComplete((){
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
//     showErrorSnackbar(context,"PROFILE IMAGE UPLOAD ERROR");
//   }
//
// }

// class GetUploadPercentage extends StatefulWidget {
//
//   @override
//   _GetUploadPercentageState createState() => _GetUploadPercentageState();
// }
//

// class _GetUploadPercentageState extends State<GetUploadPercentage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<UploadTask>(
//       builder: (_,snapshot){
//         var event = snapshot?.data?.snapshot;
//         double progressPercent = event != null
//             ? event.bytesTransferred / event.totalBytes
//             : 0;
//
//         return Column(
//
//           children: [
//             // Progress bar
//             LinearProgressIndicator(value: progressPercent),
//             Text(
//                 '${(progressPercent * 100).toStringAsFixed(2)} % '
//             ),
//           ],
//         );
//       },
//
//     );
//   }
// }

