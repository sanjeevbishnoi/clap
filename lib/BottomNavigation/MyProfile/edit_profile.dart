import 'dart:convert';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qvid/Screens/auth/update_account_info.dart';

import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? userDetails;

  File? imageFile;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: AppBar(
            iconTheme: IconThemeData(color: buttonColor),
            title: Text(
              "Edit Profile",
              style: TextStyle(color: buttonColor),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: buttonColor,
                statusBarBrightness: Brightness.light),
            flexibleSpace: Column(
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                FadedScaleAnimation(
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Stack(children: [
                        userDetails != null
                            ? imageFile != null
                                ? CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage: FileImage(imageFile!))
                                : CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage: NetworkImage(
                                        Constraints.IMAGE_BASE_URL +
                                            userDetails!.image))
                            : CircleAvatar(
                                radius: 40.0,
                                backgroundImage:
                                    AssetImage('assets/images/user_icon.png'),
                              ),
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Card(
                              shadowColor: Colors.grey.shade600,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Icon(Icons.edit)),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      print("dsdsd");
                      if (valid()) {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                FutureProgressDialog(updateProfile(
                                  userDetails!.id,
                                  imageFile,
                                  userDetails!.bio,
                                  userDetails!.userCategory,
                                )));
                      }
                    },
                    child: Text("Update Profile")),
                SizedBox(height: 54),
              ],
            ),
            actions: <Widget>[
              /*  RawMaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  locale.save!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: mainColor),
                ), */
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  labelColor: buttonColor,
                  unselectedLabelColor: mainColor,
                  labelStyle: Theme.of(context).textTheme.headline6,
                  indicator: BoxDecoration(color: transparentColor),
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(text: "Profile Info"),
                    //     Tab(text: "Update Documents"),
                    //     Tab(text: "Account Info"),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            FadedSlideAnimation(
              UpdateAccountInfo(),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
            /* FadedSlideAnimation(
              UpdateDocument(),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ) */
          ],
        ),
      ),
    );
  }

  Future getUser() async {
    Future.delayed(Duration(seconds: 1), () async {
      User user = await ApiHandle.fetchUser();
      if (mounted) {
        setState(() {
          userDetails = user;
        });
      }
    });
  }

  getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        //imageFile = File(image.path);
        cropImage(image.path);
      } else {
        print("File not Selected");
      }
    });
  }

  cropImage(String path) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      var file = await testCompressAndGetFile(croppedFile);
      setState(() {
        imageFile = file;
      });
    }
  }
  //validation

  bool valid() {
    if (imageFile == null) {
      MyToast(message: "Please Choose a Photo").toast;
      return false;
    } else {
      return true;
    }
  }

  Future<File> testCompressAndGetFile(File file) async {
    final dir = await path_provider.getTemporaryDirectory();

    final targetPath = dir.absolute.path + "/temp.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  Future updateProfile(
      userid, File? imageFile, String bi, String idList) async {
    print(idList);
    //final bytes = await IO.File(imageFile).readAsBytes();
    List<int> imageBytes = await imageFile!.readAsBytes();
    String image = "";
    if (imageFile != null) {
      image = base64Encode(imageBytes);
    } else {
      image = userDetails!.image;
    }
    print(image);
    Response resp = await Apis().updateBasicProfileDetails(userid, image, bi);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }
}
