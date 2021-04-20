import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';

class RegistrationScreen extends StatefulWidget {
  static const String idScreen = "register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              Center(
                child: Image(
                  image: AssetImage("images/logo.png"),
                  width: 320.0,
                  height: 320.0,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 1.0),
              Text(
                "Register as a Rider",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Brand Bold",
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    // ElevatedButton(onPressed: () {
                    //     print("Login Button clicked");
                    //   }, child:Container(
                    //     height: 50.0,
                    //     child: Center(
                    //       child: Text(
                    //         "Login",
                    //         style:
                    //             TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                    //       ),
                    //     ),
                    //   ),
                    //   ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     print("hello");
                    //   },
                    //   child: Center(
                    //     child: Text(
                    //       "Create Account",
                    //       style: TextStyle(
                    //           fontSize: 18.0, fontFamily: "Brand Bold"),
                    //     ),
                    //   ),
                    // ),

                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMessage(
                              "Name must be atleast 3 characters", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMessage("Invalid Email Address", context);
                        } else if (phoneTextEditingController.text.length <
                            10) {
                          displayToastMessage("Invalid Mobile Number", context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          displayToastMessage(
                              " Password must be atleast 6 Characters ",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.idScreen, (route) => false);
                        },
                        child: Text("Already have an account? Login here")),

                    // FlatButton(
                    //     onPressed: () {
                    //       Navigator.pushNamedAndRemoveUntil(context,
                    //           LoginScreen.idScreen, (route) => false);
                    //     },
                    //     child: Text("Already have an account? Login here"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Registering, please wait...");
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      //save user info in database

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations, your acoount has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, Mainscreen.idScreen, (route) => false);
    } else { 
            Navigator.pop(context);
      displayToastMessage("new user account has not been created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
