import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart ' as ge;
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/BottomNavigation/Home/following_tab.dart';
import 'package:qvid/BottomNavigation/Home/video_comment_controller.dart';
import 'package:qvid/Components/custom_button.dart';
import 'package:qvid/Components/rotated_image.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/controller/player_screen_controller.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/model/video_comment.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class FollowingTabPage1 extends StatelessWidget {
  final List<UserVideo> videos;
  final List<String> images;
  final bool isFollowing;

  final int? variable;
  final int? videoIndex;

  FollowingTabPage1(this.videos, this.images, this.isFollowing, this.videoIndex,
      {this.variable});

  @override
  Widget build(BuildContext context) {
    return videos.isNotEmpty
        ? FollowingTab1Body(
            videos,
            images,
            isFollowing,
            videoIndex,
          )
        : Center(
            child: Lottie.asset(
              "assets/animation/no-data.json",
              width: 250,
              height: 250,
            ),
          );
  }
}

class FollowingTab1Body extends StatefulWidget {
  final List<UserVideo> videos;
  final List<String> images;

  final bool isFollowing;

  int? videoIndex;

  FollowingTab1Body(
      this.videos, this.images, this.isFollowing, this.videoIndex);

  @override
  _FollowingTab1BodyState createState() => _FollowingTab1BodyState();
}

class _FollowingTab1BodyState extends State<FollowingTab1Body> {
  PageController? _pageController;

  int current = 0;

