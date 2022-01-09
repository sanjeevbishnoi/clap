import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/Home/new_video_player.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:shimmer/shimmer.dart';

class ReelsList extends StatefulWidget {
  List<UserVideo> reels;
  bool isSearchingStatus;
  bool isLoading;
  ReelsList(
      {required this.reels,
      required this.isSearchingStatus,
      required this.isLoading});

  @override
  _ReelsListState createState() => _ReelsListState();
}

class _ReelsListState extends State<ReelsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.isSearchingStatus == true
            ? widget.isLoading == false
                ? widget.reels.isNotEmpty
                    ? StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        primary: true,
                        itemCount: widget.reels.length,
                        padding: EdgeInsets.all(2),
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FollowingTabPage1(
                                        widget.reels, [], false, index,
                                        variable: 1)));
                          },
                          child: Container(
                            child: widget.reels[index].coverImage.isEmpty
                                ? Image.asset(
                                    "assets/images/banner 1.png",
                                    height: 200,
                                    fit: BoxFit.fill,
                                  )
                                : CachedNetworkImage(
                                    height: 200,
                                    imageUrl: Constraints.COVER_IMAGE_URL +
                                        widget.reels[index].coverImage,
                                    fit: BoxFit.fill,
                                    placeholder: (context, value) =>
                                        Shimmer.fromColors(
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      direction: ShimmerDirection.rtl,
                                      period: Duration(seconds: 2),
                                    ),
                                  ),
                          ),
                        ),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
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
                  )
            : Center(
                child: Text(
                  "Search Your favourite Videos ",
                  style: TextStyle(color: buttonColor, fontFamily: 'Times'),
                ),
              ));
  }
}
