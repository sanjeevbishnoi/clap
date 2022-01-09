import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:qvid/BottomNavigation/AddVideo/add_video_filter.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/audios.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/videos.dart';
import 'package:qvid/BottomNavigation/MyProfile/my_profile_page.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;
  int i;

  TrimmerView(this.file, this.i);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  TextEditingController _caption = TextEditingController();
  bool _isPlaying = false;
  bool _progressVisibility = false;

  bool isDialog = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;
    //String tempPath = (await getLocalOrTempDir()).path;
    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            customVideoFormat: ".mp4",
            videoFolderName: "filterdVideos",
            storageDir: StorageDir.externalStorageDirectory)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    fetchThumbnil();
    _loadVideo();
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Trim your video here..."),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                /*  Visibility(
                  visible: widget.i == 2 || widget.i == 3 ? true : false,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: _caption,
                        decoration: InputDecoration(
                          hintText: "Enter Caption",
                          hintStyle: TextStyle(color: Colors.white),
                          alignLabelWithHint: true,
                          labelText: "Enter Caption",
                          labelStyle: TextStyle(color: disabledTextColor),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          setState(() {});
                        },
                      )),
                ), */
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimEditor(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    //maxVideoLength: Duration(seconds: widget.i == 3 ? 30 : 0),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 80.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 80.0,
                                color: Colors.white,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: widget.i == 1 ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: _progressVisibility
                              ? null
                              : () async {
                                  setState(() {
                                    isDialog = true;
                                    showLoade();
                                  });
                                  _saveVideo().then((outputPath) {
                                    setState(() {
                                      isDialog = false;
                                      showLoade();
                                    });
                                    print('OUTPUT PATH: $outputPath');
                                    _trimmer.dispose();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddVideoFilter(
                                                  videoPath: outputPath!,
                                                  file: widget.file,
                                                )));
                                    /*   final snackBar = SnackBar(
                                    content: Text('Video Saved successfully'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar,
                                ); */
                                  });
                                },
                          child: Text("SAVE"),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.i == 2 || widget.i == 3 ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            _saveVideo().then((outputPath) {
                              _trimmer.dispose();
                              widget.i == 2
                                  ? fetchThumbnil().then((path) =>
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateOption(
                                                    path: path,
                                                    outputPath: outputPath!,
                                                    caption: _caption.text,
                                                    videoId: "",
                                                    viewOption: "",
                                                    i: 1,
                                                  ))))
                                  : showPopup(outputPath!);
                            });
                          },
                          child: Text("Upload"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showLoade() async {
    /*  final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.style(message: "Loading...");
    isDialog == true ? await pr.show() : await pr.hide(); */
  }

  Future<String> fetchThumbnil() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.file.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    print("hi this is new thubmnail $fileName");
    return fileName!;
  }

  Future uploadAudio(String path, String caption) async {
    print("path is $path");
    File trimmedAudioFile = File(path);
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().uploadAudio(user.id, trimmedAudioFile, caption);
    var statusCode = res.statusCode;
    print(res.body);
    print(statusCode);
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyProfilePage()));
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  void showPopup(String path) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                  color: cardColor,
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.close,
                                  color: Colors.red, size: 30))),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            controller: _caption,
                            decoration: InputDecoration(
                              hintText: "Enter Caption",
                              hintStyle: TextStyle(color: Colors.white),
                              alignLabelWithHint: true,
                              labelText: "Enter Caption",
                              labelStyle: TextStyle(color: disabledTextColor),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              setState(() {});
                            },
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) => FutureProgressDialog(
                                  uploadAudio(path, _caption.text)));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Upload",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  )),
            ));
  }
}

class UpdateOption extends StatefulWidget {
  String? path;
  String? outputPath;
  String caption = "";
  String videoId = "";
  String viewOption = "";
  int i = 0;

  UpdateOption(
      {this.path,
      this.outputPath,
      required this.caption,
      required this.videoId,
      required this.viewOption,
      required this.i});

  @override
  _UpdateOptionState createState() => _UpdateOptionState();
}

class _UpdateOptionState extends State<UpdateOption> {
  String _userUploadOption = uploadOption[0];
  TextEditingController _caption = TextEditingController();
  @override
  void initState() {
    setState(() {
      print(widget.viewOption);
      _caption.text = widget.caption;
      _userUploadOption = widget.viewOption.isEmpty
          ? uploadOption[0]
          : widget.viewOption == "Public"
              ? uploadOption[1]
              : widget.viewOption == "Private"
                  ? uploadOption[0]
                  : uploadOption[2];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Choose Option",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          //  color: cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: true,
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: _caption,
                      decoration: InputDecoration(
                        hintText: "Enter Caption",
                        hintStyle: TextStyle(color: Colors.white),
                        alignLabelWithHint: true,
                        labelText: "Enter Caption",
                        labelStyle: TextStyle(color: disabledTextColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        setState(() {});
                      },
                    )),
              ),
              ListTile(
                //contentPadding: EdgeInsets.all(0),
                title: const Text(
                  'Private',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                //horizontalTitleGap: 1,
                leading: Radio<String>(
                  value: uploadOption[0],
                  fillColor:
                      MaterialStateColor.resolveWith((states) => buttonColor),
                  activeColor: buttonColor,
                  groupValue: _userUploadOption,
                  onChanged: (value) {
                    setState(() {
                      _userUploadOption = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Public",
                    style: TextStyle(
                      fontSize: 14,
                    )),
                //horizontalTitleGap: 1,
                leading: Radio<String>(
                  value: uploadOption[1],
                  activeColor: buttonColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => buttonColor),
                  groupValue: _userUploadOption,
                  onChanged: (value) {
                    setState(() {
                      _userUploadOption = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Casting Director',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                //horizontalTitleGap: 1,
                leading: Radio<String>(
                  value: uploadOption[2],
                  activeColor: buttonColor,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => buttonColor),
                  groupValue: _userUploadOption,
                  onChanged: (value) {
                    setState(() {
                      _userUploadOption = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (_caption.text.isEmpty) {
                    MyToast(message: "Please Enter Caption").toast;
                    return;
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(widget
                                .videoId.isEmpty
                            ? uploadVideo(
                                widget.path!, widget.outputPath!, _caption.text)
                            : updateVideo(widget.videoId, _userUploadOption)));
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Upload",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ));
  }

  Future uploadVideo(String path, String outputPath, String caption) async {
    print("path is $path");
    File coverFile = File(path);
    File trimmedFile = File(outputPath);
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().uploadVideo(
        user.id, _userUploadOption, trimmedFile, coverFile, caption);
    var statusCode = res.statusCode;
    print(res.body);
    print(statusCode);
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.myProfile);
          SelectVideos().createState().initState();
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  Future updateVideo(String videoId, String viewOption) async {
    print("videoId $videoId");
    print('dsdsd');
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res =
        await Apis().updateVideo(user.id, videoId, viewOption, _caption.text);
    var statusCode = res.statusCode;
    print(res.body);
    print(statusCode);
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.myProfile);
          SelectVideos().createState().initState();
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }
}
