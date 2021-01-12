//import 'package:chatterbox/Screens/home_screen.dart';
import 'package:chatterbox/Screens/forgetpassword_screen.dart';
import 'package:chatterbox/resources/firebase_repository.dart';
import 'package:chatterbox/utils/errorDisplayWidgets.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    _emailController.clear();
    _signUpEmailController.clear();
    _passwordController.clear();
    _signUpPasswordController.clear();
    _confirmSignUpPasswordController.clear();
    super.dispose();
  }
  FirebaseRepository _repository = FirebaseRepository();
  bool _secureText = true;
  bool _secureTextSignUpPassword = true;
  bool _secureTextSignUpCofirmPassword = true;
  bool _displaySignUpButton = true;
  bool _displaySignInButton = true;
  bool _displayGoogleSignUp = true;
  bool _displayGoogleSignIn = true;
  bool _disableSignInFormFeild = true;
  bool _disableSignUpFormFeild = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _signUpEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _signUpPasswordController = TextEditingController();
  TextEditingController _confirmSignUpPasswordController = TextEditingController();
  final _logInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  String _signUpEmail;
  String _signUpPassword;
  String _signInEmail;
  String _signInPassword;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.width;
    return loginSignup(_secureText,_width,_height);
  }

  Widget loginSignup(bool secureText, double _width , double _height) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff303030),
            elevation: 0,
            toolbarHeight: 75,
            bottom: TabBar(
              unselectedLabelColor: Colors.cyan[700],
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.cyan[700],
              ),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 2,
                        color: Colors.cyan[700],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LOGIN"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 2,
                        color: Colors.cyan[700],),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("SIGNUP"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Builder(
            builder: (context)=>
             TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top:20),
                          decoration: BoxDecoration(
                            color:Colors.grey[800],
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child:
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _logInFormKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: _disableSignInFormFeild,
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
                                          _signInEmail = _val;
                                        },
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText: "EXAMPLE@EMAIL.COM",
                                          labelText: "EMAIL",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLength: 50,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: _disableSignInFormFeild,
                                        validator: (String passwordText) {
                                          if(passwordText.isEmpty)
                                          {
                                            return "PASSWORD CAN'T BE EMPTY";
                                          }
                                          else
                                          {
                                            return null;
                                          }
                                        }  ,
                                        onChanged: (_val) {
                                          _signInPassword = _val;
                                        },
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          hintText: "PASSWORD",
                                          labelText: "PASSWORD",
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(icon : Icon( _secureText? Icons.remove_red_eye : Icons.security),
                                          onPressed: ()=>{
                                            toggleIcon()
                                          },),
                                        ),
                                        obscureText: _secureText,
                                        maxLength: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5,bottom: 20.0),
                                      child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen()));
                                          },
                                          child: Text("FORGET PASSWORD ? ",style: TextStyle(color: Colors.blue),)),
                                    ),
                                    _displaySignInButton?GestureDetector(
                                      onTap: ()=>{validateSignInFormFeild(_signInEmail,_signInPassword,context)},
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
                                            child: Text("LOGIN"),
                                          ),
                                        ),
                                      ),
                                    ):CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10,),

                        Text("OR",style: TextStyle(fontSize: 17),),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom : 10.0),
                                child: _displayGoogleSignIn? GestureDetector(
                                  onTap: ()=> {
                                    performGoogleLogin(context)
                                  },
                                  child: Container(
                                    width: _width*0.65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(0xff303030),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[800],
                                          //color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 4,
                                          blurRadius: 4,
                                          offset: Offset(0, 0), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.cyan[800],
                                      ),
                                    ),
                                    child : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                      Image.asset('assets/images/google_logo.png',height: _height*0.07,width: _width*0.07,),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom : 10.0 , top : 10.0),
                                        child: Text("LOGIN WITH GOOGLE"),
                                      ),
                                    ],)
                                  ),
                                ):CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               // Icon(Icons.apps),


                /* SIGN UP */
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top:20),
                            decoration: BoxDecoration(
                                color:Colors.grey[800],
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child:
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _signUpFormKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: _disableSignUpFormFeild,
                                        validator: (String signUpEmailText) {
                                          if(!signUpEmailText.contains("@"))
                                          {
                                            return "INVALID EMAIL";
                                          }
                                          else if(!signUpEmailText.contains("."))
                                          {
                                            return "INVALID EMAIL";
                                          }
                                          else if(signUpEmailText.length>50)
                                          {
                                            return "LENGTH SHOULD BE LESS THAN 50";
                                          }
                                          else if(signUpEmailText.length<3)
                                          {
                                            return "INVALID EMAIL";
                                          }
                                          else
                                          {
                                            return null;
                                          }
                                        }  ,
                                        onChanged: (_val) {
                                          _signUpEmail = _val;
                                        },
                                        controller: _signUpEmailController,
                                        decoration: InputDecoration(
                                          hintText: "EXAMPLE@EMAIL.COM",
                                          labelText: "EMAIL",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLength: 50,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: _disableSignUpFormFeild,
                                        validator: (String signUpPasswordText) {
                                          if(signUpPasswordText.length>20)
                                          {
                                            return "Password Length To Short";
                                          }
                                          else if(signUpPasswordText.length<8)
                                          {
                                            return "TOO SHORT MINIMUM SIZE 8 ";
                                          }
                                          else
                                          {
                                            return null;
                                          }
                                        }  ,
                                        controller: _signUpPasswordController,
                                        decoration: InputDecoration(
                                          hintText: "PASSWORD",
                                          labelText: "PASSWORD",
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(icon : Icon( _secureTextSignUpPassword? Icons.remove_red_eye : Icons.security),
                                            onPressed: ()=>{
                                              toggleIconSignUpPassword()
                                            },),
                                        ),
                                        obscureText: _secureTextSignUpPassword,
                                        maxLength: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: _disableSignUpFormFeild,
                                        validator: (String confirmPasswordText) {
                                          if(confirmPasswordText.length>20)
                                          {
                                            return "Password Length To Short";
                                          }

                                          else if(_signUpPasswordController.text != _confirmSignUpPasswordController.text)
                                          {
                                            return "PASSWORD DOES NOT MATCH";
                                          }
                                          else
                                          {
                                            return null;
                                          }
                                        }  ,
                                        onChanged: (_val){
                                          _signUpPassword = _val;
                                        },
                                        controller: _confirmSignUpPasswordController,
                                        decoration: InputDecoration(
                                          hintText: "CONFIRM PASSWORD",
                                          labelText: "CONFIRM PASSWORD",
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(icon : Icon( _secureTextSignUpCofirmPassword? Icons.remove_red_eye : Icons.security),
                                            onPressed: ()=>{
                                              toggleIconSignUpConfirmPassword()
                                            },),
                                        ),
                                        obscureText: _secureTextSignUpCofirmPassword,
                                        maxLength: 20,
                                      ),
                                    ),
                                    _displaySignUpButton ? GestureDetector(
                                      onTap: ()=>{
                                        validateSignUpFormFeild(_signUpEmail,_signUpPassword,context)
                                      },
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
                                                child: Text("SIGN UP"),
                                          ),
                                        ),
                                      ),
                                    ):CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Text("OR",style: TextStyle(fontSize: 17),),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom : 10.0),
                                child: _displayGoogleSignUp ? GestureDetector(
                                  onTap: ()=>{performGoogleSignUp(context)},
                                  child: Container(
                                      width: _width*0.65,
                                      decoration: BoxDecoration(
                                        color: Color(0xff303030),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[800],
                                            //color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 4,
                                            blurRadius: 4,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.cyan[800],
                                        ),
                                      ),
                                      child : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset('assets/images/google_logo.png',height: _height*0.07,width: _width*0.07,),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom : 10.0 , top : 10.0),
                                            child: Text("SIGNUP WITH GOOGLE"),
                                          ),
                                        ],)
                                  ),
                                ):CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
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

  Future<void> performGoogleSignUp(BuildContext context) async
  {
    setState(() {
      _displayGoogleSignUp = false;
    });
    //_repository.signInWithGoogle().then((User user)
    await _repository.signInWithGoogle(context);
    if(mounted) {
      setState(() {
        _displayGoogleSignUp = true;
      });
    }



    // if(user == null)
    //   {
    //     setState(() {
    //       _displayGoogleSignUp = true;
    //     });
    //     showErrorSnackbar(context, "ERROR");
    //   }
    // {
    //   if(user != null)
    //     {
    //       Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)
    //       {
    //         return HomeScreen();
    //       }));
    //       //authenticateUser(user);
    //     }
    //   else
    //     {
    //       print("THERE WAS AN ERROR ");
    //     }
    //
    // });
  }
  Future<void> performGoogleLogin(BuildContext context) async
  {
    setState(() {
      _displayGoogleSignIn = false;
    });
    //_repository.signInWithGoogle().then((User user)
    await _repository.signInWithGoogle(context);

    if(mounted) {
      setState(() {
        _displayGoogleSignIn = true;
      });
    }
  }

  void toggleIcon()
  {
    setState(() {
      _secureText=!_secureText;
    });
  }

  void toggleIconSignUpPassword()
  {
    setState(() {
      _secureTextSignUpPassword=!_secureTextSignUpPassword;
    });
  }

  void toggleIconSignUpConfirmPassword()
  {
    setState(() {
      _secureTextSignUpCofirmPassword=!_secureTextSignUpCofirmPassword;
    });
  }
  Future<void> validateSignInFormFeild(String _signInEmail , String _signInPassword , BuildContext context) async
  {
    setState(() {
      _displaySignInButton = false;
      _disableSignInFormFeild = false;
    });
    setState(() {
      _logInFormKey.currentState.validate();
    });
    if(_logInFormKey.currentState.validate() == true)
      {
        await _repository.signInWithEmailAndPassword(_signInEmail.trim(), _signInPassword , context);
        setState(() {
          _displaySignInButton = true;
          _disableSignInFormFeild = true;
        });
      }
    else
      {
        setState(() {
          _displaySignInButton = true;
          _disableSignInFormFeild = true;
        });
        showErrorSnackbar(context, "SIGNIN FAILED");
      }

  }

  Future<void> validateSignUpFormFeild  (String _signUpEmail ,String _signUpPassword , BuildContext context ) async
  {
    setState(() {
      _displaySignUpButton = false;
      _disableSignUpFormFeild = false;
    });
    setState(() {
      _signUpFormKey.currentState.validate();
    });
    if(_signUpFormKey.currentState.validate() == true)
      {
       await _repository.signUpWithEmailAndPassword(_signUpEmail.trim(), _signUpPassword, context);
        setState(() {
          _displaySignUpButton = true;
          _disableSignUpFormFeild = true;
        });
      }
    else
      {
        setState(() {
          _displaySignUpButton = true;
          _disableSignUpFormFeild = true;
        });
        showErrorSnackbar(context, "SIGNUP FAILED");
      }
  }


  // void authenticateUser(User user)
  // {
  //   _repository.authenticateUser(user).then((isNewUser)
  //   {
  //     if(isNewUser)
  //     {
  //       _repository.addDataToDb(user).then((value){
  //         Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)
  //         {
  //           return HomeScreen();
  //         }));
  //       });
  //       //SnackBar(content: Text("USER DOES NOT EXIST PLEASE SIGN UP"),);
  //     }
  //     else
  //     {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)
  //       {
  //         return LoginScreen();
  //       }));
  //     }
  //   }
  //   );
  // }


}
