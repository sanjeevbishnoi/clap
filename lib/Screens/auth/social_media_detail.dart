import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

class SocialMediaDetails extends StatefulWidget {
  @override
  State<SocialMediaDetails> createState() => _SocialMediaDetailsState();
}

class _SocialMediaDetailsState extends State<SocialMediaDetails> {
  final _formKey = GlobalKey<FormState>();
  late String userId;
  
  TextEditingController _youtube = TextEditingController();
  TextEditingController _instagram = TextEditingController();
  TextEditingController _facebook = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _telegram = TextEditingController();

  @override
  void initState() {
    findUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text("Fill You Social Media Details Here",
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _youtube,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.youtube,
                        color: buttonColor,
                      ),
                    ),
                    hintText: "Youtube",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Youtube url";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _instagram,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: buttonColor,
                      ),
                    ),
                    hintText: "Instagram Id",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Instagram  id";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _facebook,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: buttonColor,
                      ),
                    ),
                    hintText: "Facebook Id",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Facebook id";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _twitter,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.twitter,
                        color: buttonColor,
                      ),
                    ),
                    hintText: "Twitter Id",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Twitter id";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _telegram,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.telegram,
                        color: buttonColor,
                      ),
                    ),
                    hintText: "Telegram id",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Telegram id";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, PageRoutes.basic_profile_info);
                    if (_formKey.currentState!.validate()) {
                      String youtube = _youtube.text;
                      String instagram = _instagram.text;
                      String facebook = _facebook.text;
                      String twitter = _twitter.text;
                      String telegram = _telegram.text;

                      showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                              updateSocialMedia(userId, youtube, instagram,
                                  facebook, twitter, telegram)));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future updateSocialMedia(String userdId, String youtube, String instagramId,
      String facebookid, String twitterId, String telegramId) async {
    Response resp = await Apis().updateSocialDetails(
        userdId, youtube, instagramId, facebookid, twitterId, telegramId);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamed(context, PageRoutes.basic_profile_info);
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
    //MyToast(message: user.id).toast;
  }
}
