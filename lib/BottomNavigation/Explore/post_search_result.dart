import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/post_list.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class PostSearch extends StatefulWidget {
  List<UserPost> list;
  bool isSearchStatus;
  bool isLoading;
  PostSearch(
      {required this.list,
      required this.isSearchStatus,
      required this.isLoading});

  @override
  _PostSearchState createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.isSearchStatus == true
            ? widget.list.isNotEmpty
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.list.length,
                    itemBuilder: (context, index) {
                      UserPost userPost = widget.list[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageRoutes.post_full_view,
                                arguments: userPost);
                          },
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    userPost.image == null
                                        ? CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/user_icon.png'),
                                          )
                                        : CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: NetworkImage(
                                                Constraints.IMAGE_BASE_URL +
                                                    userPost.image!)),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${userPost.postName}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
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
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            userPost.isWishlistStatus == false
                                                ? userPost.isWishlistStatus =
                                                    true
                                                : userPost.isWishlistStatus =
                                                    false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  FutureProgressDialog(
                                                      addToFavorurite(
                                                          userPost.id)));
                                        },
                                        child: userPost.isWishlistStatus ==
                                                false
                                            ? Icon(
                                                Icons.favorite_outline_outlined,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => shareApp(),
                                        child: Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Container(
                                            //                          padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text("Share"),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          User user =
                                              await ApiHandle.fetchUser();
                                          userPost.postType == "Artist" ||
                                                  userPost.postType == "Model"
                                              ? Navigator.pushNamed(context,
                                                  PageRoutes.applied_details,
                                                  arguments: userPost)
                                              : showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      FutureProgressDialog(
                                                          applyJob(userPost.id!,
                                                              "", null)));

                                          // print('dfdf');
                                        },
                                        child: Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: buttonColor,
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                      );
                    })
                : Center(
                    child: Lottie.asset(
                      "assets/animation/no-data.json",
                      width: 250,
                      height: 250,
                    ),
                  )
            : Center(
                child: Text(
                  "Search Your Job",
                  style: TextStyle(color: buttonColor, fontFamily: 'Times'),
                ),
              ));
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
}
