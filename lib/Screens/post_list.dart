import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/BottomNavigation/MyProfile/mypost_list.dart';

import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/post/post_applicants.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:share/share.dart';

class PostList {
  final BuildContext context;
  final UserPost userPost;
  PostList({required this.context, required this.userPost});

  Padding get appliedJpbList => Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          width: double.infinity,
          //color: postColor,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            color: Colors.blue.shade900,
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            userPost.image != null
                                ? userPost.image!.isEmpty
                                    ? CircleAvatar(
                                        radius: 24.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/user_icon.png'),
                                      )
                                    : CircleAvatar(
                                        radius: 24.0,
                                        backgroundImage: NetworkImage(
                                            Constraints.IMAGE_BASE_URL +
                                                userPost.image!))
                                : CircleAvatar(
                                    radius: 24.0,
                                    backgroundImage: AssetImage(
                                        'assets/images/user_icon.png'),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userPost.postName}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${userPost.postLocation}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Job For - ${userPost.categoryName}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${userPost.date}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => shareApp(),
                child: Row(
                  children: [
                    Expanded(
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
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Padding get myJobList => Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          width: double.infinity,
          //color: postColor,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            color: Colors.blue.shade900,
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                userPost.image != null
                                    ? userPost.image!.isEmpty
                                        ? CircleAvatar(
                                            radius: 24.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/user_icon.png'),
                                          )
                                        : CircleAvatar(
                                            radius: 24.0,
                                            backgroundImage: NetworkImage(
                                                Constraints.IMAGE_BASE_URL +
                                                    userPost.image!))
                                    : CircleAvatar(
                                        radius: 24.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/user_icon.png'),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${userPost.postName}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${userPost.postLocation}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Job For - ${userPost.categoryName}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${userPost.date}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      deletePost(userPost.id);
                                    },
                                    child: Icon(Icons.delete,
                                        color: Colors.red, size: 30))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => shareApp(),
                child: Row(
                  children: [
                    Expanded(
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostApplicants(postId: userPost.id!)));
                        },
                        child: Card(
                          color: buttonColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            //                          padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              "View Applicants",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

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

  Future applyJob(String postId, String type, File? file) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);
    var result = await MyPrefManager.prefInstance().getData("user");
    print("hello");
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
        /* Future.delayed(
            Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(
                context, PageRoutes.bottomNavigation, (route) => false)); */
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  void deletePost(String? id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteJob(id!);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);
      if (res == "success") {
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }
}

shareApp() {
  Share.share('Bollywood clap https://example.com');
}
