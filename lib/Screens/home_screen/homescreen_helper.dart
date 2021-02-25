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