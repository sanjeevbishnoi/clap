import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/full_photo_view.dart';
import 'package:qvid/BottomNavigation/MyProfile/gallery/report.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/image_upload_mode.dart';
import 'package:qvid/model/upload_photo.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:qvid/widget/toast.dart';
import 'package:shimmer/shimmer.dart';

class SelectPhotos extends StatefulWidget {
  @override
  State<SelectPhotos> createState() => _SelectPhotosState();
}

class _SelectPhotosState extends State<SelectPhotos> {
  List<Object> images = [];
  List<UploadesPhoto> list = [];
  File? imageFile;
  bool isLoading = true;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      getUsersPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          isLoading == false
              ? buildGridView()
              : Center(child: SpinKitFadingCircle(color: buttonColor))
        ],
      ),
    ));
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is UploadesPhoto) {
          dynamic uploadPhoto = images[index] as UploadesPhoto;
          print(Constraints.IMAGE_BASE_URL + uploadPhoto.imageName);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPhotoViewPage(
                            index: index,
                            i: 2,
                            userId: "",
                          )));
            },
            onLongPress: () {
              showDeleteBottomSheet(uploadPhoto);
            },
            child: Card(
              elevation: 5,
              //clipBehavior: Clip.antiAlias,
              child: Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    uploadPhoto != null
                        ? CachedNetworkImage(
                            imageUrl: Constraints.IMAGE_BASE_URL +
                                uploadPhoto.imageName,
                            fit: BoxFit.fill,
                            width: 200,
                            placeholder: (context, url) => Shimmer.fromColors(
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
                  ],
                ),
              ),
            ),
          );
        } else if (images[index] is int) {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        } else {
          return imageFile == null
              ? Card(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _onAddImageClick(index);
                    },
                  ),
                )
              : Image.file(
                  imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                );
        }
      }),
    );
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    setState(() {
      /* imageUpload.isUploaded = false;
    imageUpload.uploading = false;
    imageUpload.imageFile = file;
    imageUpload.imageUrl = ''; */
      // images.replaceRange(index, index + 1, [imageUpload]);
    });
  }

  Future _onAddImageClick(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      var file = await testCompressAndGetFile(imageFile!);

      setState(() {
        isSelected = true;
        showDialog(
            context: context,
            builder: (context) => FutureProgressDialog(uploadPhoto(file)));
        getFileImage(index);
      });
    }
  }

  void openDeleteDialog(UploadesPhoto uploadPhoto) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text("Are You Sure want to Delete Photo"),
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
                            FutureProgressDialog(deletePhoto(uploadPhoto.id!)));
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  Future uploadPhoto(File? imageFile) async {
    //final bytes = await IO.File(imageFile).readAsBytes();
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    print(user.id);
    List<int> imageBytes = await imageFile!.readAsBytes();
    String image = base64Encode(imageBytes);
    print(image);
    Response resp = await Apis().uploadPhoto(user.id, image);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          images.length = images.length + 1;
          // images.add(1);

          getUsersPhotos();
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }

  Future getUsersPhotos() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getPhotos(user.id);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print(re.length);

        if (mounted)
          setState(() {
            list = re
                .map<UploadesPhoto>((e) => UploadesPhoto.fromJson(e))
                .toList();
            images = List.from(list);
            //images.add("Add Image");
            images.add(1);

            isLoading = false;
          });

        return re.map<UploadesPhoto>((e) => UploadesPhoto.fromJson(e)).toList();
      } else {
        print("error");
        MyToast(message: msg).toast;

        setState(() {
          images.add(1);
          isLoading = false;
        });
        return [];
      }
    } else {
      MyToast(message: "Internet is slow").toast;
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

  Future deletePhoto(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);

    Response resp = await Apis().deletePhotos(user.id, id);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);

      if (res == "success") {
        images.clear();
        getUsersPhotos();
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }

  void showDeleteBottomSheet(UploadesPhoto uploadPhoto) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 100,
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
                      Navigator.of(context).pop();
                      openDeleteDialog(uploadPhoto);
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
  }
}

class UserPhotos extends StatefulWidget {
  final String userId;
  UserPhotos({required this.userId});

  @override
  _UserPhotosState createState() => _UserPhotosState();
}

class _UserPhotosState extends State<UserPhotos> {
  List<Object> images = [];
  List<UploadesPhoto> list = [];
  File? imageFile;
  bool isLoading = true;
  bool isSelected = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getUsersPhotos(widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          isLoading == false
              ? buildGridView()
              : Center(child: SpinKitFadingCircle(color: buttonColor))
        ],
      ),
    ));
  }

  Widget buildGridView() {
    return images.isNotEmpty
        ? GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: List.generate(images.length, (index) {
              dynamic uploadPhoto = images[index] as UploadesPhoto;
              print(Constraints.IMAGE_BASE_URL + uploadPhoto.imageName);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullPhotoViewPage(
                                index: index,
                                i: 1,
                                userId: widget.userId,
                              )));
                },
                onLongPress: () {
                  showBottomSheet(uploadPhoto);
                },
                child: Card(
                  elevation: 5,
                  //clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        uploadPhoto != null
                            ? CachedNetworkImage(
                                imageUrl: Constraints.IMAGE_BASE_URL +
                                    uploadPhoto.imageName,
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
                              )
                      ],
                    ),
                  ),
                ),
              );
            }))
        : Center(
            child: Lottie.asset(
              "assets/animation/no-data.json",
              width: 250,
              height: 250,
            ),
          );
  }

  void getUsersPhotos(String userId) async {
    Response response = await Apis().getPhotos(userId);

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
            list = re
                .map<UploadesPhoto>((e) => UploadesPhoto.fromJson(e))
                .toList();
            images = List.from(list);
            //images.add("Add Image");
            // images.add("1");

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

  void showBottomSheet(UploadesPhoto uploadPhoto) {
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
                                  i: 1, type: "photo", id: uploadPhoto.id!)));
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
