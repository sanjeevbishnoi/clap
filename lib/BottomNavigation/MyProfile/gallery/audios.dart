import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/AddVideo/my_trimmer.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/flick_player.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/player.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/report.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/image_upload_mode.dart';
import 'package:qvid/model/upload_audios.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:video_compress/video_compress.dart';

class SelectDocument extends StatefulWidget {
  @override
  State<SelectDocument> createState() => _SelectDocumentState();
}

class _SelectDocumentState extends State<SelectDocument> {
  List<Object> images = [];
  File? _imageFile;
  List<UploadAudio> audios = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      getUsersAudios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: isLoading == false
              ? buildGridView()
              : SpinKitFadingCircle(color: Colors.yellow),
        ),
      ],
    ));
  }

  Widget buildGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 6,
      shrinkWrap: true,
      reverse: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      itemBuilder: (context, index) {
        if (images[index] is UploadAudio) {
          dynamic uploadModel = images[index] as UploadAudio;
          return GestureDetector(
            onTap: () {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SingleVideoPlayer(uploadModel.audioName, "2"))); */

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FlickerDemoPlayer(
                            fileName: '${uploadModel.audioName}',
                          )));
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
                                    child: Icon(Icons.close, color: Colors.red),
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                //print(uploadVideo.id);
                                Navigator.of(context).pop();
                                showPopup(uploadModel);
                                /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateOption(
                                                    caption: uploadVideo
                                                        .videoCaption,
                                                    videoId: uploadVideo.id,
                                                    viewOption:
                                                        uploadVideo.viewOption,
                                                    i: 2,
                                                  ))); */
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, top: 5),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                openDeleteDialog(uploadModel);
                                // openDeleteDialog(uploadVideo);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, top: 5),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ],
                        ),
                      ));
            },
            child: Container(
              height: 150,
              width: 200,
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 200,
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/music.jpg",
                          width: 200,
                          fit: BoxFit.fill,
                          height: 120,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child:
                                  Icon(Icons.play_arrow, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    uploadModel.audioCaption,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            height: 120,
            width: 200,
            child: Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddImageClick(index);
                },
              ),
            ),
          );
        }
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 2.0,
    );
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    setState(() {
      ImageUploadModel imageUpload =
          new ImageUploadModel(false, false, _imageFile, '');
      /* imageUpload.isUploaded = false;
    imageUpload.uploading = false;
    imageUpload.imageFile = file;
    imageUpload.imageUrl = ''; */
      images.replaceRange(index, index + 1, [imageUpload]);
    });
  }

  Future _onAddImageClick(int index) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowCompression: true);
    File? file;

    if (result != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(
                      value: 100,
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
/*       final info = await VideoCompress.compressVideo(
        result.files.single.path!,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: true,
      ); */
      file = File(result.files.single.path!);
      if (file != null) {
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TrimmerView(file!, 3)));
      }
    }
  }

  Future getUsersAudios() async {
    setState(() {
      isLoading = true;
    });
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getAudios(user.id);

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
            audios =
                re.map<UploadAudio>((e) => UploadAudio.fromJson(e)).toList();
            images = List.from(audios);
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

  Future deleteAudio(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteAudio(user.id, id);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);
      if (res == "success") {
        print("hi delete");
        getUsersAudios();
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }

  void openDeleteDialog(UploadAudio uploadModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text("Are You Sure want to Delete Audio"),
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
                            FutureProgressDialog(deleteAudio(uploadModel.id!)));
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  TextEditingController _caption = TextEditingController();
  void showPopup(UploadAudio uploadModel) {
    _caption.text = uploadModel.audioCaption!;
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
                                  updateAudio(uploadModel.id, _caption.text)));
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

  Future updateAudio(String? id, String text) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().updateAudio(user.id, id!, text);
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
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }
}

class UserAudios extends StatefulWidget {
  String userId;

  UserAudios({required this.userId});

  @override
  _UserAudiosState createState() => _UserAudiosState();
}

class _UserAudiosState extends State<UserAudios> {
  bool isLoading = true;
  List<UploadAudio> audios = [];
  List<Object> images = [];
  bool _play = false;
  String currentDuration = "";
  String endDuration = "";
  bool isAudioLoading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getAudios(widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? audios.isEmpty
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
                    dynamic uploadModel = images[index] as UploadAudio;
                    return GestureDetector(
                      onTap: () {
                        //openAudioPlayer(uploadModel);
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleVideoPlayer(
                                    uploadModel.audioName, "2"))); */

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlickerDemoPlayer(
                                      fileName: '${uploadModel.audioName}',
                                    )));
                      },
                      onLongPress: () {
                        showBottomSheet(uploadModel as UploadAudio);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 140,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                width: 200,
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/music.jpg",
                                      width: 200,
                                      height: 200,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Card(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Icon(Icons.play_arrow,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                uploadModel.audioCaption,
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
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                )
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.yellow,
              ),
            ),
    );
  }

  getAudios(String userId) async {
    Response response = await Apis().getAudios(userId);

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
            audios =
                re.map<UploadAudio>((e) => UploadAudio.fromJson(e)).toList();
            images = List.from(audios);
            //images.add("Add Image");
            //images.add(1);

            isLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;

        setState(() {
          images = [];
          //images.add(1);
          isLoading = false;
        });
      }
    } else {
      MyToast(message: "Internet is slow").toast;
    }
  }

  void showBottomSheet(UploadAudio uploadAudio) {
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
                                  i: 3, type: "audio", id: uploadAudio.id!)));
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
