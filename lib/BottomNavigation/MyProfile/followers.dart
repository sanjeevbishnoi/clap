import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Components/profile_page_button.dart';
import 'package:qvid/Routes/routes.dart';

import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';

class FollowersPage extends StatefulWidget {
  String userId;
  FollowersPage({required this.userId});
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<User> users = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      loadFollowersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Followers"),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        body: isLoading == false
            ? users.isNotEmpty
                ? FadedSlideAnimation(
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: users[index].image.isEmpty
                                    ? CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "Assets/images/user_icon.png"),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            Constraints.IMAGE_BASE_URL +
                                                users[index].image),
                                      ),
                                title: Text(
                                  users[index].name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  users[index].type,
                                  style: TextStyle(),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageRoutes.userProfilePage,
                                      arguments: users[index].id);
                                },
                                /*  trailing: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: users[index].followStatus
                        ? ProfilePageButton(
                                "Following",
                                () {
                                  setState(() {
                                    users[index].isFollowing =
                                        !users[index].isFollowing;
                                  });
                                },
                              )
                        : ProfilePageButton(
                                "Follow",
                                () {
                                  setState(() {
                                    users[index].isFollowing =
                                        !users[index].isFollowing;
                                  });
                                },
                                color: mainColor,
                                textColor: secondaryColor,
                              ),
                  ), */
                              ),
                              Divider()
                            ],
                          );
                        }),
                    beginOffset: Offset(0, 0.3),
                    endOffset: Offset(0, 0),
                    slideCurve: Curves.linearToEaseOut,
                  )
                : Center(
                    child: Lottie.asset(
                      "assets/animation/no-data.json",
                      width: 250,
                      height: 250,
                    ),
                  )
            : Center(
                child: SpinKitFadingCircle(
                  color: buttonColor,
                ),
              ));
  }

  Future loadFollowersList() async {
    /*  var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>); */
    Response response = await Apis().getFollowersList(widget.userId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      print(response.body);
      if (res == "success") {
        var re = data['data'] as List;
        if (mounted)
          setState(() {
            users = re.map<User>((e) => User.fromMap(e)).toList();
            isLoading = false;
          });

        return re.map<User>((e) => User.fromMap(e)).toList();
      } else {
        if (mounted)
          setState(() {
            users = [];
            isLoading = false;
          });
      }
    } else {}
  }
}
