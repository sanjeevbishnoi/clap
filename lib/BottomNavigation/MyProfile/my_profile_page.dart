import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/BottomNavigation/MyProfile/applied_job_list.dart';
import 'package:qvid/BottomNavigation/MyProfile/booking/mybooking.dart';
import 'package:qvid/BottomNavigation/MyProfile/mypost_list.dart';
import 'package:qvid/BottomNavigation/MyProfile/show_gallery.dart';
import 'package:qvid/Components/tab_grid.dart';
import 'package:qvid/Components/row_item.dart';
import 'package:qvid/Components/sliver_app_delegate.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:intl/intl.dart';
import 'package:qvid/Screens/auth/show_periosnal_info.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Theme/colors.dart';

import 'package:qvid/BottomNavigation/MyProfile/edit_profile.dart';
import 'package:qvid/BottomNavigation/MyProfile/followers.dart';

import 'package:qvid/BottomNavigation/MyProfile/following.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart' as use;
import 'package:qvid/model/user_video.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:qvid/widget/user_design.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyProfileBody();
  }
}

class MyProfileBody extends StatefulWidget {
  @override
  _MyProfileBodyState createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody>
    with WidgetsBindingObserver {
  use.User? userDtails;
  bool isLoading = true;
  List<UserVideo>? list;
  List<UserVideo> likedVideo = [];
  bool isCelebrity = false;
  String age = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Future.delayed(Duration(seconds: 1), () {
      fetchUser();
    });
    //onResume();
  }

