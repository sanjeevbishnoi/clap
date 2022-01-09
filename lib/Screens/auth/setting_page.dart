import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/booking/booking.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/custome_loader.dart';
import 'package:qvid/widget/toast.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool statusCelebrity = false;
  bool enableDirectory = false;
  bool showMobileStatus = false;
  User? currentUser;
  final TextEditingController _priceFor30sec = TextEditingController();
  final TextEditingController _priceFor60sec = TextEditingController();
  String? userId;
  bool isHit = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      findUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
          iconTheme: IconThemeData(color: buttonColor),
          title: Text(
            "Setting Page",
            style: TextStyle(color: buttonColor),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: buttonColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Become Celebrity",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: statusCelebrity,
                          inactiveTrackColor: Colors.white,
                          activeColor: buttonColor,
                          onChanged: (val) {
                            showAlert1(val);
                            print(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: buttonColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Enable Directory",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: enableDirectory,
                          inactiveTrackColor: Colors.white,
                          activeColor: buttonColor,
                          onChanged: (val) {
                            showAlert2(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: buttonColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Show Mobile No",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: showMobileStatus,
                          inactiveTrackColor: Colors.white,
                          activeColor: buttonColor,
                          onChanged: (val) {
                            showAlert3(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.refer_earn);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/refer.png",
                          height: 24,
                          width: 24,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Refern & Earn",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showUpdateDialog();
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Update Phone No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageRoutes.wishlistUsers,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "View Wishlist",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookingList(type: "booked_me")));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.book_online_rounded, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Booking",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookingList(type: "my_booking")));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.book_online_rounded, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "My Booking",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.supervised_user_circle, color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "About us",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.report_gmailerrorred_sharp,
                          color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Help & Support",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.report_gmailerrorred_sharp,
                          color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.report_gmailerrorred_sharp,
                          color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Terms & Conditions",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.report_problem, color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Reports",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(Icons.report_problem, color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Violations",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(5)),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: 200,
                        height: 135,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 15.0),
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Are you sure want to logout?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"))),
                                SizedBox(width: 10),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Future.delayed(
                                              Duration(microseconds: 1), () {
                                            //Navigator.of(context).pop();
                                            MyPrefManager.prefInstance()
                                                .removeData("user");
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              PageRoutes.login_screen,
                                              (route) => false,
                                            );
                                            MyToast(
                                                    message:
                                                        "logout Successfully")
                                                .toast;
                                          });
                                        },
                                        child: Text("Yes"))),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      //padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                isHit == true
                    ? Align(
                        alignment: Alignment.center,
                        child: CustomeLoader.customLoader,
                      )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              width: 200,
                              height: 135,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 15.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Are you sure want to Remove your account ?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("No"))),
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Future.delayed(
                                                    Duration(microseconds: 1),
                                                    () {
                                                  Navigator.of(context).pop();
                                                  MyPrefManager.prefInstance()
                                                      .removeData("user");
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          FutureProgressDialog(
                                                              deleteAccount(
                                                                  userId)));
                                                });
                                              },
                                              child: Text("Yes"))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      height: 40,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Remove account",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future findUser() async {
    User user = await ApiHandle.fetchUser();
    //print(user.id + user.name);
    print("this is call");
    currentUser = user;
    print(currentUser!.celebrity);
    setState(() {
      currentUser!.celebrity == "true"
          ? statusCelebrity = true
          : statusCelebrity = false;
      currentUser!.isDirectory == "true"
          ? enableDirectory = true
          : enableDirectory = false;
      currentUser!.mobileStatus == "true"
          ? showMobileStatus = true
          : showMobileStatus = false;
    });

    userId = user.id;
  }

  //become celebrity
  Future<void> becomeCelebrity(String id, String status) async {
    Response resp =
        await Apis().becomeCelebrity(id, status, price30sec, price60sec);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          isHit = false;
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  //enable directory

  Future enablDirectory(String id, String status) async {
    Response resp = await Apis().enableDirectory(id, status);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          isHit = false;
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future enableShowMobile(String id, String status) async {
    Response resp = await Apis().enableShowMobileNo(id, status);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          isHit = false;
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  showAlert1(dynamic val) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text(
              statusCelebrity == false
                  ? "Are You Sure want to become celebrity"
                  : "Are You Sure want to disable  celebrity",
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    /*  statusCelebrity = false;
                    await becomeCelebrity(userId!, "false"); */
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isHit = true;
                    });
                    Navigator.pop(context);
                    //showPriceAlert(context);
                    statusCelebrity == true
                        ? await becomeCelebrity(userId!, "false")
                        : showPriceAlert(context);

                    setState(() {
                      statusCelebrity = val;
                    });
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  showAlert2(bool value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text(
              enableDirectory == false
                  ? "Are You Sure want to Enable Directory"
                  : "Are You Sure want to Disable Directory",
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    /*  enableDirectory = false;
                    await enablDirectory(userId!, "false"); */
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isHit = true;
                    });
                    Navigator.pop(context);
                    enableDirectory == true
                        ? await enablDirectory(userId!, "false")
                        : await enablDirectory(userId!, "true");
                    setState(() {
                      enableDirectory = value;
                    });
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  showAlert3(bool value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text(
              showMobileStatus == false
                  ? "Are You Sure want to show your mobile no"
                  : "Are You Sure want to dont't show your mobile no",
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    /*  enableDirectory = false;
                    await enablDirectory(userId!, "false"); */
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isHit = true;
                    });
                    Navigator.pop(context);
                    showMobileStatus == true
                        ? await enableShowMobile(userId!, "false")
                        : await enableShowMobile(userId!, "true");
                    setState(() {
                      showMobileStatus = value;
                    });
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  Future deleteAccount(String? userId) async {
    Response resp = await Apis().deleteAccount(userId!);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        String user_type = response['user_type'];
        Future.delayed(Duration(microseconds: 1), () {
          //Navigator.of(context).pop();
          MyPrefManager.prefInstance().removeData("user");
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageRoutes.login_screen,
            (route) => false,
          );
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  void showPriceAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text("Price for Celebrity",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                              controller: _priceFor30sec,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Icon(
                                    Icons.money,
                                    color: buttonColor,
                                  ),
                                  labelText: "Price for 30 sec",
                                  labelStyle: TextStyle(color: Colors.blue),
                                  counterText: "",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: disabledTextColor))))),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _priceFor60sec,
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                prefixIcon: Icon(
                                  Icons.money,
                                  color: buttonColor,
                                ),
                                labelText: "Price for 60 sec",
                                labelStyle: TextStyle(color: Colors.blue),
                                counterText: "",
                                hintStyle: TextStyle(color: Colors.blue),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: disabledTextColor)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (valid()) {
                            Navigator.of(context).pop();

                            await becomeCelebrity(userId!, "true");
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  String price30sec = "", price60sec = "";
  bool valid() {
    price30sec = _priceFor30sec.text;
    price60sec = _priceFor60sec.text;
    if (price30sec.isEmpty) {
      MyToast(message: "Please Enter Price for 30sec").toast;
      return false;
    } else if (price60sec.isEmpty) {
      MyToast(message: "Please Enter Price for 60sec").toast;
      return false;
    } else {
      return true;
    }
  }

  showOtpDialog(String mobile) {
    TextEditingController _otp = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 300,
              color: cardColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _otp.text = "";
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Enter Verify Code",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                      textStyle: TextStyle(
                          fontSize: 20, height: 1.6, color: Colors.black),
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
                    GestureDetector(
                      onTap: () {
                        print("otp ${_otp.text}");
                        if (_otp.text.isEmpty) {
                          MyToast(message: "Please Enter otp ").toast;
                          return;
                        } else if (_otp.toString().length < 4) {
                          MyToast(message: "Please Enter 4 digit  otp  ").toast;
                          return;
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => FutureProgressDialog(
                                  otpVerify(mobile, _otp.text)));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Verify Otp",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            //color: buttonColor,
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  FutureProgressDialog(resendOtp(mobile)));
                        },
                        child: Text(
                          "Resend Otp",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
  }

  showUpdateDialog() {
    TextEditingController _mobile = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: Container(
                height: 200,
                color: cardColor,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _mobile.text = "";
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Update your Phone no ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
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
                                borderSide:
                                    BorderSide(color: disabledTextColor)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_mobile.text.isEmpty) {
                            MyToast(message: "Please Enter your Mobile no ")
                                .toast;
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => FutureProgressDialog(
                                    updateMobile(_mobile.text)));

                            //  _mobile.text = "";
                          }
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
                    ]),
              ),
            ));
  }

  Future updateMobile(String mobile) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    print("mobile $mobile");
    Response resp = await Apis().updateMobileNo(user.id, mobile);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];

      if (res == "success") {
        print("hello");
        Navigator.of(context).pop();
        Future.delayed(Duration(seconds: 1), () {
          showOtpDialog(mobile);
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future otpVerify(String mobile, String otp) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().verifyOtpForUpdateNo(user.id, mobile, otp);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        var data = response['data'];

        Navigator.of(context).pop();

        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }

  Future resendOtp(String mobile) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().resendOTPForUpdateNo(user.id, mobile);
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
