import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/BottomNavigation/Home/following_tab.dart';
import 'package:qvid/Components/custom_button.dart';
import 'package:qvid/Components/rotated_image.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/model/video_comment.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class FollowingTab1Page extends StatelessWidget {
  final List<UserVideo> videos;
  final List<String> images;
  final bool isFollowing;

  final int? variable;
  final int? videoIndex;

  FollowingTab1Page(this.videos, this.images, this.isFollowing, this.videoIndex,
      {this.variable});

  @override
  Widget build(BuildContext context) {
    return FollowingTab1Body(
      videos,
      images,
      isFollowing,
      videoIndex,
    );
  }
}

class FollowingTab1Body extends StatefulWidget {
  final List<UserVideo> videos;
  final List<String> images;

  final bool isFollowing;

  final int? videoIndex;

  FollowingTab1Body(
      this.videos, this.images, this.isFollowing, this.videoIndex);

  @override
  _FollowingTab1BodyState createState() => _FollowingTab1BodyState();
}

class _FollowingTab1BodyState extends State<FollowingTab1Body> {
  PageController? _pageController;

  //int current = 0;

  bool isOnPageTurning = false;

  void scrollListener() {
    /* if (isOnPageTurning &&
        _pageController!.page == _pageController!.page!.roundToDouble()) {
      setState(() {
        current = _pageController!.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        current.toDouble() != _pageController!.page) {
      if ((current.toDouble() - _pageController!.page!).abs() > 0.1) {
        isOnPageTurning = true;
      }
    } */
  }

  @override
  void initState() {
    super.initState();
    print("video Index ${widget.videoIndex}");
    print("video ${widget.videos[widget.videoIndex!].videoName}");
    print("video count ${widget.videos.length}");
    _pageController = PageController();
    _pageController!.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return /* PageView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemBuilder: (context, position) {
        return */

        VideoPage(widget.videos[widget.videoIndex!].videoName, widget.images[0],
            isPaused: isOnPageTurning,
            isFollowing: widget.isFollowing,
            userVideo: widget.videos[widget.videoIndex!]);

    //},
    //onPageChanged: (i) {},
    /* onPageChanged: widget.variable == null
          ? (i) async {
              /*  if (i == 2) {
                await showModalBottomSheet(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: transparentColor),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0))),
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.width * 1.2,
                      //child: LoginNavigator()
                    );
                  },
                );
              } */
            }
          : null, */
    //itemCount: widget.videos.length,
    //);
  }
}

class VideoPage extends StatefulWidget {
  final String video;
  final String image;

  final bool? isPaused;
  final bool? isFollowing;
  final UserVideo? userVideo;

  VideoPage(this.video, this.image,
      {this.isPaused, this.isFollowing, this.userVideo});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with RouteAware {
  late VideoPlayerController _controller;
  bool initialized = false;
  bool isLiked = false;
  bool isLoading = true;
  bool isHit = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        Constraints.Video_URL + widget.userVideo!.videoName)
      ..initialize().then((value) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
          initialized = true;
          isLoading = false;
        });
      });
  }

  @override
  void didPopNext() {
    print("didPopNext");
    _controller.play();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    print("didPushNext");
    _controller.pause();
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

  @override
  Widget build(BuildContext context) {
    /* if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      _controller.play();
    } else {
      _controller.pause();
    } */

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
                  onTap: () {
                    _controller.pause();
                    Navigator.pushNamed(context, PageRoutes.userProfilePage);
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
                      AssetImage('assets/images/share_icon.png'),
                      color: buttonColor,
                    ),
                  ),
                  '${widget.userVideo!.share}',
                ),
                CustomButton(
                    ImageIcon(
                      AssetImage('assets/icons/ic_comment.png'),
                      color: buttonColor,
                    ),
                    '${widget.userVideo!.comment}', onPressed: () {
                  setState(() {});
                  commentSheet(context, null, widget.userVideo!);
                }),
                CustomButton(
                  Image.asset(
                    isLiked == true || widget.userVideo!.likeStatus == "true"
                        ? "assets/images/like_new.png"
                        : "assets/images/like_new.png",
                    color: buttonColor,
                    height: 25,
                    width: 25,
                  ),
                  '${widget.userVideo!.likes}',
                  onPressed: () {
                    isHit = true;
                    Future.delayed(Duration(seconds: 1), () {
                      likeVideo(widget.userVideo!.userId, widget.userVideo!.id);
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RotatedImage(widget.image),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: LinearProgressIndicator(color: Colors.red
                    //minHeight: 1,
                    )),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 12.0,
            bottom: 20.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("sdsd",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16.0, color: Colors.white, letterSpacing: 0.5)),
              Text("${widget.userVideo!.description}",
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
        ],
      ),
    );
  }

//like video
  Future<void> likeVideo(String userId, String videoId) async {
    Response response = await Apis().likeVideo(userId, videoId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          widget.userVideo!.likeStatus == "true"
              ? isLiked = false
              : isLiked = true;
          isHit = false;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Server Errror");
    }
  }

  // share video
  Future<void> shareVideo(String userId, String videoId) async {
    Response response = await Apis().shareVideo(userId, videoId);
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
    Response response = await Apis().getVideoComment(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        return re.map<VideoComment>((e) => VideoComment.fromJson(e)).toList();
        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

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
}
