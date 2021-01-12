import 'package:flutter/material.dart';

showErrorSnackbar(BuildContext context , String errorText )
{
  //Focus.of(context).requestFocus(new FocusNode());
  Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(
        errorText,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,duration: Duration(seconds: 6)),);
  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText),));
}

showProgressSnackbar(BuildContext context , String errorText )
{
  //Focus.of(context).requestFocus(new FocusNode());
  Scaffold.of(context).showSnackBar(
    SnackBar(content: Text(
      errorText,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,duration: Duration(seconds: 6)),);
  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText),));
}