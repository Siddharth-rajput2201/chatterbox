import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class GetUserName extends StatelessWidget {
  final String documentId; // This is your User UID

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("${data['username']}");
        }
        return Text("loading");
      },
    );
  }
}


class GetUserNameStream extends StatelessWidget {
  final String documentId; // This is your User UID

  GetUserNameStream(this.documentId);

  @override
  Widget build(BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
    return StreamBuilder<DocumentSnapshot>(
      stream: users.snapshots(),
      builder:  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("waiting");
        }
        Map<String, dynamic> data = snapshot.data.data();
        return Text("${data['username']}");
      },
    );
  }
}



class GetUserPhotoUrlStream extends StatelessWidget {


  final String documentId; // This is your User UID
  GetUserPhotoUrlStream(this.documentId);

  @override
  Widget build(BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
    return StreamBuilder<DocumentSnapshot>(
      stream: users.snapshots(),
      builder:  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Image.asset('assets/images/NouserImage.png');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        Map<String, dynamic> data = snapshot.data.data();
        try{
          return ClipOval(
            child: Image.network(
              "${data['profilePhoto']}",
              height: 180,
              width: 180,
              errorBuilder: (ctx, exception, stackTrace) {
                return CircleAvatar(
                  maxRadius: 80,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/images/NouserImage.png'),
                ); //THE WIDGET YOU WANT TO SHOW IF URL NOT RETURN IMAGE
              },
            ),
          );
        }
        catch(error)
        {
          return CircleAvatar(
            maxRadius: 80,
            backgroundColor: Colors.grey,
            backgroundImage: AssetImage('assets/images/NouserImage.png'),
          );
        }

          // CircleAvatar(
          //
          //   maxRadius: 80,
          //   backgroundColor: Colors.grey,
          //   backgroundImage: NetworkImage("${data['profilePhoto']}"),
            // child: ClipOval(child: FadeInImage(
            //   placeholder: AssetImage('assets/images/NouserImage.png'),
            //   image: NetworkImage("${data['profilePhoto']}"),
            //   imageErrorBuilder: (ctx, exception, stackTrace) {
            //     return CircleAvatar(
            //     maxRadius: 80,
            //     backgroundColor: Colors.grey,
            //     backgroundImage: AssetImage('assets/images/NouserImage.png'),
            //   ); //THE WIDGET YOU WANT TO SHOW IF URL NOT RETURN IMAGE
            //   },
            // ),
            // ),
            //NetworkImage("${data['profilePhoto']}")
            //FadeInImage(image: NetworkImage("${data['profilePhoto']}"), placeholder: AssetImage('assets/images/NouserImage.png')
       // );
      },
    );
  }
}


class GetUserPhotoUrlTextStream extends StatelessWidget {


  final String documentId; // This is your User UID
  GetUserPhotoUrlTextStream(this.documentId);

  @override
  Widget build(BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(documentId);
    return StreamBuilder <DocumentSnapshot>(
      stream: users.snapshots(),
      builder:  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("ERROR");
        }
        Map<String, dynamic> data = snapshot.data.data();
          return Text("${data['profilePhoto']}");

      },
    );
  }
}
// class HomeScreenHelper with ChangeNotifier{
//
//   CollectionReference users = FirebaseFirestore.instance.collection('users').doc('$DocumentID');
//
//   Widget getUserNameStream(BuildContext context , String DocumentID)
//   {
//     return StreamBuilder<QuerySnapshot>(
//       stream: users.snapshots(),
//       builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }
//
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data = snapshot.data.data();
//           return Text("${data['username']}");
//         }
//         return Text("loading");
//       },
//     )
//   }
//
// }