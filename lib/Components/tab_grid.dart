import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/Home/home_page.dart';
import 'package:qvid/BottomNavigation/Home/new_video_player.dart';
import 'package:qvid/BottomNavigation/Home/video_play_page.dart';
import 'package:qvid/BottomNavigation/MyProfile/my_profile_page.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class Grid {
  String imgUrl;
  String views;

  Grid(
    this.imgUrl,
    this.views,
  );
}

class TabGrid extends StatelessWidget {
  final IconData? icon;
  final List<UserVideo>? list;
  BuildContext context;
  final Function? onTap;
  final IconData? viewIcon;
  final String? views;
  String userId;

  TabGrid(this.list,
      {this.icon,
      this.onTap,
      this.viewIcon,
      this.views,
      required this.context,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return list != null
        ? list!.isNotEmpty
            ? GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: list!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 2.5,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print("select index ${index}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FollowingTabPage1(
                                  list!, imagesInDisc1, false, index,
                                  variable: 1)));
                    },
                    onLongPress: () async {
                      var result =
                          await MyPrefManager.prefInstance().getData("user");
                      User user = User.fromMap(
                          jsonDecode(result) as Map<String, dynamic>);
                      if (userId == user.id) {
                        showDeleteSheet(list![index].id, list![index]);
                      }
                    },
                    child: FadedScaleAnimation(
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(Constraints.COVER_IMAGE_URL +
                                  list![index].coverImage),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /*  Icon(
                              viewIcon,
                              color: secondaryColor,
                              size: 15,
                            ), */
                            views != null
                                ? Text(' ' + views!)
                                : SizedBox.shrink(),
                            Spacer(),
                            /*  Icon(
                              icon,
                              color: mainColor,
                            ) */
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
            child: Lottie.asset(
              "assets/animation/no-data.json",
              width: 250,
              height: 250,
            ),
          );
  }

  void showDeleteSheet(String id, UserVideo userVideo) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 150,
              color: cardColor,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 5, right: 5),
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      showPopup(userVideo);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Edit",
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
                      Navigator.of(context).pop();
                      openDeleteDialog(id);
                      // openDeleteDialog(uploadVideo);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              ),
            ));
  }

  void openDeleteDialog(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text("Are You Sure want to Delete Video"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(deleteVideo(id)));
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  Future deleteVideo(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteData(id, "user_video");
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);

      if (res == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyProfilePage()));
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }

  void showPopup(UserVideo userVideo) {
    showDialog(
        context: context,
        builder: (context) {
          print("reelsView ${userVideo.reelsView}");
          var _userUploadOption = userVideo.reelsView;
          return StatefulBuilder(
              builder: (context, state) => Dialog(
                    child: Container(
                        height: 250,
                        color: cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Icon(Icons.close, color: Colors.red)),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Choose Option",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: const Text(
                                      'Private',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    //horizontalTitleGap: 1,
                                    leading: Radio<String>(
                                      value: "private",
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) => buttonColor),
                                      activeColor: buttonColor,
                                      groupValue: _userUploadOption,
                                      onChanged: (value) {
                                        state(() {
                                          _userUploadOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: const Text("Public",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                    //horizontalTitleGap: 1,
                                    leading: Radio<String>(
                                      value: "public",
                                      activeColor: buttonColor,
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) => buttonColor),
                                      groupValue: _userUploadOption,
                                      onChanged: (value) {
                                        state(() {
                                          _userUploadOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(
                                                updateVideoView(
                                                    _userUploadOption,
                                                    userVideo)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ));
        });
  }

  Future updateVideoView(String? userUploadOption, UserVideo userVideo) async {
    Response res = await Apis().updateReelView(userUploadOption!, userVideo.id);
    var statusCode = res.statusCode;
    print(res.body);
    print(statusCode);
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.myProfile);
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }
}
