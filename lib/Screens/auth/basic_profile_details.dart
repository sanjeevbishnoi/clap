import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

List<String> categoryList = ["dssd", "dsdsd"];

class BasicProfile extends StatefulWidget {
  @override
  State<BasicProfile> createState() => _BasicProfileState();
}

class _BasicProfileState extends State<BasicProfile> {
  IO.File? imageFile;
  IO.File? imageFile1;
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _priceForShoot = TextEditingController();
  late String bio;
  late String userId;

  User? updateUser;

  @override
  void initState() {
    //  loadCategies();

    findUser();
    //

    super.initState();
  }

  getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        imageFile1 = File(image.path);
        print(image.path);
        cropImage(image.path);
      } else {
        print("File not Selected");
      }
    });
  }

  final height = 200;
  String counterText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: cardColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: buttonColor,
            )),
        title: Text("Basic Profile Details",
            style:
                TextStyle(color: buttonColor, fontWeight: FontWeight.normal)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: Stack(children: [
                    imageFile == null
                        ? CircleAvatar(
                            radius: 60.0,
                            backgroundImage:
                                AssetImage('assets/user/user1.png'),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(imageFile1!),
                            radius: 60.0,
                          ),
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              width: 30, height: 30, child: Icon(Icons.edit)),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: false,
                child: TextField(
                  controller: _priceForShoot,
                  decoration: InputDecoration(
                    hintText: "Price for 30 to 60 sec video",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    alignLabelWithHint: true,
                    labelText: "Enter Price ",
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
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 200,
                  child: TextField(
                    controller: _bio,
                    maxLines: 100,
                    decoration: InputDecoration(
                      hintText: "Enter Bio",
                      hintStyle: TextStyle(color: Colors.white),
                      alignLabelWithHint: true,
                      labelText: "Enter Bio",
                      counter: Text(
                        "${counterText.length.toString()}/1000",
                        style: TextStyle(color: Colors.red),
                      ),
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
                      setState(() {
                        counterText = value;
                      });
                    },
                  )),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  /* Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.bottomNavigation, (route) => false); */
                  if (valid()) {
                    showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                            updateProfile(userId, imageFile, bio)));
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? price;
  bool valid() {
    bio = _bio.text;
    price = _priceForShoot.text;
    if (bio.isEmpty) {
      MyToast(message: "Please Enter Bio").toast;
      return false;
    } else if (counterText.length > 1000) {
      MyToast(message: "Please Enter Bio in 1000 letter").toast;
      return false;
    } else if (imageFile == null) {
      MyToast(message: "Please Choose a Photo").toast;
      return false;
    } else {
      return true;
    }
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
    Future.delayed(Duration(seconds: 2), () async {
      print("ds");
      User? updateUser1 = await ApiHandle.getUserById(user.id);
      setState(() {
        updateUser = updateUser1;
      });
    });

    //MyToast(message: user.id).toast;
  }

  Future updateProfile(userid, IO.File? imageFile, String bi) async {
    //final bytes = await IO.File(imageFile).readAsBytes();
    List<int> imageBytes = await imageFile!.readAsBytes();
    String image = base64Encode(imageBytes);
    print(image);

    Response resp = await Apis().updateBasicProfileDetails(userId, image, bi);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);
      // String userType = response['user_type'];
      if (res == "success") {
        Future.delayed(Duration(microseconds: 1), () async {
          //Navigator.of(context).popUntil(ModalRoute.withName(PageRoutes.bottomNavigation));
          bool result =
              await MyPrefManager.prefInstance().addData("New", "Yes");
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageRoutes.bottomNavigation,
            (route) => false,
          );
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
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
}
