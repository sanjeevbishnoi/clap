import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/upload_photo.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class FullPhotoViewPage extends StatefulWidget {
  int? index;
  int? i;
  String userId;

  FullPhotoViewPage(
      {required this.index, required this.i, required this.userId});
  @override
  _FullPhotoViewPageState createState() => _FullPhotoViewPageState();
}

class _FullPhotoViewPageState extends State<FullPhotoViewPage> {
  int currentPos = 0;

  List<String> carouselImages = [];
  List<UploadesPhoto> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      widget.index != null ? currentPos = widget.index! : currentPos = 0;
    });

    Future.delayed(Duration(seconds: 1), () {
      getUsersPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("User's Photos"),
        ),
        body: isLoading == false
            ? CarouselSlider(
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    aspectRatio: 16 / 9,
                    reverse: false,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          currentPos = index;
                        },
                      );
                    }),
                items: list.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: list.length == 0
                              ? Image.asset(
                                  "assets/images/slider3.jpg",
                                  fit: BoxFit.fill,
                                )
                              : /*  Image.network(
                                      Constraints.BANNER_URL +
                                          carouselImages[currentPos],
                                      fit: BoxFit.fill,
                                    )
                                     */
                              CachedNetworkImage(
                                  imageUrl: Constraints.IMAGE_BASE_URL +
                                      list[currentPos].imageName!,
                                  //fit: BoxFit.fill,
                                  /* placeholder: (context, url) => SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: 100.0,
                                          child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor: Colors.grey.shade100,
                                              enabled: true,
                                              child: ShimmerForSlider
                                                  .sliderShimmerView)), */
                                ));
                      // errorWidget: (context, url, error) => Icon(Icons.error),
                    },
                  );
                }).toList(),
              )
            : SpinKitFadingCircle(
                color: buttonColor,
              ));
  }

  //load photos
  Future getUsersPhotos() async {
    String id = "";
    if (widget.i == 1) {
      id = widget.userId;
    } else {
      var result = await MyPrefManager.prefInstance().getData("user");
      User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
      id = user.id;
    }

    Response response = await Apis().getPhotos(id);

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

            isLoading = false;
          });

        return re.map<UploadesPhoto>((e) => UploadesPhoto.fromJson(e)).toList();
      } else {
        print("error");
        MyToast(message: msg).toast;

        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      MyToast(message: "Internet is slow").toast;
    }
  }
}
