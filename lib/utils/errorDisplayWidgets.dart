import 'package:flutter/material.dart';
class ErrorDisplayWidget extends  ChangeNotifier{
  void closeSnackbar(BuildContext context)
  {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
  showErrorSnackbar(BuildContext context , String errorText )
  {
    //Focus.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating,
          content: Text(
            errorText,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,duration: Duration(seconds: 6)),);
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText),));
  }

  showProgressSnackbar(BuildContext context , String errorText )
  {
    //Focus.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating,
          content: Text(
            errorText,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,duration: Duration(seconds: 6)),);
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText),));
  }
}


