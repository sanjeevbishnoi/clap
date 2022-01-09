import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/widget/toast.dart';

class AppliedDetails extends StatefulWidget {
  @override
  State<AppliedDetails> createState() => _AppliedDetailsState();
}

class _AppliedDetailsState extends State<AppliedDetails> {
  String? userId;

  File? imageFile;
  File? videoFile;
  File? documentFile;
  File? audioFile;
  File? selectedFile;
  String type = "";
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      findUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userPost = ModalRoute.of(context)!.settings.arguments as UserPost;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Join Now",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Container(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageFile == null
                            ? Image.asset(
                                "assets/thumbnails/lol/Layer 978.png",
                                width: 170,
                                height: 170,
                                fit: BoxFit.fitWidth,
                              )
                            : Image.file(
                                imageFile!,
                                width: 170,
                                height: 170,
                                fit: BoxFit.fitWidth,
                              ),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              //File file = File(result.files.single.path);
                              print(result.files.single.path);
                              setState(() {
                                imageFile = File(result.files.single.path!);
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text("Choose Image",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(32)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade600,
                    thickness: 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 170,
                            width: 170,
                            child: Stack(children: [
                              Image.asset(
                                "assets/images/video1.jpg",
                                width: 170,
                                height: 170,
                                fit: BoxFit.fill,
                              ),
                              type == "video"
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text("File Selected",
                                          style: TextStyle(
                                              color: Colors.blue.shade900)))
                                  : Container(),
                            ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.video);

                          if (result != null) {
                            //File file = File(result.files.single.path);
                            setState(() {
                              videoFile = File(result.files.single.path!);
                            });

                            print(result.files.single.path);
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          child: Text(
                            "Choose Video",
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 170,
                              width: 170,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/video1.jpg",
                                    width: 170,
                                    height: 170,
                                    fit: BoxFit.fill,
                                  ),
                                  type == "document"
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Text("File Selected",
                                              style: TextStyle(
                                                  color: Colors.blue.shade900)))
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ["pdf", "doc"]);

                            if (result != null) {
                              setState(() {
                                documentFile = File(result.files.single.path!);
                              });
                              //File file = File(result.files.single.path);
                              print(result.files.single.path);
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 20),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text("Choose Documents",
                                style: TextStyle(color: Colors.white)),
                            decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(32)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 170,
                        width: 170,
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/images/disk.png",
                              width: 170,
                              height: 170,
                            ),
                            type == "audio"
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Text("File Selected",
                                        style: TextStyle(
                                            color: Colors.blue.shade900)))
                                : Container(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.audio);

                          if (result != null) {
                            //File file = File(result.files.single.path);
                            audioFile = File(result.files.single.path!);
                            print(result.files.single.path);
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Text(
                            "Choose Audio",
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (valid()) {
                  if (imageFile != null) {
                    setState(() {
                      type = "image";
                      selectedFile = imageFile;
                    });
                  } else if (videoFile != null) {
                    setState(() {
                      type = "video";
                      selectedFile = videoFile;
                    });
                  } else if (audioFile != null) {
                    setState(() {
                      type = "audio";
                      selectedFile = audioFile;
                    });
                  } else if (documentFile != null) {
                    setState(() {
                      type = "document";
                      selectedFile = documentFile;
                    });
                  }
                  showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                          applyJob(userPost.id!, type, selectedFile!)));
                }
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "Upload Now",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: buttonColor, borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    setState(() {
      userId = user.id;
    });

    //MyToast(message: user.id).toast;
  }

  Future applyJob(String postId, String type, File file) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().applyPost(user.id, postId, type, file);
    print("hello");
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      print(response);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(
            Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(
                context, PageRoutes.bottomNavigation, (route) => false));
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  bool valid() {
    if (imageFile == null &&
        videoFile == null &&
        documentFile == null &&
        audioFile == null) {
      MyToast(
              message:
                  "Please Upload one of in Image,video ,document or audio..")
          .toast;
      return false;
    } else {
      print("hi");
      return true;
    }
  }
}
