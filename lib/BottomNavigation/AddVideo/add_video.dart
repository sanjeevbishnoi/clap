import 'dart:io';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:qvid/BottomNavigation/AddVideo/add_video_filter.dart';
import 'package:qvid/BottomNavigation/AddVideo/my_trimmer.dart';
import 'package:qvid/BottomNavigation/Home/home_page.dart';
import 'package:qvid/BottomNavigation/bottom_navigation.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/widget/custome_loader.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? controller;
  var selectedCamera = 1;
  String? videoPath;
  double videoLength = 30.0;
  String audioFile =
      "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3";
  //PanelController _pc1 = new PanelController();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  //variable for check video recording  enable or not

  bool videoRecorded = false;
  bool isVideoRecorded = false;

  bool isUploading = false;
  //for camera crash

  bool cameraCrash = false;

  //for show progress on start recording
  bool showProgress = false;

  //for video lenght
  double videoProgressPercent = 0;

  //
  bool reverse = false;

  //controller
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  //
  bool showLoader = false;
  //
  bool isFlash = false;
  //
  bool isDialog = false;
  //
  File? songFile;

  late AssetsAudioPlayer assetsAudioPlayer;
  @override
  void initState() {
    playMusic();
    openCamera(selectedCamera);
    WidgetsBinding.instance!.addObserver(this);
    //WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state of app $state");
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    controller!.dispose();
    //WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final ProgressDialog pr=ProgressDia
    songFile = ModalRoute.of(context)!.settings.arguments as File;

    showLoade();
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    double zoom = 1.0;
    double _scaleFactor = 1.0;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: FadedSlideAnimation(
          Stack(
            children: <Widget>[
              controller == null
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(controller!),
              AppBar(
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCamera == 0) {
                          selectedCamera = 1;
                        } else {
                          selectedCamera = 0;
                        }
                        openCamera(selectedCamera);
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Image.asset(
                          "assets/icons/swap_camera.png",
                          width: 45,
                          height: 45,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              Positioned(
                  top: 130,
                  right: 17,
                  child: InkWell(
                    onTap: () {
                      print("sdsd");
                    },
                    child: Card(
                        color: backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text("30sec",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )),
                  )),
              Positioned(
                  top: 200,
                  right: 20,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/user/user1.png"),
                    radius: 20,
                  )),
              isDialog == true
                  ? Align(
                      alignment: Alignment.center,
                      child: CustomeLoader.customLoader,
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Positioned(
                  top: 85,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      //print("sdsd");
                      /* Navigator.pushNamedAndRemoveUntil(
                          context, PageRoutes.choose_music); */
                      Navigator.pushNamed(context, PageRoutes.choose_music);
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/icons/music_icon.png"),
                      radius: 20,
                    ),
                  )),
              (controller == null ||
                      !controller!.value.isInitialized ||
                      !controller!.value.isRecordingVideo)
                  ?
                  //visible when recording in progress
                  Positioned(
                      width: wt,
                      bottom: 1,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _openGallery(),
                              child: Image.asset(
                                "assets/icons/gallery.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: videoCall,
                                  child: controller != null
                                      ? Icon(
                                          Icons.videocam,
                                          color: secondaryColor,
                                          size: 30,
                                        )
                                      : Text("sorry")),
                              /* onTap: () => Navigator.pushNamed(
                          context, PageRoutes.addVideoFilterPage), */
                              onTap: _startRecordering,
                            ),
                            InkWell(
                              onTap: () async {
                                if (!isFlash) {
                                  controller!.setFlashMode(FlashMode.always);
                                  print("On");
                                  setState(() {
                                    isFlash = true;
                                  });
                                } else {
                                  controller!.setFlashMode(FlashMode.off);
                                  print("off");
                                  setState(() {
                                    isFlash = false;
                                  });
                                }
                              },
                              child: Icon(
                                isFlash == true
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              (showProgress)
                  ? Positioned(
                      bottom: 71,
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width,
                        lineHeight: 6.0,
                        animationDuration: 100,
                        percent: videoProgressPercent,
                        progressColor: Color(0xffec4a63),
                      ),
                    )
                  : Container(),
              (controller != null &&
                      controller!.value.isInitialized &&
                      controller!.value.isRecordingVideo)
                  ? Positioned(
                      width: wt,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: ElevatedButton(
                                onPressed: () {
                                  assetsAudioPlayer.dispose();
                                  Navigator.of(context).pop();
                                },
                                child: Text("Previous")),
                          ),
                          InkWell(
                            onTap: () {
                              //check condition
                              setState(() {
                                reverse = reverse;
                              });
                              if (!videoRecorded) {
                                onResumeButtonPressed();
                                // _animationController!.forward();
                              } else {
                                onPauseButtonPressed();
                                //_animationController!.stop();
                              }
                            },
                            child: Image.asset(
                              !videoRecorded
                                  ? "assets/icons/play-icon.png"
                                  : "assets/icons/pause-icon.png",
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                                onPressed: () {
                                  _onStopButtonPressed();
                                },
                                child: Text("Next  ")),
                          )
                        ],
                      ))
                  : Container(),
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    if (selectedCamera == 0) {
                      selectedCamera = 1;
                    } else {
                      selectedCamera = 0;
                    }
                    openCamera(selectedCamera);
                  });
                },
                onScaleStart: (one) {
                  zoom = _scaleFactor;
                  /*         if (zoom < 8) {
                    zoom = zoom + 1;
                  }
                  controller!.setZoomLevel(zoom); */
                },
                onScaleUpdate: (one) {
                  setState(() {
                    _scaleFactor = zoom * one.scale.toInt();
                    if (one.scale.toInt() < 8 && one.scale.toInt() > 0) {
                      print(one.scale.toInt());
                      if (_scaleFactor < 8.0 && _scaleFactor > 0.0)
                        controller!.setZoomLevel(_scaleFactor);
                    }
                  });
                },
              )
            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }

  void openCamera(int index) async {
    cameras = await availableCameras();
    print(cameras.length);

    controller =
        CameraController(cameras[selectedCamera], ResolutionPreset.max);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  //create instace of trimmer
  //final Trimmer _trimmer = Trimmer();

  Future _openGallery() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowCompression: true);
    File? file;

    if (result != null) {
      file = File(result.files.single.path!);

      /*   setState(() {
      if (file != null) {
        
        print("video selected");
      } else {
        print('No Video  selected.');
      }
    }); */
    }

    //trim video by video trimmer

    if (file != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TrimmerView(file!, 1)));
      /* await _trimmer.loadVideo(videoFile: file!);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TrimmerVie(_trimmer, (output) async {
          setState(() {
            videoPath = output;
          });
          print("videoPath");
          Navigator.pop(context);
          setState(() {
            // isUploading = true;
          });
          String responseVideo = "";
          // responseVideo = await uploadVideo();
          if (responseVideo != "") {
            _pc1.open();
          }
        }, videoLength, audioFile);
      })); */
    }
  }

  void _startRecordering() async {
    setState(() {
      videoRecorded = true;
      isVideoRecorded = true;
    });
    _startVideoRecording().then((String filePath) {
      if (filePath.isNotEmpty) {
        setState(() {
          showProgress = true;
          startTimer();
        });
      }
    });
  }

  //start video recording

  Future<String> _startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      return "";
    }

    //play asset audio player
    //_assetsAudioPlayer.play();

    // Do nothing if a recording is on progress
    if (controller!.value.isRecordingVideo) {
      return "";
    }

    final Directory? appDirectory = await getExternalStorageDirectory();
    final String videoDirectory = '${appDirectory!.path}/Videos';
    print("VideoDirectory" + videoDirectory);
    await Directory(videoDirectory).create(recursive: true);
    /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';
    try {
      await controller!.startVideoRecording();

      videoPath = filePath;

      //check video path
      print(videoPath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return "";
    }

    return filePath;
  }

  //show camera exception

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);
    setState(() {
      cameraCrash = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //show here exception widget
        child: Text("Camera stop working"),
      ),
    );
  }

  //start timer
  Timer? timer;
  startTimer() {
    timer = Timer.periodic(new Duration(milliseconds: 100), (timer) {
      setState(() {
        print(timer.tick);
        videoProgressPercent += 1 / (videoLength * 10);
        print(videoProgressPercent);
        if (videoProgressPercent >= 1) {
          videoProgressPercent = 1;
          timer.cancel();
          _onStopButtonPressed();
        }
      });
    });
  }

