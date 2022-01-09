import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

class ReportOn extends StatefulWidget {
  int i;
  String type;
  String id;

  ReportOn({required this.i, required this.type, required this.id});

  @override
  _ReportOnProfileState createState() => _ReportOnProfileState();
}

class _ReportOnProfileState extends State<ReportOn> {
  var probleList = [
    "Spam",
    "Abusive Language",
    "sexual explicit",
    "Violence ",
    "Hate Speech",
    "Fake News",
    "Scam or fraud",
    "Illegal activities",
    "Suicide/Dangerous acts ",
    "Personal/Private content",
    "Terrorism",
    "Offensive",
    "Something Else"
  ];
  @override
  Widget build(BuildContext context) {
    String reelsId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.i == 1
            ? "Report on Photo"
            : widget.i == 2
                ? "Report on Video"
                : "Report on Audio"),
      ),
      body: ListView.builder(
          itemCount: probleList.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          FutureProgressDialog(report(probleList[index])));
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

  Future report(String problem) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res =
        await Apis().report(user.id, widget.id, problem, widget.type);
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
