import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class PostApplicants extends StatefulWidget {
  String postId;
  PostApplicants({required this.postId});

  @override
  _PostApplicantsState createState() => _PostApplicantsState();
}

class _PostApplicantsState extends State<PostApplicants> {
  List<User> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      loadApplicants(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Job Applicants"),
      ),
      body: isLoading == false
          ? userList.isNotEmpty
              ? ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                      child: GestureDetector(
                        onTap: () {
                          /*  Navigator.pushNamed(
                              context, PageRoutes.userProfilePage,
                              arguments: userList[index].id); */
                        },
                        child: Card(
                            color: cardColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                //color:
                                /*  Colors.primaries[Random().nextInt(Colors.primaries.length)], */
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        userList[index].image.isEmpty
                                            ? CircleAvatar(
                                                radius: 25.0,
                                                backgroundImage: AssetImage(
                                                    'assets/user/user1.png'))
                                            : CircleAvatar(
                                                radius: 25.0,
                                                backgroundImage: NetworkImage(
                                                    Constraints.IMAGE_BASE_URL +
                                                        userList[index].image),
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${userList[index].name}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${userList[index].type}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        //userList[index].mobileStatus == "true"
                                        //?
                                        true,
                                    //: false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          launch(
                                              'tel:${userList[index].mobile}');
                                        },
                                        child: Card(
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Container(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.call,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )))
              : Center(
                  child: Lottie.asset(
                    "assets/animation/no-data.json",
                    width: 250,
                    height: 250,
                  ),
                )
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.yellow,
              ),
            ),
    );
  }

  void loadApplicants(String postId) async {
    Response response = await Apis().getApplicants(postId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        userList = re.map<User>((e) => User.fromMap(e)).toList();
        print(userList[0].name);
        if (mounted)
          setState(() {
            isLoading = false;
          });

        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