//handle stop button

  _onStopButtonPressed() {
    assetsAudioPlayer.dispose();
    setState(() {
      //work of upload here...
      showProgress = false;
      videoRecorded = false;
      print("showing dialog");
      isDialog = true;
    });
    _stopVideoRecording().then((String outputVideo) async {
      print("_loadingStreamCtrl.true");
      setState(() {
        print("dissmiss dialog");
        isDialog = false;
      });

//      _loadingStreamCtrl.sink.add(true);
      if (mounted)
        setState(() {
          showDialog(
              context: context,
              builder: (context) {
                return FutureProgressDialog(
                  playVideo(outputVideo),
                  message: Text("Loading..."),
                );
              });
        });
    });
  }

  late String reelPath;
  //stop video here
  Future<String> _stopVideoRecording() async {
    print("sdsds");
    setState(() {
      isUploading = true;
      print("_loadingStreamCtrl.true");
//      _loadingStreamCtrl.sink.add(true);
    });
    //assetsAudioPlayer.pause();
    if (!controller!.value.isRecordingVideo) {
      return "";
    }
    try {
      XFile videoFile = await controller!.stopVideoRecording();
      videoPath = videoFile.path;
      print(videoFile.path);
    } on CameraException catch (e) {
      _showCameraException(e);
      return "";
    }

    final Directory? appDirectory = await getExternalStorageDirectory();
    final String outputDirectory = '${appDirectory!.path}/outputVideos';
    await Directory(outputDirectory).create(recursive: true);
    /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String outputVideo = '$outputDirectory/$currentTime.mp4';
    print(outputVideo);

    // final String thumbNail = '$outputDirectory/${currentTime}.png';
    // final String thumbGif = '$outputDirectory/${currentTime}.gif';
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    // String aFPath = '${appDirectory.path}/Audios/$audioFile';
    String responseVideo = "";
//    _loadingStreamCtrl.sink.add(true);

    final info = await VideoCompress.compressVideo(
      videoPath!,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: true,
    );

    print("compressed");

    setState(() {
      if (info != null) {
        videoPath = info.path;
        reelPath = info.path!;

        //print("videoPath" + videoPath!);
      }
    });

//    await _startVideoPlayer(videoPath);

//    responseVideo = await uploadVideo();
    /*   if (progress >= 100.0) {
      print("progress 100");
    } */
//    String aFPath = '${appDocDir.parent.path}' + '/$audioFile';
//    audioFile = "https://www.rachelallan.com/sara_rasines.mp3";
//    aFPath = "https://www.rachelallan.com/sarah_rasines.mp3";
    print("Merge Audio");
    /*if (audioFile != "") {
      _flutterFFmpeg
          .execute(
              "-i $videoPath -i $audioFile -c:v libx264 -c:a aac -ac 2 -ar 22050 -map 0:v:0 -map 1:a:0 -shortest $outputVideo")
          .then((rc) => print("FFmpeg process exited with rc $rc"));

      */ /*setState(() {
        videoPath = outputVideo;
      });*/ /*
    } else {
      _flutterFFmpeg
          .execute("-i $videoPath -vcodec libx265 -crf 28 $outputVideo")
          .then((rc) => print("FFmpeg process exited with rc $rc"));

      */ /*setState(() {
        videoPath = outputVideo;
      });*/ /*
    }*/
    /*_flutterFFmpeg
        .execute("-i $videoPath -ss 00:00:01.000 -vframes 1 $thumbNail")
        .then((rc) => print("FFmpeg process exited with rcthumb $rc"));
    _flutterFFmpeg
        .execute(
            "-ss 0 -t 3 -i $videoPath -vf 'fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse' -loop 0 $thumbGif")
        .then((rc) async {
      print("FFmpeg process exited with rcgif $rc");

      setState(() {
        isConverting = false;
        thumbFile = thumbNail;
        gifFile = thumbGif;
      });
    });*/
    if (responseVideo != '') {
      print("dsdsds" + responseVideo);
//      _loadingStreamCtrl.sink.add(false);
      /*setState(() {
        videoPath = outputVideo;
      });*/
      //await _startVideoPlayer(responseVideo);
    }

    return reelPath;
  }

  //start video player

