import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:share/share.dart';

class MyCustomAppBar {
  BuildContext context;
  User? user;
  MyCustomAppBar({required this.context, this.user});

  Container get myCustomAppBar => Container(
        padding: EdgeInsets.all(15),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            user != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageRoutes.myProfile,
                      );
                    },
                    child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            Constraints.IMAGE_BASE_URL + user!.image)),
                  )
                : CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/images/user_icon.png")),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageRoutes.myProfile,
                    );
                  },
                  child: Text(
                    user != null ? "${user!.name}" : "Clap",
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Times',
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.add_post);
                },
                child: Image.asset(
                  "assets/images/loud.png",
                  width: 27,
                  height: 27,
                  color: Colors.blue,
                )),
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, PageRoutes.notification),
              child: Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 27,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.conversation_screen);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/images/chat_icon.png",
                  width: 27,
                  height: 27,
                  color: Colors.blue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //   Navigator.pushNamed(context, PageRoutes.conversation_screen);
                Navigator.pushNamed(context, PageRoutes.setting_page);
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.blue,
              ),
            )
          ],
        ),
      );

  void fecthUse() async {
    print("wowhd");
    var result = await MyPrefManager.prefInstance().getData("user");
    user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
  }
}
