import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qvid/BottomNavigation/AddVideo/my_trimmer.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/chewie_player.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/flick_player.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/player.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/report.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/image_upload_mode.dart';
import 'package:qvid/model/upload_video.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_compress/video_compress.dart';

class SelectVideos extends StatefulWidget {
  @override
  State<SelectVideos> createState() => _SelectVideosState();
}

class _SelectVideosState extends State<SelectVideos> {
  static List<Object> images = [];
  List<UploadVideo> videos = [];
  bool isLoading = true;
  late Future<File> _imageFile;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      getUsersVideos();
    });
    /* setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    }); */
  }

  @override
  void dispose() {
    Navigator.of(context).pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: buildGridView(),
        ),
      ],
    ));
  }

  Widget buildGridView() {
    return isLoading == false
        ? StaggeredGridView.countBuilder(
            crossAxisCount: 6,
            shrinkWrap: true,
            reverse: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (context, index) {
              if (images[index] is UploadVideo) {
                dynamic uploadVideo = images[index] as UploadVideo;
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleVideoPlayer(
                                  uploadVideo.videoName, "1")));
                      /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlickerDemoPlayer(
                                    fileName: '${uploadVideo.videoName}',
                                  ))); */
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                height: 140,
                                color: cardColor,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 5, right: 5),
                                            child: Icon(Icons.close,
                                                color: Colors.red),
                                          ),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        print(uploadVideo.id);
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateOption(
                                                      caption: uploadVideo
                                                          .videoCaption,
                                                      videoId: uploadVideo.id,
                                                      viewOption: uploadVideo
                                                          .viewOption,
                                                      i: 2,
                                                    )));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 5),
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        openDeleteDialog(uploadVideo);
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 5),
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    child: Container(
                      width: 200,
                      height: 150,
                      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                      //color: Colors.red,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            child: Stack(
                              children: [
                                uploadVideo != null
                                    ? CachedNetworkImage(
                                        imageUrl: Constraints.COVER_IMAGE_URL +
                                            uploadVideo.img!,
                                        fit: BoxFit.fill,
                                        height: 100,
                                        width: 200,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                                baseColor: Colors.grey.shade500,
                                                highlightColor:
                                                    Colors.grey.shade300,
                                                enabled: true,
                                                child: Container(
                                                    color: Colors.white)))
                                    : Image.asset(
                                        "assets/images/banner 1.png",
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.fill,
                                      ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Icon(Icons.play_arrow)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            uploadVideo.videoCaption,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    )

                    /*  Card(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        //uploadModel.imageFile,

                        uploadVideo != null
                            ? CachedNetworkImage(
                                imageUrl: Constraints.COVER_IMAGE_URL +
                                    uploadVideo.img!,
                                fit: BoxFit.fill,
                                width: 200,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey.shade500,
                                        highlightColor: Colors.grey.shade300,
                                        enabled: true,
                                        child: Container(color: Colors.white)))
                            : Image.asset(
                                "assets/images/banner 1.png",
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Icon(Icons.play_arrow)),
                        ),
                        Text(
                          uploadVideo.videoCaption,
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ), */
                    );
              } else {
                return Container(
                  height: 120,
                  width: 200,
                  child: Card(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        getVideoFile();
                        // Navigator.pushNamed(context, PageRoutes.addVideoPage);
                        // Navigator.pushNamed(context, PageRoutes.addVideoPage);
                      },
                    ),
                  ),
                );
              }
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 2.0,
          )
        : Center(
            child: SpinKitFadingCircle(
            color: Colors.yellow,
          ));
  }

  double percent = 0;
  Timer? timer;
  void getVideoFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowCompression: true);
    File? file;
    if (result != null) {
      isLoading = true;

      timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
        setState(() {
          percent += 10;
          if (percent >= 100) {
            timer!.cancel();
            // percent=0;
          }
        });
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Row(
                  children: [
                    /*            CircularPercentIndicator(
                      radius: 60.0,
                      animation: true,
                      lineWidth: 5.0,
                      percent: percent / 100,
                      center: new Text(
                        percent.toString() + "%",
                        style: TextStyle(color: Colors.black),
                      ),
                      progressColor: Colors.green,
                    ), */

                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ));
      //trim video by video trimmer
      final info = await VideoCompress.compressVideo(
        result.files.single.path!,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: true,
      );
      file = File(info!.path!);
      if (file != null) {
        isLoading = false;
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TrimmerView(file!, 2)));
      }
    }
  }

  UpdateData() {
    Future.delayed(Duration(seconds: 1), () {
      getUsersVideos();
    });
  }

  Future getUsersVideos() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getVideos(user.id, user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print(re.length);

        if (mounted)
          setState(() {
            videos =
                re.map<UploadVideo>((e) => UploadVideo.fromJson(e)).toList();
            images = List.from(videos);
            //images.add("Add Image");
            images.add(1);

            isLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;

        setState(() {
          images = [];
          images.add(1);
          isLoading = false;
        });
      }
    } else {
      MyToast(message: "Internet is slow").toast;
    }
  }

  Future deleteVideo(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteVideo(user.id, id);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);

      if (res == "success") {
        setState(() {
          Future.delayed(Duration(seconds: 1), () {
            getUsersVideos();
          });
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }

  void openDeleteDialog(UploadVideo uploadVideo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text("Are You Sure want to Delete Video"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(deleteVideo(uploadVideo.id!)));
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }
}

class UserVideo extends StatefulWidget {
  String userId;
  UserVideo({required this.userId});
  @override
  _UserVideoState createState() => _UserVideoState();
}

class _UserVideoState extends State<UserVideo> {
  bool isLoading = true;
  List<UploadVideo> videoList = [];
  List<Object> images = [];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getVideos(widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? videoList.isEmpty
              ? Center(
                  child: Lottie.asset(
                    "assets/animation/no-data.json",
                    width: 250,
                    height: 250,
                  ),
                )
              : StaggeredGridView.countBuilder(
                  crossAxisCount: 6,
                  shrinkWrap: true,
                  reverse: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    dynamic uploadVideo = images[index] as UploadVideo;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleVideoPlayer(
                                    uploadVideo.videoName, "1")));

                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlickerDemoPlayer(
                                      fileName: '${uploadVideo.videoName}',
                                    ))); */
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChewieDemoPlayer(
                                      fileName: '${uploadVideo.videoName}',
                                    ))); */
                      },
                      onLongPress: () {
                        showBottomSheet(uploadVideo);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 150,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 130,
                                width: 200,
                                child: Stack(
                                  children: <Widget>[
                                    //uploadModel.imageFile,

                                    uploadVideo != null
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                Constraints.COVER_IMAGE_URL +
                                                    uploadVideo.img!,
                                            fit: BoxFit.fill,
                                            width: 200,
                                            height: 120,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade500,
                                                    highlightColor:
                                                        Colors.grey.shade300,
                                                    enabled: true,
                                                    child: Container(
                                                        color: Colors.white)))
                                        : Image.asset(
                                            "assets/images/banner 1.png",
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.fill,
                                          ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Icon(Icons.play_arrow)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                uploadVideo.videoCaption,
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 2.0,
                )
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.yellow,
              ),
            ),
    );
  }

  Future getVideos(String userId) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getVideos(userId, user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print(re.length);

        if (mounted)
          setState(() {
            videoList =
                re.map<UploadVideo>((e) => UploadVideo.fromJson(e)).toList();
            images = List.from(videoList);
            //images.add("Add Image");

            isLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;

        setState(() {
          images = [];
          isLoading = false;
        });
      }
    } else {
      MyToast(message: "Internet is slow").toast;
    }
  }

  void showBottomSheet(UploadVideo uploadVideo) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 70,
              color: cardColor,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportOn(
                                  i: 2, type: "video", id: uploadVideo.id!)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.report, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Report",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ));
  }
}
