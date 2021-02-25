import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalColorVariables.blackColor,
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(

        ),
      ),
    );
  }
}
