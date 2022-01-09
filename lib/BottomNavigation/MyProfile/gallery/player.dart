import 'dart:convert';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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

class SingleVideoPlayer extends StatefulWidget {
  final String video;
//  final String image;
  //final int? pageIndex;
  //final int? currentPageIndex;
  final bool? isPaused;
  final bool? isFollowing;
  String i;
  //final UserVideo? userVideo;

  SingleVideoPlayer(
    this.video,
    this.i,
    //this.image,
    {
    //this.pageIndex,
    //this.currentPageIndex,
    this.isPaused,
    this.isFollowing,
    //this.userVideo
  });

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<SingleVideoPlayer> with RouteAware {
  late VideoPlayerController _controller;
  bool initialized = false;
  bool isLiked = false;
  bool isLoading = true;

  bool isHit = false;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.network(Constraints.Video_URL + widget.video)
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
    /*  if (!widget.isPaused! && initialized) {
      _controller.play();
    } else {
      _controller.pause();
    }
 */
//    if (_controller.value.position == _controller.value.duration) {
//      setState(() {
//      });
//    }
    /* if (widget.pageIndex == 2) _controller.pause(); */
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
                ? Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                            height: _controller.value.size.height ?? 0,
                            width: _controller.value.size.width ?? 0,
                            child: VideoPlayer(_controller))),
                  )
                : SizedBox.shrink(),
          ),
          Visibility(
            visible: widget.i == "2" ? true : false,
            child: Center(
              child: Lottie.asset(
                "assets/animation/mus.json",
                width: 250,
                height: 250,
              ),
            ),
          ),
          ProgressBar(
            progress: Duration(milliseconds: 1000),
            buffered: Duration(milliseconds: 2000),
            total: Duration(milliseconds: 5000),
            progressBarColor: Colors.red,
            thumbColor: Colors.blue,
            baseBarColor: Colors.white,
            onSeek: (duration) {
              print('User selected a new time: $duration');
            },
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: -10.0,
            bottom: 30.0,
            child: Column(
              children: <Widget>[
                /* CustomButton(
                  GestureDetector(
                    /* onTap: () {
                      shareVideo(
                          widget.userVideo!.userId, widget.userVideo!.id);
                    }, */
                    child: ImageIcon(
                      AssetImage('assets/images/share_icon.png'),
                      color: buttonColor,
                    ),
                  ),
                  '0',
                ), */

/*                 CustomButton(
                    ImageIcon(
                      AssetImage('assets/icons/ic_comment.png'),
                      color: buttonColor,
                    ),
                    '${0}', onPressed: () {
                  setState(() {});
                  commentSheet(context, widget.userVideo!);
                }), */
                /* CustomButton(
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
                ), */
                /*  Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RotatedImage(widget.image),
                ), */
              ],
            ),
          ),
          /* widget.isFollowing!
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
              : SizedBox.shrink(), */

          /*   Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: LinearProgressIndicator(color: Colors.red
                    //minHeight: 1,
                    )),
          ), */
          Align(
              alignment: Alignment.center,
              child: isLoading == true || isHit == true
                  ? SpinKitFadingCircle(
                      color: buttonColor,
                      size: 60,
                    )
                  : Container()),
        ],
      ),
    );
  }

//like video
  /* Future<void> likeVideo(String userId, String videoId) async {
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
 */
  // share video
/*   Future<void> shareVideo(String userId, String videoId) async {
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
 */
//gte Comment
//get List of comment

/*   Future<List<VideoComment>> getUserMatchPost(String userId) async {
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
 */
/*   shareApp() {
    Share.share('Bollywood clap https://example.com');
  } */
}
