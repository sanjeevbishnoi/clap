import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qvid/Screens/post/show_post_list.dart';
import 'package:qvid/Theme/colors.dart';

class AllPostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: buttonColor),
              iconTheme: IconThemeData(color: buttonColor),
              elevation: 0,
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: color1,
                  indicatorWeight: 5,
                  /* BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)), */
                  labelColor: buttonColor,
                  unselectedLabelColor: disabledTextColor,
                  tabs: [
                    Tab(
                      child: Text("All Job"),
                    ),
                    Tab(
                      child: Text("Matched Job"),
                    ),
                    Tab(
                      child: Text("Applied Job"),
                    ),
                    Tab(
                      child: Text("Favourite Job"),
                    ),
                  ]),
            ),
            body: TabBarView(children: [
              FadedSlideAnimation(
                ShowPostList(
                  status: 1,
                ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
              FadedSlideAnimation(
                ShowPostList(
                  status: 2,
                ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
              FadedSlideAnimation(
                ShowPostList(
                  status: 3,
                ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
              FadedSlideAnimation(
                ShowPostList(
                  status: 4,
                ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ])));
  }
}