  bool isOnPageTurning = false;
  bool firstTimeLoading = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _pageController!.page == _pageController!.page!.roundToDouble()) {
      print("scrolling");
      setState(() {
        current = _pageController!.page!.toInt();
        print("current page");
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        current.toDouble() != _pageController!.page) {
      print("not scroll");
      // current = widget.videoIndex!;
      print(current);
      if ((current.toDouble() - _pageController!.page!).abs() > 0.1) {
        isOnPageTurning = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("video count ${widget.videos.length}");
    print("video Index ${widget.videoIndex}");
    print("video ${widget.videos[widget.videoIndex!].videoName}");

    _pageController = PageController();
    _pageController!.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemBuilder: (context, position) {
        print("current page scrolling $isOnPageTurning");
        print("page position $position");
        return VideoPage(widget.videos[position].videoName,

            // widget.images[position],
            isPaused: isOnPageTurning,
            pageIndex: position,
            /* currentPageIndex:
                isOnPageTurning == false ? widget.videoIndex! : current, */
            currentPageIndex: current,
            isFollowing: widget.isFollowing,
            userVideo: firstTimeLoading == true
                ? position != widget.videoIndex!
                    ? widget.videos[position]
                    : widget.videos[widget.videoIndex!]
                : widget.videos[widget.videoIndex!]);
      },
      onPageChanged: (i) {
        setState(() {
          //  widget.videoIndex = ((widget.videoIndex)! % (widget.videos.length))!;
          //isOnPageTurning = true;
          firstTimeLoading = true;
        });
        print("page no $i");
      },
      itemCount: widget.videos.length,
    );
  }
}

class VideoPage extends StatefulWidget {
  final String video;
  //final String image;
  final int? pageIndex;
  final int? currentPageIndex;
  final bool? isPaused;
  final bool? isFollowing;
  final UserVideo? userVideo;

  VideoPage(this.video,
      {this.pageIndex,
      this.currentPageIndex,
      this.isPaused,
      this.isFollowing,
      this.userVideo});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with RouteAware {
  bool initialized = false;
  bool isLiked = false;
  bool isLoading = true;
  bool isHit = false;
  bool isPlaying = false;
  bool isStatus = false;

  bool isPlay = false;
  User? user;
  int count = -1;
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    widget.userVideo!.likeStatus == true ? isLiked = true : isLiked = false;
    fetchCurrentUser();
    print("likestatus ${widget.userVideo!.likeStatus}");
    _controller = VideoPlayerController.network(
        Constraints.Video_URL + widget.userVideo!.videoName)
      ..initialize().then((value) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
          isPlaying = true;

          initialized = true;
          isLoading = false;
        });
      });
  }

  @override
  void didPopNext() {
    print("didPopNext");
    _controller.play();
    isPlaying = true;
    super.didPopNext();
  }

  @override
  void didPushNext() {
    print("didPushNext");
    _controller.pause();
    isPlaying = false;
    super.didPushNext();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>); //Subscribe it here
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    _controller.dispose();
    super.dispose();
  }

  void fetchCurrentUser() async {
    User user1 = await ApiHandle.fetchUser();
    setState(() {
      user = user1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isPlaying);
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      _controller.play();
      setState(() {
        isPlaying = true;
      });
      //isPlaying = true;
    } else {
      _controller.pause();
      setState(() {
        isPlaying = false;
      });
    }

//    if (_controller.value.position == _controller.value.duration) {
//      setState(() {
//      });
//    }
    //if (widget.pageIndex == 2) _controller.pause();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();

              /* setState(() {
                /* _controller.value.isPlaying
                    ? isPlaying = false
                    : isPlaying = true; */
              }); */
              //isPlaying = false;
            },
            child: _controller.value.isInitialized
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller)),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: -10.0,
            bottom: 80.0,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    _controller.value.isPlaying ? _controller.pause() : "";

                    await Navigator.pushNamed(
                            context, PageRoutes.userProfilePage,
                            arguments: widget.userVideo!.userId)
                        .then((value) => _controller.play());
                  },
                  child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/user_icon.png')),
                ),
                CustomButton(
                  GestureDetector(
                    onTap: () {
                      shareVideo(
                          widget.userVideo!.userId, widget.userVideo!.id);
                    },
                    child: ImageIcon(
                      AssetImage('assets/icons/share_white.png'),
                      color: Colors.white,
                    ),
                  ),
                  '${widget.userVideo!.share}',
                ),
                CustomButton(
                    GestureDetector(
                      onTap: () {
                        commentSheet(
                          context,
                          user!,
                          widget.userVideo!,
                        );
                      },
                      child: ImageIcon(
                        AssetImage('assets/icons/comment_white.png'),
                        color: Colors.white,
                      ),
                    ),
                    '${widget.userVideo!.comment}',
                    onPressed: () {}),
                CustomButton(
                  Image.asset(
                    widget.userVideo!.likeStatus == true
                        ? "assets/icons/like_red_shadow.png"
                        : isLiked == false
                            ? "assets/icons/like_shadow.png"
                            : "assets/icons/like_red_shadow.png",
                    height: 25,
                    width: 25,
                  ),
                  count == -1 ? '${widget.userVideo!.likes}' : '$count',
                  onPressed: () {
                    setState(() {
                      isHit = true;
                      isLiked == true ? isLiked = false : isLiked = true;
                      /* int oldLike = int.parse("${widget.userVideo!.likes}");
                      int newLike = isLiked == true
                          ? oldLike + 1
                          : oldLike > 0
                              ? oldLike - 1
                              : 0;
                      count = newLike;
                      widget.userVideo!.likes = "${newLike}";
                      print(widget.userVideo!.likes); */
                      //widget.userVideo!.likes=widget.userVideo!.likes + 1;
                    });
                    Future.delayed(Duration(seconds: 1), () async {
                      User user = await ApiHandle.fetchUser();
                      likeVideo(user.id, widget.userVideo!.id);
                    });
                  },
                ),
                CustomButton(
                  Icon(
                    Icons.more_vert_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                  "",
                  onPressed: () {
                    _controller.pause();

                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              height: 120,
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Card(
                                      color: cardColor,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.download,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Download",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        shareApp();
                                      },
                                      child: Card(
                                        color: cardColor,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.ios_share,
                                                size: 30,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Share",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushNamed(
                                            context, PageRoutes.reportReels,
                                            arguments: widget.userVideo!.id);
                                      },
                                      child: Card(
                                        color: cardColor,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.report,
                                                size: 25,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Report",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RotatedImage("assets/user/user1.png"),
                ),
              ],
            ),
          ),
          widget.isFollowing!
              ? Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 27.0,
                  bottom: 320.0,
                  child: CircleAvatar(
                      backgroundColor: mainColor,
                      radius: 8,
                      child: Icon(
                        Icons.add,
                        color: buttonColor,
                        size: 12.0,
                      )),
                )
              : SizedBox.shrink(),
          /*  Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: LinearProgressIndicator(color: Colors.red
                    //minHeight: 1,
                    )),
          ), */
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 12.0,
            bottom: 20.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.userVideo!.description,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16.0, color: Colors.white, letterSpacing: 0.5)),
              Text("${widget.userVideo!.time}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: buttonColor)),
            ]),
          ),
          Align(
              alignment: Alignment.center,
              child: isLoading == true || isHit == true
                  ? SpinKitFadingCircle(
                      color: buttonColor,
                      size: 60,
                    )
                  : Container()),
          /*   isHit == true
              ? Align(
                  alignment: Alignment.center,
                  child: CustomeLoader.customLoader,
                )
              : Container() */

          /*  Visibility(
            visible: _controller.value.isPlaying == false ? true : false,
            child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.pause_circle,
                  color: Colors.white,
                  size: 60,s
                )),
          ), */
          isLiked == true
              ? isStatus == true
                  ? Align(
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        "assets/animation/like.json",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ))
                  : Container()
              : Container()
        ],
      ),
    );
  }

//like video
  Future<void> likeVideo(String userId, String videoId) async {
    dynamic response = await Apis().likeVideo(userId, videoId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];

      if (res == "success") {
        //MyToast(message: msg).toast;
        int cou = data['data'];
        print("like count $count");

        setState(() {
          isLiked = true;
          isHit = false;
          count = cou;
          isStatus = true;
          widget.userVideo!.likeStatus = true;
        });
        call();
      } else {
        //MyToast(message: msg).toast;

        int cou = data['data'];
        setState(() {
          isLiked = false;
          isHit = false;
          isStatus = false;
          count = cou;
          widget.userVideo!.likeStatus = false;
        });
      }
    } else {
      MyToast(message: "Server Errror");
    }
  }

  // share video
  Future<void> shareVideo(String userId, String videoId) async {
    dynamic response = await Apis().shareVideo(userId, videoId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        MyToast(message: msg).toast;
        shareApp();
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Server Errror");
    }
  }

//gte Comment
//get List of comment

  Future<List<VideoComment>> getUserMatchPost(String userId) async {
    dynamic response = await Apis().getVideoComment(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        return re.map<VideoComment>((e) => VideoComment.fromJson(e)).toList();
      } else {
        print("error");
        MyToast(message: msg).toast;
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  shareApp() {
    Share.share('Bollywood clap https://example.com');
  }

  void call() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isStatus = false;
      });
    });
  }
}
