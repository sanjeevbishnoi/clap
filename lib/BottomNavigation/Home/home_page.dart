import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:qvid/BottomNavigation/Home/following_tab.dart';
import 'package:qvid/BottomNavigation/Home/new_video_player.dart';
import 'package:qvid/BottomNavigation/Home/video_play_page.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/controller/player_screen_controller.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_interest.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/widget/toast.dart';
//import 'package:qvid/BottomNavigation/Home/following_tab.dart';
//import 'package:qvid/Locale/locale.dart';
//import 'package:qvid/Theme/colors.dart';

List<String> imagesInDisc1 = [
  'assets/user/user1.png',
  'assets/user/user2.png',
  'assets/user/user3.png',
];

List<String> imagesInDisc2 = [
  'assets/user/user4.png',
  'assets/user/user3.png',
  'assets/user/user1.png',
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool isLoading = true;
  List<UserVideo> list = [];
  List<UserVideo> relatedList = [];
  var _controller = Get.put(PlayerScreenController());
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    Future.delayed(Duration(seconds: 1), () {
      getVideoList();
      getRelatedVideoList();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      Tab(
        child: Text(
          "Following",
          style: TextStyle(color: Colors.white),
        ),
      ),
      Tab(
        child: Text(
          "Related",
          style: TextStyle(color: Colors.white),
        ),
      ),
      //Tab(text: "Following"),
      // Tab(text: "Related")
    ];
    return isLoading != true
        ? DefaultTabController(
            length: tabs.length,
            child: WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                  body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    TabBarView(
                      children: <Widget>[
                        FollowingTabPage1(
                          list,
                          imagesInDisc1,
                          true,
                          0,
                          variable: 1,
                        ),
                        FollowingTabPage1(
                          relatedList,
                          imagesInDisc1,
                          false,
                          0,
                          variable: 1,
                        ),
                      ],
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  TabBar(
                                    isScrollable: true,
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    indicator:
                                        BoxDecoration(color: transparentColor),
                                    tabs: tabs,
                                  ),
                                  Positioned.directional(
                                    textDirection: Directionality.of(context),
                                    top: 14,
                                    start: 84,
                                    child: CircleAvatar(
                                      backgroundColor: mainColor,
                                      radius: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                User user = await ApiHandle.fetchUser();
                                user.reelsCount == 0
                                    ? showInterstDialog()
                                    : Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, PageRoutes.addVideoPage);
                              },
                              child: Container(
                                child: Center(
                                  child: Image.asset(
                                    "assets/icons/add_video.png",
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          )
        : Center(
            child: SpinKitFadingCircle(
              color: buttonColor,
            ),
          );
  }

  //getVideo
  Future getVideoList() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    List<UserVideo> userVideoList = await ApiHandle.getFollowersVideo(user.id);
    setState(() {
      isLoading = false;
      list = userVideoList;
    });
  }

  //getRelatedVideo
  Future getRelatedVideoList() async {
    print("related video");
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    List<UserVideo> userVideoList =
        await ApiHandle.getReleatedVideo(user.id, user.gender);
    setState(() {
      // print(userVideoList.length);
      relatedList = userVideoList;
      isLoading = false;
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, PageRoutes.bottomNavigation);
    return true;
  }

  showInterstDialog() {
    List<UserInterest> interest = [
      UserInterest(interst: "Fun"),
      UserInterest(interst: "Comedy"),
      UserInterest(interst: "Action"),
      UserInterest(interst: "Drama"),
      UserInterest(interst: "Romantic"),
      UserInterest(interst: "Emotional"),
    ];
    List<String> selectedInterest = [];
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Choose Interest",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    reverse: false,
                    physics: const NeverScrollableScrollPhysics(),
                    //itemCount: catList.length < 10 ? catList.length : 10,
                    itemCount: interest.length,
                    itemBuilder: (BuildContext context,
                            int index) => /*  index == 0
                        ? Container()
                        :  */
                        Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () {
                          state(() {
                            interest[index].isSelected == false
                                ? interest[index].isSelected = true
                                : interest[index].isSelected = false;
                          });
                          interest[index].isSelected != false
                              ? selectedInterest.removeAt(index)
                              : selectedInterest.insert(
                                  index, interest[index].interst!);
                        },
                        child: Card(
                          color: interest[index].isSelected == false
                              ? cardColor
                              : buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            alignment: Alignment.center,
                            height: 130,
                            margin: EdgeInsets.all(5),
                            child: Text(
                              interest[index].interst!,
                              style: TextStyle(
                                  color: interest[index].isSelected == false
                                      ? Colors.blue
                                      : Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedInterest.length == 0) {
                        MyToast(message: "Please Choose Your Interest").toast;
                        return;
                      } else {
                        String interest = listToString(selectedInterest);
                        showDialog(
                            context: context,
                            builder: (context) =>
                                FutureProgressDialog(sendInterest(interest)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  String listToString(List<String> list) {
    String data = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        data = list[i];
      } else {
        data += "," + list[i];
      }
    }
    return data;
  }

  Future sendInterest(String interst) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    dynamic resp = await Apis().sendInterest(user.id, interst);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        Future.delayed(Duration(microseconds: 1), () {
          //Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.addVideoPage);
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }
}
