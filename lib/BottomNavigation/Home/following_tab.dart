import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/Components/custom_button.dart';
import 'package:qvid/Components/rotated_image.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/controller/player_screen_controller.dart';
import 'package:qvid/model/user_video.dart';
import 'package:video_player/video_player.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FollowingTabPage extends StatelessWidget {
  final List<UserVideo> videos;
  final List<String> images;
  final bool isFollowing;
  final int? variable;
  FollowingTabPage(this.videos, this.images, this.isFollowing, {this.variable});

  @override
  Widget build(BuildContext context) {
    return FollowingTabBody(videos, images, isFollowing, variable);
  }
}

class FollowingTabBody extends StatefulWidget {
  final List<UserVideo> videos;
  final List<String> images;

  final bool isFollowing;
  final int? variable;
  List<UserVideo> list = [];
  FollowingTabBody(this.videos, this.images, this.isFollowing, this.variable);

  @override
  _FollowingTabBodyState createState() => _FollowingTabBodyState();
}

class _FollowingTabBodyState extends State<FollowingTabBody> {
  PageController? _pageController;
  int current = 0;

  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _pageController!.page == _pageController!.page!.roundToDouble()) {
      setState(() {
        current = _pageController!.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        current.toDouble() != _pageController!.page) {
      if ((current.toDouble() - _pageController!.page!).abs() > 0.1) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
        return VideoPage(
          widget.videos[position].videoName,
          widget.images[position],
          pageIndex: position,
          currentPageIndex: current,
          isPaused: isOnPageTurning,
          isFollowing: widget.isFollowing,
        );
      },
      onPageChanged: widget.variable == null
          ? (i) async {
              if (i == 2) {
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
              }
            }
          : null,
      itemCount: widget.videos.length,
    );
  }
}

class VideoPage extends StatefulWidget {
  final String video;
  final String image;
  final int? pageIndex;
  final int? currentPageIndex;
  final bool? isPaused;
  final bool? isFollowing;

  VideoPage(this.video, this.image,
      {this.pageIndex, this.currentPageIndex, this.isPaused, this.isFollowing});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with RouteAware {
  late VideoPlayerController _controller;
  bool initialized = false;
  bool isLiked = false;

  var contr = Get.put(PlayerScreenController());
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((value) {
        setState(() {
          _controller.setLooping(true);
          initialized = true;
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
    _controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((value) {
        setState(() {
          initialized = true;
        });
      });
    routeObserver.unsubscribe(this);
    _controller.dispose();
    //Get.back();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      /* contr.isPlay.value == true ?  */ _controller
          .play(); /*  : _controller.pause(); */
    } else {
      //contr.isPlay.value == true ? _controller.play() : _controller.pause();_controller.pause();
    }

//    if (_controller.value.position == _controller.value.duration) {
//      setState(() {
//      });
//    }
    if (widget.pageIndex == 2) _controller.pause();
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
                ? VideoPlayer(_controller)
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
                    //  Navigator.pushNamed(context, PageRoutes.userProfilePage);
                  },
                  child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/user_icon.png')),
                ),
                CustomButton(
                  ImageIcon(
                    AssetImage('assets/icons/ic_views.png'),
                    color: secondaryColor,
                  ),
                  '1.2k',
                ),
                CustomButton(
                    ImageIcon(
                      AssetImage('assets/icons/ic_comment.png'),
                      color: secondaryColor,
                    ),
                    '287', onPressed: () {
                  commentSheet(context);
                }),
                CustomButton(
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: secondaryColor,
                  ),
                  '8.2k',
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
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
                        color: secondaryColor,
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
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '@atul123',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                TextSpan(text: "Wor so nice"),
                TextSpan(
                    text: 'See More',
                    style: TextStyle(
                        color: secondaryColor.withOpacity(0.5),
                        fontStyle: FontStyle.italic))
              ]),
            ),
          )
        ],
      ),
    );
  }
}
