import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

import 'package:share/share.dart';

class PostFullViewDetails extends StatefulWidget {
  @override
  State<PostFullViewDetails> createState() => _PostFullViewDetailsState();
}

class _PostFullViewDetailsState extends State<PostFullViewDetails> {
  User? user;
  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userPost = ModalRoute.of(context)!.settings.arguments as UserPost;
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "JOBS",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          body: Stack(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          decoration: BoxDecoration(color: buttonColor),
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: userPost.image == null
                                    ? Image.asset(
                                        'assets/user/user1.png',
                                      )
                                    : Image.network(
                                        Constraints.IMAGE_BASE_URL +
                                            userPost.image!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      userPost.isWishlistStatus = true;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(
                                                addToFavorurite(userPost.id)));
                                  },
                                  child: Container(
                                      child: userPost.isWishlistStatus == false
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.grey.shade500,
                                                size: 30,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Icon(Icons.favorite,
                                                  color: Colors.red, size: 30),
                                            )),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Card(
                          color: cardColor,
                          child: Container(
                              height: 100,
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Recruiter Info",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue.shade500)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Name: ${userPost.userName}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Email: ${userPost.userEmail}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ])))),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Card(
                      color: cardColor,
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text("Job Basic Info",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue.shade500)),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${userPost.postName}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(
                              height: 3,
                            ),
                            Text("Gender: ${userPost.gender}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            SizedBox(
                              height: 3,
                            ),
                            Text("Age: ${userPost.age}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white)),
                            SizedBox(
                              height: 3,
                            ),
                            Text("${userPost.postLocation}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Job Description",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue.shade500)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("${userPost.postDescription}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                              SizedBox(
                                height: 3,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Job Requirement",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue.shade500)),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("Langauge:",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                  Expanded(
                                      child: Text("${userPost.language}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white))),
                                ],
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                visible: userPost.performingSkills!.isEmpty
                                    ? false
                                    : true,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text("Performing Skills:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                        child: Text(
                                            "${userPost.performingSkills}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: userPost.postLocation!.isEmpty
                                    ? false
                                    : true,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text("Actor Location:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                        child: Text("${userPost.postLocation}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: userPost.nationality!.isEmpty
                                    ? false
                                    : true,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text("Nationality:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                        child: Text("${userPost.nationality}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("Experience:",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                  Expanded(
                                    child: Text(
                                        userPost.experience == "Yes"
                                            ? "Experience Required "
                                            : "Not required",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: userPost.postType == "Artist" ||
                                        userPost.postType == "Model"
                                    ? true
                                    : false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text("Requires Audition:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                        child: Text(
                                            "${userPost.requiresAudition}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: userPost.postType == "Artist" ||
                            userPost.postType == "Model"
                        ? true
                        : false,
                    child: Column(
                      children: [
                        Visibility(
                          visible: userPost.height!.isEmpty ? false : true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Card(
                              color: cardColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          " Required Physical Attributes For Artist",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue.shade500)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Weight:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text("${userPost.weight}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Height:",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text("${userPost.height}",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Hair:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${userPost.hairColor}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Skin:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${userPost.skinColor}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Chest:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${userPost.gender != "Other" ? userPost.gender == "Male" ? userPost.chestSize : userPost.breastSize : userPost.chestSize}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Waist:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${userPost.waistSize}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text("Eye Color:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${userPost.eyeColor}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade200),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Media Requirement",
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Card(
                                                color:
                                                    userPost.mediaRequirement ==
                                                            "Headshot"
                                                        ? buttonColor
                                                        : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 30,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Headshot",
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Card(
                                                color:
                                                    userPost.mediaRequirement ==
                                                            "Sideprofile"
                                                        ? buttonColor
                                                        : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 30,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Side Profile",
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Card(
                                                color:
                                                    userPost.mediaRequirement ==
                                                            "Intro Video"
                                                        ? buttonColor
                                                        : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  child: Icon(
                                                    Icons
                                                        .play_circle_filled_sharp,
                                                    size: 30,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Intro Video",
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            shareApp();
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text("Share"),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            userPost.postType == "Artist" ||
                                    userPost.postType == "Model"
                                ? Navigator.pushNamed(
                                    context, PageRoutes.applied_details,
                                    arguments: userPost)
                                : showDialog(
                                    context: context,
                                    builder: (context) => FutureProgressDialog(
                                        applyJob(userPost.id!, "", null)));
                          },
                          child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          ])),
    );
  }

  shareApp() {
    Share.share('Bollywood clap https://example.com');
  }

  void fetchUser() async {
    //var result = await MyPrefManager.prefInstance().getData("user");
    User user1 = await ApiHandle.fetchUser();
    setState(() {
      user = user1;
    });
  }

  Future applyJob(String postId, String type, File? file) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);

    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().applyPost(user.id, postId, type, file);
    print("hello");
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(
            Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(
                context, PageRoutes.bottomNavigation, (route) => false));
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  Future addToFavorurite(String? id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().addFavouriteJob(user.id, id!);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    }
  }
}