  final key = UniqueKey();
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("app lifecycle");
    setState(() {
      _notification = state;
      print("notificaton: $_notification");
    });
    if (state == AppLifecycleState.resumed) {
      Future.delayed(Duration(seconds: 1), () {
        fetchUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
                child: Container(
                    margin: EdgeInsets.only(top: 0),
                    child: MyCustomAppBar(context: context, user: userDtails)
                        .myCustomAppBar),
                preferredSize: Size.fromHeight(100)),
            body: Stack(
              children: [
                DefaultTabController(
                  length: 4,
                  child: SafeArea(
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: 220.4,
                            floating: false,
                            stretch: true,
                            actions: <Widget>[
                              Theme(
                                data: Theme.of(context).copyWith(
                                  cardColor: backgroundColor,
                                ),
                                child: Container(
                                  child: Text(""),
                                ),
                              )
                            ],
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              background: Card(
                                color: cardColor,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: <Widget>[
                                                  userDtails != null
                                                      ? CircleAvatar(
                                                          radius: 40.0,
                                                          backgroundImage:
                                                              NetworkImage(Constraints
                                                                      .IMAGE_BASE_URL +
                                                                  userDtails!
                                                                      .image))
                                                      : CircleAvatar(
                                                          radius: 40.0,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/images/user_icon.png'),
                                                        ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userDtails == null
                                                              ? 'New user'
                                                              : userDtails!
                                                                  .name,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          userDtails == null
                                                              ? '@newusercategory'
                                                              : userDtails!
                                                                  .userCategoryName,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          userDtails == null
                                                              ? 'age'
                                                              : "$age year",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile()),
                                                ).then((value) => {
                                                      Future.delayed(
                                                          Duration(seconds: 1),
                                                          () {
                                                        fetchUser();
                                                      })
                                                    });
                                              },
                                              child: Card(
                                                elevation: 5,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            /* GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    PageRoutes.setting_page);
                                              },
                                              child: Card(
                                                elevation: 5,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(
                                                    Icons.settings,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ) */
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: buttonColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyPostList(
                                                              userid:
                                                                  userDtails!
                                                                      .id,
                                                            )));
                                              },
                                              child: Card(
                                                color: backgroundColor,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: RowItem(
                                                      userDtails != null
                                                          ? "${userDtails!.postCount}"
                                                          : "0",
                                                      "My Jobs"),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowersPage(
                                                              userId:
                                                                  userDtails!
                                                                      .id,
                                                            )));
                                              },
                                              child: Card(
                                                color: backgroundColor,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: RowItem(
                                                      userDtails != null
                                                          ? '${userDtails!.followersTotal}'
                                                          : "0",
                                                      "Followers"),
                                                ),
                                              ),
                                            ),
                                            /*   Visibility(
                                              visible: isCelebrity == true
                                                  ? true
                                                  : false,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyBooking()));
                                                },
                                                child: Card(
                                                  color: backgroundColor,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: RowItem(
                                                        userDtails != null
                                                            ? '${userDtails!.bookingCount}'
                                                            : "0",
                                                        "Booking"),
                                                  ),
                                                ),
                                              ),
                                            ), */
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowingPage(
                                                              userId:
                                                                  userDtails!
                                                                      .id,
                                                            )));
                                              },
                                              child: Card(
                                                color: backgroundColor,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: RowItem(
                                                      userDtails != null
                                                          ? '${userDtails!.followingTotal}'
                                                          : "0",
                                                      "Following"),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AppliedJobList(
                                                              userid:
                                                                  userDtails!
                                                                      .id,
                                                            )));
                                              },
                                              child: Card(
                                                color: backgroundColor,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: RowItem(
                                                    userDtails != null
                                                        ? userDtails!
                                                            .appliedJobCount!
                                                        : "0",
                                                    "Applied Jobs",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: SliverAppBarDelegate(
                              TabBar(
                                labelColor: buttonColor,
                                unselectedLabelColor: Colors.white,
                                indicatorColor: color1,
                                tabs: [
                                  Tab(icon: Icon(Icons.person)),
                                  Tab(icon: Icon(Icons.video_library_sharp)),
                                  Tab(icon: Icon(Icons.favorite_border)),
                                  Tab(icon: Icon(Icons.medication_sharp))
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: isLoading == true
                          ? SpinKitFadingCircle(
                              color: buttonColor,
                            )
                          : TabBarView(
                              children: <Widget>[
                                FadedSlideAnimation(
                                  ShowPersonalInfo(
                                    data: {"i": 2, "id": "12"},
                                  ),
                                  beginOffset: Offset(0, 0.3),
                                  endOffset: Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                ),
                                FadedSlideAnimation(
                                  TabGrid(
                                    list,
                                    icon: Icons.favorite,
                                    context: context,
                                    userId: userDtails!.id,
                                  ),
                                  beginOffset: Offset(0, 0.3),
                                  endOffset: Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                ),
                                FadedSlideAnimation(
                                  TabGrid(
                                    likedVideo,
                                    icon: Icons.bookmark,
                                    context: context,
                                    userId: userDtails!.id,
                                  ),
                                  beginOffset: Offset(0, 0.3),
                                  endOffset: Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                ),
                                FadedSlideAnimation(
                                  ShowGallery(
                                    i: 1,
                                    userId: "",
                                  ),
                                  beginOffset: Offset(0, 0.3),
                                  endOffset: Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    use.User user =
        use.User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getUser(user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        use.User user = use.User.fromMap(data['data'] as Map<String, dynamic>);
        if (this.mounted) {
          setState(() {
            userDtails = user;
            getAge(userDtails);
            getVideoList(userDtails!.id);
            getLikedVideoList(userDtails!.id);

            isLoading = false;
            userDtails!.celebrity == "true"
                ? isCelebrity = true
                : isCelebrity = false;

            //ShowPersonalInfo.user = userDtails;
          });
        }

        //update shareprefernce
      } else {
        MyToast(message: msg).toast;
        isLoading = false;
      }
    }
  }

  //getVideo
  Future getVideoList(String userId) async {
    print("reels calls");
    List<UserVideo> userVideoList = await ApiHandle.getVideo(userId);
    print(" Length is ${userVideoList.length}");
    if (mounted) {
      setState(() {
        list = userVideoList;
      });
    }
  }

  Future getLikedVideoList(String userId) async {
    List<UserVideo> userVideoList = await ApiHandle.getLikedVideo(userId);
    if (mounted) {
      setState(() {
        likedVideo = userVideoList;

        print(" Length is ${list!.length}");
      });
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushNamed(context, PageRoutes.bottomNavigation);
    return true;
    /* return await showDialog(
            context: context,
            builder: (context) => Dialog(
                child: Container(
                    width: 200,
                    height: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Icon(Icons.close)),
                          ),
                        ),
                        Lottie.asset(
                          "assets/animation/thankyou1.json",
                          width: 120,
                          height: 120,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Thank You For Using Clap !",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Visit again for more entertainment.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text("Exit")),
                        )
                      ],
                    )))) ??
        false;
 */
  }

  void getAge(use.User? userDtails) {
    //DateTime birthDate = ;
    DateTime today = DateTime.now();
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    var dobDate = dateFormat.parse(userDtails!.dob);
    int yearDiff = today.year - dobDate.year;

    if (yearDiff < 1) {
      MyToast(message: "You are not eligible").toast;
    } else {
      setState(() {
        age = "$yearDiff";
      });
    }
    print(yearDiff);
  }

  Future onResume() async {
    /* String? sdd = "";
    SystemChannels.lifecycle.setMessageHandler((msg) {
      //debugPrint('SystemChannels> $msg');
      if (msg == AppLifecycleState.resumed.toString())
        setState(() {
          Future.delayed(Duration(seconds: 1), () {
            fetchUser();
          });
        });
      return sdd;
    }); */
  }
}
