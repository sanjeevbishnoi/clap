import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

class ReportOnProfile extends StatefulWidget {
  ReportOnProfile({Key? key}) : super(key: key);

  @override
  _ReportOnProfileState createState() => _ReportOnProfileState();
}

class _ReportOnProfileState extends State<ReportOnProfile> {
  var probleList = [
    "Pretending to Be Someone",
    "Fake Account",
    "Fake Name",
    "Posting Inappropriate Things",
    "Haraasment or Bullying",
    "I Want to Help",
    "Something Else"
  ];
  @override
  Widget build(BuildContext context) {
    String currentUserId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
        title: Text(
          "Report a Problem",
          style: TextStyle(color: buttonColor),
        ),
        iconTheme: IconThemeData(color: buttonColor),
      ),
      body: ListView.builder(
          itemCount: probleList.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                          reportProblem(probleList[index], currentUserId)));
                },
                child: Card(
                  color: darkColor,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${probleList[index]}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  Future reportProblem(String problem, String currentUserId) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res =
        await Apis().reportOnProfile(user.id, currentUserId, problem);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(microseconds: 100), () {
          //Navigator.popAndPushNamed(context, PageRoutes.add_post);
          Navigator.of(context).pop();
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }
}
