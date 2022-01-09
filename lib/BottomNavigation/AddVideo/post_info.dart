import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qvid/Components/post_thumb_list.dart';
import 'package:qvid/Components/post_thumb_tile.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostInfo extends StatefulWidget {
  String filePath = "";

  PostInfo({required this.filePath});

  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  final TextEditingController _description = TextEditingController();
  var icon = Icons.check_box_outline_blank;
  bool isSwitched1 = true;
  bool isSwitched2 = false;
  File? coverFile;
  late String userId;
  var _userUploadOption = "Public";
  final List<PostThumbList> thumbLists = [
    PostThumbList(dance),
  ];

  static List<String> dance = [];

  @override
  void initState() {
    findUser();
    dance.clear();
    Future.delayed(Duration(seconds: 1), () {
      thumbnilList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //filePath = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Post",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      dance.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 15),
                              child: Container(
                                height: 170,
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    coverFile == null
                                        ? Image.asset(
                                            "assets/images/banner 1.png",
                                            fit: BoxFit.fill,
                                            height: 170,
                                            width: 110,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              coverFile!,
                                              fit: BoxFit.fill,
                                              height: 170,
                                              width: 110,
                                            ),
                                          ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        height: 20,
                                        alignment: Alignment.center,
                                        color: Colors.black54,
                                        child: Text(
                                          "Select Cover" + '\n',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /*  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: thumbLists.length,
                                    itemBuilder: (context, index) {
                                      return PostThumbTile(dance[index]);
                                    }) */
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Container(
                        height: 150,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _description,
                          maxLines: 100,
                          decoration: InputDecoration(
                            hintText: "Enter Video Description",
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIconConstraints:
                                BoxConstraints.tight(Size(23, 23)),
                            alignLabelWithHint: true,
                            labelText: "Add Video Description",
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
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              color: darkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Choose Option",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 150,
                          child: ListTile(
                            //contentPadding: EdgeInsets.all(0),
                            title: const Text(
                              'Private',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            //horizontalTitleGap: 1,
                            leading: Radio<String>(
                              value: "Private",
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => buttonColor),
                              activeColor: buttonColor,
                              groupValue: _userUploadOption,
                              onChanged: (value) {
                                setState(() {
                                  _userUploadOption = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: ListTile(
                            title: const Text("Public",
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            //horizontalTitleGap: 1,
                            leading: Radio<String>(
                              value: "Public",
                              activeColor: buttonColor,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => buttonColor),
                              groupValue: _userUploadOption,
                              onChanged: (value) {
                                setState(() {
                                  _userUploadOption = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Card(
              color: darkColor,
              child: ListTile(
                title: Text(
                  "Comment off",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Switch(
                  value: isSwitched1,
                  onChanged: (value) {
                    setState(() {
                      isSwitched1 = value;
                      //print(isSwitched1);
                    });
                  },
                  inactiveThumbColor: disabledTextColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  activeTrackColor: Colors.blue,
                  activeColor: Colors.blue,
                ),
              ),
            ),
            Card(
              color: darkColor,
              child: ListTile(
                title: Text(
                  "Save To Gallery",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Switch(
                  value: isSwitched2,
                  onChanged: (value) {
                    setState(() {
                      isSwitched2 = value;
                      //print(isSwitched2);
                    });
                  },
                  inactiveThumbColor: disabledTextColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  activeTrackColor: Colors.blue,
                  activeColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            InkWell(
              onTap: () {
                File file = File(widget.filePath);
                showDialog(
                    context: context,
                    builder: (context1) => FutureProgressDialog(uploadPost(
                        userId, "Post", file, _description.text, coverFile!)));
                //thumbnilList();
                /* Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage())); */
                //Navigator.pushNamed(context, PageRoutes.otp_screen);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "POST VIDEO",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadPost(String userId, String title, File file1, String descri,
      File coverImage) async {
    print("sdsd");
    //print(file1 != null ? "file h" : "file nhi");
    print(file1.readAsBytesSync().length);
    Response res = await Apis().uploadPost(
        userId, file1, title, descri, coverImage, _userUploadOption);
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
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(
              context, PageRoutes.bottomNavigation, (route) => false);
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
    Future.delayed(Duration(seconds: 1), () {
      thumbnilList();
    });

    MyToast(message: user.id).toast;
  }

  /* Future<File> fetchFile() async {
    print("hello");
    //return await File(filePath!);
  } */

  Future<void> thumbnilList() async {
    print("file name ${widget.filePath}");
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.filePath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    setState(() {
      dance.add(fileName!);
      print("lenght ${dance.length}");
      coverFile = File(fileName);
      print(dance);
    });
    print(dance.length);
    print("File Name $fileName");
  }
}
