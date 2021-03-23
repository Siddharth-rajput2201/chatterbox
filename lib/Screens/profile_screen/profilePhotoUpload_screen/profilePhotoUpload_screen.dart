import 'package:chatterbox/Screens/profile_screen/profilescreen_helper.dart';
import 'package:chatterbox/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class UploadPhotoScreen extends StatefulWidget {
  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  bool _displayProgressIndicator = false;
  bool _displayButton = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("PROFILE PHOTO")
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Image.file(Provider.of<ProfileScreenUtils>(context,listen: false).croppedUserImage,height: MediaQuery.of(context).size.height*0.5,width: MediaQuery.of(context).size.width)
            ),
          Column(
            children: [
             uploadButton(),
              // ElevatedButton(
              //   child: Text("UPLOAD"),
              //   onPressed: () async
              //   {
              //     setState(() {
              //       _displayProgressIndicator = true;
              //     });
              //     await Provider.of<ProfilePhotoUploadScreen>(context,listen: false).startUpload(context).whenComplete((){
              //      setState(() {
              //         _displayProgressIndicator = false;
              //       });
              //     });
              //   },
              // ),
            ],
          ),
            uploadProgressIndicator(),
          ],
        ),
      )
    );
  }

  Widget uploadButton()
  {
    if(_displayButton == true)
      {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            child: Text("UPLOAD"),
            onPressed: () async
            {
              setState(() {
                _displayProgressIndicator = true;
                _displayButton = false;
              });
              await Provider.of<FirebaseMethods>(context, listen: false).uploadUserImage(context).whenComplete((){
                setState(() {
                  _displayButton = true;
                  _displayProgressIndicator = false;
                });
              });
            },
          ),
        );
      }
    else
    {
        return Container();
    }

  }
  Widget uploadProgressIndicator()
  {
    if(_displayProgressIndicator == true)
    {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top : 5.0,bottom: 10.0,left:15.0,right: 15.0),
            child: LinearProgressIndicator(),
          ),
            Text(
                "Please Wait Uploading"
            ),
        ],
      );
      //CircularProgressIndicator(value: _uploadPercentage,);
    }
    else
    {
      return Container();
    }
  }

}

