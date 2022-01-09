import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/audios.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/photos.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/videos.dart';
import 'package:qvid/Theme/colors.dart';

class ShowGallery extends StatefulWidget {
  int i;
  String userId;
  ShowGallery({required this.i, required this.userId});
  @override
  State<ShowGallery> createState() => _ShowGalleryState();
}

class _ShowGalleryState extends State<ShowGallery> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Align(
                child: TabBar(
                  labelColor: buttonColor,
                  unselectedLabelColor: Colors.white,
                  labelStyle: Theme.of(context).textTheme.headline6,
                  indicator: BoxDecoration(color: transparentColor),
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(text: "Photos"),
                    Tab(text: "Videos"),
                    Tab(text: "Audio"),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            FadedSlideAnimation(
              widget.i == 1
                  ? SelectPhotos()
                  : UserPhotos(userId: widget.userId),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
            FadedSlideAnimation(
              widget.i == 1
                  ? SelectVideos()
                  : UserVideo(
                      userId: widget.userId,
                    ),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
            FadedSlideAnimation(
              widget.i == 1
                  ? SelectDocument()
                  : UserAudios(
                      userId: widget.userId,
                    ),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
          ]),
        ));
  }
}
