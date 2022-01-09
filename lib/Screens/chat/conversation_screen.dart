import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';

import 'package:qvid/Screens/chat/primary_chats.dart';
import 'package:qvid/Screens/chat/suggestion_chats.dart';

import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

class ConverationChats extends StatefulWidget {
  @override
  _ConverationChatsState createState() => _ConverationChatsState();
}

class _ConverationChatsState extends State<ConverationChats> {
  bool isLoading = false;

  List<ChatUser> primaryUsers = [];
  List<ChatUser> suggestedUsers = [];
  String? userId;
  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration(seconds: 1), () {
      findUser().then((value) => {getChatUser(userId!), getSuggested(userId!)});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: buttonColor),
            iconTheme: IconThemeData(color: buttonColor),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.search_user);
                  },
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: buttonColor,
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelColor: buttonColor,
                  unselectedLabelColor: Colors.white,
                  labelStyle: Theme.of(context).textTheme.headline6,
                  //indicator: BoxDecoration(color: Colors.red),
                  indicatorColor: Colors.red,
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(text: "Primary"),
                    Tab(text: "Suggestion"),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            isLoading == false
                ? TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      FadedSlideAnimation(
                        PrimaryChats(
                          users: primaryUsers,
                        ),
                        beginOffset: Offset(0, 0.3),
                        endOffset: Offset(0, 0),
                        slideCurve: Curves.linearToEaseOut,
                      ),
                      FadedSlideAnimation(
                        SuggestionChats(users: suggestedUsers),
                        beginOffset: Offset(0, 0.3),
                        endOffset: Offset(0, 0),
                        slideCurve: Curves.linearToEaseOut,
                      )
                    ],
                  )
                : SpinKitFadingCircle(
                    color: buttonColor,
                  ),
          ],
        ),
      ),
    );
  }

  Future<List<ChatUser>> getChatUser(String userId) async {
    Response response = await Apis().getChatUserList(userId);
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
            primaryUsers =
                re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
            isLoading = false;
          });
        return re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
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

  Future<List<ChatUser>> getSuggested(String userId) async {
    Response response = await Apis().getSuggestedUserList(userId);
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
            suggestedUsers =
                re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
            isLoading = false;
          });
        return re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
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

  Future findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    setState(() {
      userId = user.id;
    });

    //MyToast(message: user.id).toast;
  }
}
