import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/notification.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class NotificationMessages extends StatefulWidget {
  @override
  _NotificationMessagesState createState() => _NotificationMessagesState();
}

class _NotificationMessagesState extends State<NotificationMessages> {
  @override
  Widget build(BuildContext context) {
    return NotificationPage();
  }
}

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User? userDetails;
  bool isLoading = true;
  List<Notifications> notificationList = [];
  @override
  void initState() {
    super.initState();
    fetchUser();
    Future.delayed(Duration(seconds: 1), () {
      fetchNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              child: Container(
                  child: MyCustomAppBar(context: context, user: userDetails)
                      .myCustomAppBar),
              preferredSize: Size.fromHeight(100)),
          body: isLoading == false
              ? notificationList.isNotEmpty
                  ? ListView.builder(
                      itemCount: notificationList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    notificationList[index].userProfile!.isEmpty
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                "assets/images/user_icon.png"))
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                Constraints.IMAGE_BASE_URL +
                                                    notificationList[index]
                                                        .userProfile!)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${notificationList[index].userName!}" +
                                                "${notificationList[index].message!}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Times',
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            notificationList[index]
                                                .description!,
                                            style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(notificationList[index].time!,
                                              style: TextStyle(
                                                  color: buttonColor,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    )
                                  ],

                                  // onTap: () =>
                                  //     Navigator.pushNamed(context, PageRoutes.userProfilePage),
                                ),
                                Divider(
                                  color: Colors.white38,
                                )
                              ],
                            ),
                          ),
                        ]);
                      })
                  : Center(
                      child: Lottie.asset(
                        "assets/animation/no-data.json",
                        width: 250,
                        height: 250,
                      ),
                    )
              : Center(child: SpinKitFadingCircle(color: Colors.red))),
    );
  }

  void fetchUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    User userDet = await ApiHandle.fetchUser();
    //print(user.id + user.name);
    setState(() {
      userDetails = userDet;
    });
  }

  Future<List<Notifications>> fetchNotification() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getNotification(user.id);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            notificationList = re
                .map<Notifications>((e) => Notifications.fromJson(e))
                .toList();
            isLoading = false;
          });

        return re.map<Notifications>((e) => Notifications.fromJson(e)).toList();
      } else {
        print("error");
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
}
