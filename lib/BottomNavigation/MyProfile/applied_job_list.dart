import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Screens/post_list.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/widget/toast.dart';

class AppliedJobList extends StatefulWidget {
  final String userid;
  AppliedJobList({required this.userid});

  @override
  State<AppliedJobList> createState() => _AppliedJobListState();
}

class _AppliedJobListState extends State<AppliedJobList> {
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
          "Applied Job List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: [
        isLoading == false
            ? list != null
                ? ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostList(context: context, userPost: list![index])
                          .appliedJpbList;
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
    Response response = await Apis().getAppliedPostList(userId);

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
}
