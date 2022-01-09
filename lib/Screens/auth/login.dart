import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobile = TextEditingController();
  UserCredential? _userCredential;
  FirebaseAuth auth = FirebaseAuth.instance;
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  GoogleSignInAccount? account;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/splash_logo.png",
                    height: 150,
                    width: 150,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "Welcome in  Clap",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                      fontFamily: 'Times',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Login Here",
                    style: TextStyle(
                        color: buttonColor,
                        fontSize: 18,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _mobile,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      //maxLength: 10,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: buttonColor,
                        ),
                        counterText: "",
                        hintText: "Enter Your Mobile No",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: disabledTextColor)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Mobile No";
                        } else /*  if (value.length < 10) {
                          return "Please Enter 10 digit mobile no";
                        } */
                          return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      /* ,
                      ); */
                      //loadDialog();
                      loadBottomSheet();
                    } else {
                      print("sdsd");
                    }
                    //Navigator.pushNamed(context, PageRoutes.otp_screen);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        //color: buttonColor,
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Divider(
                        height: 2,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Or",
                      style: TextStyle(
                          color: buttonColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Divider(
                        height: 2,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      //_userCredential = await signInWithGoogle();
                      _handleSignIn();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Text("Continue with Google",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          )),
                    ),
                  ),
                ),

                /* Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                        child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      child: Container(
                        child: Center(
                          child: Image.asset(
                            "assets/icons/google_sign.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                        width: 70,
                        height: 70,
                      ),
                    )),
                    Expanded(child: Container()),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        child: Container(
                          child: Center(
                            child: Image.asset(
                              "assets/icons/facebok.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ), */
                GestureDetector(
                  onTap: () async {
                    const url = "https://flutter.io";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {}
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 15),
                    child: Text(
                      "Terms Conditions & Privacy Policy",
                      style: TextStyle(
                          fontSize: 14,
                          color: buttonColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future login(String mobile) async {
    Response resp = await Apis().userLogin(mobile);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        String user_type = response['user_type'];
        Future.delayed(Duration(microseconds: 1), () {
          //Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.otp_screen,
              arguments: {"mobile": mobile, "user_type": user_type});
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
            context: context,
            builder: (context) => Dialog(
                child: Container(
                    width: 200,
                    height: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Icon(Icons.close)),
                          ),
                        ),
                        Lottie.asset(
                          "assets/animation/thankyou1.json",
                          width: 120,
                          height: 120,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Thank You For Using Clap !",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Visit again for more entertainment.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text("Exit")),
                        )
                      ],
                    )))) ??
        false;
  }

  loadBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              height: 230,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Clap Policies",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        text: "We have update our ",
                        children: [
                          TextSpan(
                            text: " Terms and Conditions ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: ",",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextSpan(
                            text: " Privacy Policy ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "&",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextSpan(
                            text: " Community Guidelines ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                " to serve you better.By Accepting this you agree to our terms and conditions.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => FutureProgressDialog(
                                  login(_mobile.text),
                                ));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          color: buttonColor,
                          width: double.infinity,
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ));
  }

  loadDialog() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            child: Container(
                width: 200,
                height: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Icon(Icons.close)),
                      ),
                    ),
                    Image.asset("assets/logo/logo.png", width: 50, height: 50),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Accept our Privacy Policy and Terms conditions. ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No")),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          FutureProgressDialog(
                                            login(_mobile.text),
                                          ));
                                },
                                child: Text("Yes")),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ))));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _handleSignIn() async {
    print("dsdsd");
    try {
      account = await _googleSignIn.signIn();
      String id = account!.id;
      print(account!.email);
    } catch (error) {
      print(error);
    }
  }
}