//handle resume here

  void onResumeButtonPressed() {
    //assetsAudioPlayer.play();
    resumeVideoRecording().then((_) {
      if (mounted)
        setState(() {
          videoRecorded = true;
          startTimer();
        });
    });
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

//handle pause action button
  void onPauseButtonPressed() async {
    assetsAudioPlayer.pause();
    pauseVideoRecording().then((_) {
      if (mounted)
        setState(() {
          videoRecorded = false;
          timer!.cancel();
        });
    });
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

//for stop video recording

  Future<void> playVideo(String filePath) async {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddVideoFilter(videoPath: filePath)));
    });
  }

  showLoade() async {
    /*   final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.style(message: "Loading...");
    isDialog == true ? await pr.show() : await pr.hide(); */
  }

  void playAudio(File songFile) async {
    print("song playing");
    await assetsAudioPlayer.open(Audio.file(songFile.path));
    assetsAudioPlayer.play();
    _startRecordering();
  }

  void playMusic() {
    Future.delayed(Duration(seconds: 2), () {
      assetsAudioPlayer = AssetsAudioPlayer();
      setState(() {
        if (songFile != null) {
          playAudio(songFile!);
        } else {
          print("sorry");
        }
      });
    });
  }

  //selectedIndex = index;

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    Navigator.push  (
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return true;
  }
}
