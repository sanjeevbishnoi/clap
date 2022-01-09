import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/post/post_applicants.dart';
import 'package:qvid/Screens/post_list.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class MyPostList extends StatefulWidget {
  final String userid;
  MyPostList({required this.userid});

  @override
  State<MyPostList> createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  List<UserPost>? list;
  bool isLoading = true;
  @override
  void initState() {
    getAppliedPost(widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          "My Jobs",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: [
        isLoading == false
            ? list != null
                ? ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserPost userPost = list![index];
                      return Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                userPost.image != null
                                                    ? userPost.image!.isEmpty
                                                        ? CircleAvatar(
                                                            radius: 24.0,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/user_icon.png'),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 24.0,
                                                            backgroundImage:
                                                                NetworkImage(Constraints
                                                                        .IMAGE_BASE_URL +
                                                                    userPost
                                                                        .image!))
                                                    : CircleAvatar(
                                                        radius: 24.0,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/user_icon.png'),
                                                      ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${userPost.postName}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "${userPost.postLocation}",
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              contentTextStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                              content: Text(
                                                                  "Are You Sure want to Delete This Job"),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "No")),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (context) => FutureProgressDialog(deletePost(
                                                                              userPost.id,
                                                                              index)));
                                                                    },
                                                                    child: Text(
                                                                        "Yes")),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Icon(Icons.delete,
                                                        color: Colors.red,
                                                        size: 30))
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
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: Text("Share"),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                                      PostApplicants(
                                                          postId:
                                                              userPost.id!)));
                                        },
                                        child: Card(
                                          color: buttonColor,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Container(
                                            //                          padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              "View Applicants",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
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
                    })
                : Center(
                    child: Lottie.asset(
                      "assets/animation/no-data.json",
                      width: 250,
                      height: 250,
                    ),
                  )
            : Align(
                alignment: Alignment.center,
                child: SpinKitCircle(color: buttonColor),
              ),
      ]),
    );
  }

//load My Post
  Future<List<UserPost>> getAppliedPost(String userId) async {
    Response response = await Apis().getMyPost(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            list = re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
            isLoading = false;
          });

        return re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
      } else {
        print("error");
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future deletePost(String? id, int index) async {
    /* setState(() {
      list!.removeAt(index);
    }); */
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
        list!.clear();
        getAppliedPost(user.id);
        setState(() {});
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }
}
