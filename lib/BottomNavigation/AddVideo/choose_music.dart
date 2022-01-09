import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qvid/BottomNavigation/AddVideo/show_new_album.dart';
import 'package:qvid/BottomNavigation/AddVideo/show_new_relase.dart';
import 'package:qvid/Theme/colors.dart';

class ChooseMusic extends StatefulWidget {
  @override
  _ChooseMusicState createState() => _ChooseMusicState();
}

class _ChooseMusicState extends State<ChooseMusic> {
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: buttonColor),
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Choose Your Music",
              style:
                  TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
            ),
            bottom: TabBar(tabs: [
              Tab(
                child: Text(
                  "New Release",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text("New Album", style: TextStyle(color: Colors.white)),
              ),
            ]),
          ),
          body: TabBarView(children: [
            FadedSlideAnimation(
              ShowNewRelease(),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
            FadedSlideAnimation(
              ShowNewAlbum(),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
          ]),
        ));
  }
}
