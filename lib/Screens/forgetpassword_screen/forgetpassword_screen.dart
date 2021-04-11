import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _disablePasswordResetFormFeild = true;
  bool _displayPasswordResetButton  = true;
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  String _forgetPasswordEmail;
  FirebaseRepository _repository = FirebaseRepository();
  //double _height = MediaQuery.of(context).size.width;

  TextEditingController _forgetPasswordController;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return forgetPasswordWidget(_width);
  }

  Widget forgetPasswordWidget(double _width)
  {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: Builder(
          builder:(context)=> SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top : 20.0 ,left: 20 , right: 20),
                  child: Text("FORGET PASSWORD ? ",style: TextStyle(fontSize: 40),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.only(top:20),
                    decoration: BoxDecoration(
                        color:Colors.grey[800],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child:  Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _forgetPasswordFormKey,
                            child: TextFormField(
                              enabled: _disablePasswordResetFormFeild,
                              validator: (String emailText) {
                                if(!emailText.contains("@") )
                                {
                                  return "INVALID EMAIL";
                                }
                                else if(emailText.length>50)
                                {
                                  return "INVALID EMAIL";
                                }
                                else if(!emailText.contains("."))
                                {
                                  return "INVALID EMAIL";
                                }
                                else
                                {
                                  return null;
                                }
                              }  ,
                              onChanged: (_val) {
                                _forgetPasswordEmail = _val;
                              },
                              controller: _forgetPasswordController,
                              decoration: InputDecoration(
                                hintText: "EXAMPLE@EMAIL.COM",
                                labelText: "EMAIL",
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 50,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _displayPasswordResetButton?GestureDetector(
                              onTap: ()=>
                              {
                              forgetPasswordValidator(_forgetPasswordEmail , context)
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom : 15.0),
                                child: Container(
                                  width: _width*0.30,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.cyan[800],
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("SUBMIT"),
                                    ),
                                  ),
                                ),
                              ),
                            ):CircularProgressIndicator(),
                            GestureDetector(
                              onTap: ()=>{
                              Navigator.pop(context)
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom : 15.0),
                                child: Container(
                                  width: _width*0.30,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("GO BACK"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> forgetPasswordValidator(String _forgetPasswordEmail , BuildContext context) async
  {
    setState(() {
      _disablePasswordResetFormFeild = false;
      _displayPasswordResetButton = false;
    });
    setState(() {
      _forgetPasswordFormKey.currentState.validate();
    });
    if(_forgetPasswordFormKey.currentState.validate() == true)
      {
        await _repository.forgetPassword(_forgetPasswordEmail.trim(), context);
        setState(() {
          _disablePasswordResetFormFeild = true;
          _displayPasswordResetButton = true;
        });
      }
    else
      {
        setState(() {
          _disablePasswordResetFormFeild = true;
          _displayPasswordResetButton = true;
        });
        Provider.of<ErrorDisplayWidget>(context,listen: false).showErrorSnackbar(context,"PASSWORD RESET REQUEST FAILED");
      }
    return Future.value(null);
  }
}


