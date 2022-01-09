import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/widget/toast.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final mobile = data['mobile'];
    final userType = data['user_type'];

    print(mobile);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Lottie.asset(
                    "assets/animation/phone_animation.json",
                    width: 160,
                    height: 160,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Enter Verification code",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Times',
                        color: buttonColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      "We have send you a 4 digit verification code on  $mobile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: buttonColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                PinCodeTextField(
                  controller: _otp,
                  mainAxisAlignment: MainAxisAlignment.center,
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  /* validator: (v) {
                    if (v!.length < 4) {
                      return "Plese Enter 4 digit otp";
                    } else {
                      return null;
                    }
                  }, */
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 45,
                    fieldOuterPadding: EdgeInsets.all(10),
                    fieldWidth: 45,
                    //activeFillColor:
                    //   hasError ? Colors.orange : Colors.white,
                  ),
                  cursorColor: disabledTextColor,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle:
                      TextStyle(fontSize: 20, height: 1.6, color: Colors.black),
                  enableActiveFill: false,
                  //errorAnimationController: errorController,
                  //controller: textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.white,
                      blurRadius: 0,
                    )
                  ],
                  onCompleted: (v) {
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    /* setState(() {
                              currentText = value;
                            }); */
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(resendOtp(mobile)));
                  },
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Resend OTP ?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: buttonColor),
                    ),
                  )),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    String otp = _otp.text;
                    if (otp.isEmpty) {
                      MyToast(message: "Please Enter Otp").toast;
                    } else if (otp.length < 4) {
                      MyToast(message: "Please Enter 4 digit Otp").toast;
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                              otpVerify(mobile, otp, userType)));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "VERIFY OTP",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: buttonColor),
                        )),
                  ),
                ),
                /* InkWell(
                onTap: () {
                  /* Navigator.of(context).pushNamedAndRemoveUntil(
                      PageRoutes.bottomNavigation, (Route<dynamic> route) => false); */
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      Expanded(child: Container()),
                      Center(
                        child: Text(
                          "Go Back",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                ),
              ), */
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future otpVerify(String mobile, String otp, String userType) async {
    Response resp = await Apis().verifyOtp(mobile, otp);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        var data = response['data'];

        //get SharedPrefercne
        bool result = await MyPrefManager.prefInstance()
            .addData("user", jsonEncode(data));
        if (result == true) {
          print("add");
        } else {
          print("sorry");
        }

        print(data.toString());
        print(userType);
        Future.delayed(Duration(microseconds: 1), () {
          //Navigator.of(context).pop();
          userType == "New"
              ? Navigator.pushNamed(context, PageRoutes.personal_info,
                  arguments: mobile)
              : Navigator.pushNamedAndRemoveUntil(
                  context,
                  PageRoutes.bottomNavigation,
                  (route) => false,
                );
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }

  Future resendOtp(String mobile) async {
    Response resp = await Apis().resendOtp(mobile);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }
}
