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
        return  CircleAvatar(
            maxRadius: 80,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage("${data['profilePhoto']}")
        );
        // Text("${data['profilePhoto']}");
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