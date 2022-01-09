import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qvid/BottomNavigation/AddVideo/post_info.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/widget/custome_loader.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class AddVideoFilter extends StatefulWidget {
  File? file;
  AddVideoFilter({required this.videoPath, this.file});

  final String videoPath;

  @override
  _AddVideoFilterState createState() => _AddVideoFilterState();
}

class _AddVideoFilterState extends State<AddVideoFilter> {
  String appluFilterPath = "";
  List<BlendMode> blendMode = [
    BlendMode.dstATop,
    BlendMode.dst,
    BlendMode.hue,
    BlendMode.hardLight,
    BlendMode.modulate,
    BlendMode.dstATop,
    BlendMode.hardLight,
    BlendMode.darken,
    BlendMode.src,
    BlendMode.exclusion,
    BlendMode.overlay,
    BlendMode.dstOut,
    BlendMode.darken,
    BlendMode.darken,
  ];

  /* List<Color?> color = [
    Color(0xff7c94b6),
    Colors.orange[200],
    Colors.grey[300],
    Colors.grey[400],
    Colors.blueAccent[400],
    Colors.blueGrey[400],
    Colors.grey[300],
    Colors.blueGrey[400],
  ]; */

  List<String> images = [
    "assets/images/no_filter.webp",
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
    'assets/images/slider4.jpg',
  ];

  List<Color?> myFilterColor = [
    Color(0xff7c94b6),
    Color(0xff7c94b6),
    Colors.orange[200],
    Colors.grey[300],
    Colors.grey[400],
    Colors.blueAccent[400],
    Colors.blueGrey[400],
    Colors.grey[300],
    Colors.blueGrey[400],
    Color(0xff704214),
    Color(0xff9a8b4f),
    Color(0xffb89b72),
    Color(0xff674AB3),
    Color(0xffCACACA),
    Color(0xffF4F4F4),
  ];

  bool isFilterApply = false;

  String newPath = "";

  bool isDialog = false;

  late VideoPlayerController _controller;

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("apply filterptah $appluFilterPath");
    newPath = widget.videoPath;

    _controller = VideoPlayerController.file(
      File(isFilterApply == true ? appluFilterPath : newPath),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  Future<void> applyFilter({Color? filterColor, int? i}) async {
    print("this is normal filter");
    print(i);
    _controller.pause();
    final tapiocaBalls = <TapiocaBall>[
      TapiocaBall.filterFromColor(filterColor!)
    ];

    final cup = Cup(Content(widget.videoPath), tapiocaBalls);
    final Directory? appDirectory = await getExternalStorageDirectory();
    final String outputDirectory = '${appDirectory!.path}/filterdVideos';
    await Directory(outputDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String path = '$outputDirectory/$currentTime.mp4';
    //var tempDir = await getTemporaryDirectory();
    //final path = '${tempDir.path}/$t.mp4';

    cup.suckUp(path).then((_) {
      print("finish processing");
      print(path);
      setState(() {
        if (i == 0) {
          appluFilterPath = path;
          isFilterApply = false;
          isDialog = false;
          _controller = VideoPlayerController.file(File(newPath))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                /* _controller.play();
              _controller.setLooping(true); */
              });
            });
        } else {
          appluFilterPath = path;
          isFilterApply = true;
          isDialog = false;
          _controller = VideoPlayerController.file(
              File(isFilterApply == true ? appluFilterPath : newPath))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                /* _controller.play();
              _controller.setLooping(true); */
              });
            });
        }
      });

      /*
      setState(() {
        newPath = path;
        isFilterApply = true;
      }); */
    });
  }

  @override
  Widget build(BuildContext context) {
    //showLoade();
    return Stack(
      children: <Widget>[
        AppBar(
          actions: [],
        ),
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ),
              )
            : Container(),
        isDialog == true
            ? Align(
                alignment: Alignment.center,
                child: CustomeLoader.customLoader,
              )
            : Container(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 72,
            margin: EdgeInsets.only(bottom: 78.0, left: 12.0, right: 12),
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isDialog = true;
                      });

                      Color? mycolor = myFilterColor[index];
                      applyFilter(filterColor: mycolor!, i: index);
                    },
                    child: FadedScaleAnimation(
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    myFilterColor[index]!, blendMode[index]),
                                image: AssetImage(images[index]),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 72,
                        width: 72,
                        //child: Image.asset(images[index], fit: BoxFit.fill,),
                      ),
                    ),
                  );
                }),
          ),
        ),

        /* Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                CustomButton(
                  color: transparentColor,
                  icon: Icon(
                    Icons.music_note,
                    color: secondaryColor,
                  ),
                  text: AppLocalizations.of(context)!.addMusic,
                  onPressed: () {},
                ),
                Spacer(),
                CustomButton(
                  text: AppLocalizations.of(context)!.next,
                  onPressed: () =>
                      Navigator.pushNamed(context, PageRoutes.postInfoPage),
                )
              ],
            ),
          ),
        ), */

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)))),
                        onPressed: () {
                          /*  setState(() {
                            isDialog = true;
                            showLoade();
                          });
 */
                          Navigator.of(context).pop();
                          /* showDialog(
                              context: context,
                              builder: (context) => FutureProgressDialog(
                                    applyFilter(Colors.transparent),
                                    message: Text("Loading..."),
                                  )); */

                          //applyFilter();
                        },
                        child: Text("Go Back")),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Image.asset(
                      _controller.value.isPlaying
                          ? "assets/icons/pause-icon.png"
                          : "assets/icons/play-icon.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)))),
                        onPressed: () async {
                          //applyFilter(i: 2);
                          print("filterPath $appluFilterPath");
                          print("newPath $newPath");
                          String filePath = isFilterApply == true
                              ? appluFilterPath
                              : widget.file!.path;
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pop();
                            /* Navigator.pushNamed(
                                context, PageRoutes.postInfoPage,
                                arguments: filePath); */
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostInfo(filePath: filePath)));
                          });
                          print("file path $filePath");
                        },
                        child: Text("Post")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  late String reelPath;
  Future<String> compressVideo(String filePath) async {
    String pat;
    final info = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: true,
    );
    setState(() {
      if (info != null) {
        reelPath = info.path!;

        //print("videoPath" + videoPath!);
      }
    });
    return reelPath;
  }
}
