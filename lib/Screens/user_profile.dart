import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/BottomNavigation/MyProfile/mypost_list.dart';
import 'package:qvid/BottomNavigation/MyProfile/show_gallery.dart';
import 'package:qvid/Components/row_item.dart';
import 'package:qvid/Components/sliver_app_delegate.dart';
import 'package:qvid/Components/tab_grid.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/auth/show_periosnal_info.dart';
import 'package:qvid/Screens/chat/chat_details.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/BottomNavigation/MyProfile/followers.dart';
import 'package:qvid/BottomNavigation/MyProfile/following.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/model/user.dart' as us;
import 'package:qvid/model/user_video.dart';
import 'package:qvid/utils/constaints.dart' as con;
import 'package:qvid/widget/popuptemplate/template.dart';
import 'package:qvid/widget/toast.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = true;
  bool isFollowed = false;
  bool isCelebrity = false;
  bool isWishlist = false;
  String hDuration = "30sec", eDuration = "30sec";
  String h30Amount = "₹2000", h60Amount = "₹4000";
  String e30Amount = "₹3500", e60Amount = "₹6000";

  String? celUserId;
  late String? currentUserId;
  us.User? userDetails;
  List<UserVideo> list = [];
  List<UserVideo> likedVideoList = [];
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      findCurrentUser();
      findUserDetails();
    });
    super.initState();
  }

  final key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    celUserId = ModalRoute.of(context)!.settings.arguments as String;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              child: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: MyCustomAppBar(context: context, user: userDetails)
                      .myCustomAppBar),
              preferredSize: Size.fromHeight(100)),
          body: userDetails != null
              ? Stack(
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
                                expandedHeight: 319,
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
                                    color: backgroundColor,
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
                                                      userDetails != null
                                                          ? CircleAvatar(
                                                              radius: 40.0,
                                                              backgroundImage:
                                                                  NetworkImage(con
                                                                          .Constraints
                                                                          .IMAGE_BASE_URL +
                                                                      userDetails!
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
                                                              userDetails !=
                                                                      null
                                                                  ? '${userDetails!.name}'
                                                                  : 'new user',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      'Times',
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              userDetails !=
                                                                      null
                                                                  ? '${userDetails!.userCategoryName}'
                                                                  : 'new user',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Times',
                                                                  color:
                                                                      disabledTextColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        PageRoutes
                                                            .reportOnProfile,
                                                        arguments:
                                                            userDetails!.id);
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  "assets/icons/report.png"),
                                                          radius: 30,
                                                          backgroundColor:
                                                              Colors.white,
                                                        )),
                                                  ),
                                                ),
                                                /* GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  PageRoutes
                                                      .show_persional_info,
                                                  arguments: {
                                                    "i": 1,
                                                    "id": userDetails!.id
                                                  });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ), */
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ChatUser user = ChatUser(
                                                      id: userDetails!.id,
                                                      name: userDetails!.name,
                                                      image:
                                                          userDetails!.image);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                                receiver: user,
                                                              )));
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  color: Colors.blue,
                                                  child: Container(
                                                      width: 100,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Message",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          FutureProgressDialog(
                                                              followUser(
                                                                  currentUserId!,
                                                                  userDetails!
                                                                      .id)));
                                                },
                                                child: Card(
                                                  color: Colors.blue,
                                                  elevation: 5,
                                                  child: Container(
                                                      width: 100,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        userDetails!.followStatus !=
                                                                "true"
                                                            ? "Follow"
                                                            : "Followed",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          FutureProgressDialog(
                                                              addWishlist(
                                                                  currentUserId!,
                                                                  userDetails!
                                                                      .id)));
                                                },
                                                child: Icon(
                                                  userDetails!.wishlistStatus !=
                                                          "true"
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                                  color: userDetails != null
                                                      ? userDetails!
                                                                  .wishlistStatus ==
                                                              "true"
                                                          ? Colors.red
                                                          : Colors.grey
                                                      : Colors.grey,
                                                  size: 30,
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                /* gradient: LinearGradient(colors: [
                                              buttonColor,
                                              buttonbuttonColor
                                            ]), */
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Visibility(
                                                  visible: userDetails != null
                                                      ? userDetails!
                                                                  .celebrity ==
                                                              "true"
                                                          ? true
                                                          : false
                                                      : false,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                        showCheckboxColumn:
                                                            false,
                                                        columnSpacing:
                                                            (MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    10) *
                                                                0.5,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white)),
                                                        dataRowHeight: 43,
                                                        headingRowHeight: 30,
                                                        headingTextStyle:
                                                            TextStyle(
                                                                color:
                                                                    buttonColor),
                                                        columns: [
                                                          DataColumn(
                                                              label: Text(
                                                                  "Language")),
                                                          DataColumn(
                                                              label: Text(
                                                                  "Duration")),
                                                          DataColumn(
                                                              label: Text(
                                                                  "Amount")),
                                                          DataColumn(
                                                              label: Text(
                                                                  "Action")),
                                                        ],
                                                        rows: [
                                                          DataRow(
                                                              onSelectChanged:
                                                                  (value) {},
                                                              cells: [
                                                                DataCell(Text(
                                                                    "Hindi",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                                DataCell(
                                                                  DropdownButtonFormField<
                                                                      dynamic>(
                                                                    value:
                                                                        "30sec",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    elevation:
                                                                        0,
                                                                    //underline: SizedBox(),
                                                                    //value: tCountry,

                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    dropdownColor:
                                                                        Colors
                                                                            .white,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                    items: [
                                                                      "30sec",
                                                                      "60sec"
                                                                    ].map((String
                                                                        name) {
                                                                      return new DropdownMenuItem<
                                                                          dynamic>(
                                                                        value:
                                                                            name,
                                                                        child: new Text(
                                                                            name,
                                                                            style:
                                                                                TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (val) {
                                                                      print(
                                                                          val);
                                                                      setState(
                                                                          () {
                                                                        hDuration =
                                                                            val;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                DataCell(Text(
                                                                    hDuration
                                                                            .isNotEmpty
                                                                        ? hDuration ==
                                                                                "30sec"
                                                                            ? "₹ ${userDetails!.priceFor30sec}"
                                                                            : "₹ ${userDetails!.priceFor60sec}"
                                                                        : userDetails !=
                                                                                null
                                                                            ? "₹ ${userDetails!.priceFor30sec}"
                                                                            : "₹0",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                                DataCell(
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            String
                                                                                lan =
                                                                                "Hindi";
                                                                            //duration
                                                                            //amount
                                                                            if (valid(lan)) {
                                                                              showDialog(context: context, builder: (context) => FutureProgressDialog(bookCelebrity(lan, hDuration, hDuration == "30sec" ? "${userDetails!.priceFor30sec}" : "${userDetails!.priceFor60sec}", userDetails!.id)));
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text("Book")),
                                                                )),
                                                              ]),
                                                          DataRow(
                                                              onSelectChanged:
                                                                  (value) {},
                                                              cells: [
                                                                DataCell(Text(
                                                                    "English",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                                DataCell(
                                                                  DropdownButtonFormField<
                                                                      dynamic>(
                                                                    value:
                                                                        "30sec",
                                                                    //underline: SizedBox(),
                                                                    //value: tCountry,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    dropdownColor:
                                                                        Colors
                                                                            .white,

                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                    items: [
                                                                      "30sec",
                                                                      "60sec"
                                                                    ].map((String
                                                                        name) {
                                                                      return new DropdownMenuItem<
                                                                          dynamic>(
                                                                        value:
                                                                            name,
                                                                        child: new Text(
                                                                            name,
                                                                            style:
                                                                                TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (val) {
                                                                      print(
                                                                          val);

                                                                      setState(
                                                                          () {
                                                                        eDuration =
                                                                            val;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                DataCell(Text(
                                                                    eDuration
                                                                            .isNotEmpty
                                                                        ? eDuration ==
                                                                                "30sec"
                                                                            ? "₹ ${userDetails!.priceFor30sec}"
                                                                            : "₹ ${userDetails!.priceFor60sec}"
                                                                        : userDetails !=
                                                                                null
                                                                            ? "₹ ${userDetails!.priceFor30sec}"
                                                                            : "₹0",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                                DataCell(
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            String
                                                                                lan =
                                                                                "English";
                                                                            if (valid(lan)) {
                                                                              showDialog(context: context, builder: (context) => FutureProgressDialog(bookCelebrity(lan, eDuration, eDuration == "30sec" ? "${userDetails!.priceFor30sec}" : "${userDetails!.priceFor60sec}", userDetails!.id)));
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text("Book")),
                                                                )),
                                                              ])
                                                        ]),
                                                  ),
                                                ),
                                                userDetails != null
                                                    ? Visibility(
                                                        visible: userDetails!
                                                                    .celebrity ==
                                                                "true"
                                                            ? false
                                                            : true,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  buttonColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              /* GestureDetector(
                                                                onTap: () {
                                                                  /*                Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MyPostList(userid: celUserId!))); */
                                                                },
                                                                child: Card(
                                                                  color:
                                                                      backgroundColor,
                                                                  elevation: 3,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      Container(
                                                                    width: 60,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: RowItem(
                                                                        "${userDetails!.postCount}",
                                                                        "Jobs"),
                                                                  ),
                                                                ),
                                                              ), */
                                                              Visibility(
                                                                visible:
                                                                    isCelebrity ==
                                                                            true
                                                                        ? false
                                                                        : true,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => FollowersPage(
                                                                                  userId: celUserId!,
                                                                                )));
                                                                  },
                                                                  child: Card(
                                                                    color:
                                                                        backgroundColor,
                                                                    elevation:
                                                                        3,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child: RowItem(
                                                                          '${userDetails!.followersTotal}',
                                                                          "Followers"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => FollowingPage(
                                                                                userId: celUserId!,
                                                                              )));
                                                                },
                                                                child: Card(
                                                                  color:
                                                                      backgroundColor,
                                                                  elevation: 3,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child: RowItem(
                                                                        '${userDetails!.followingTotal}',
                                                                        "Following"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.white,
                                          )
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
                                    indicatorColor: Colors.red,
                                    tabs: [
                                      Tab(icon: Icon(Icons.person)),
                                      Tab(
                                          icon:
                                              Icon(Icons.video_library_sharp)),
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
                                        data: {"i": 1, "id": userDetails!.id},
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
                                        userId: celUserId!,
                                      ),
                                      beginOffset: Offset(0, 0.3),
                                      endOffset: Offset(0, 0),
                                      slideCurve: Curves.linearToEaseOut,
                                    ),
                                    FadedSlideAnimation(
                                      TabGrid(likedVideoList,
                                          icon: Icons.favorite,
                                          context: context,
                                          userId: celUserId!),
                                      beginOffset: Offset(0, 0.3),
                                      endOffset: Offset(0, 0),
                                      slideCurve: Curves.linearToEaseOut,
                                    ),
                                    FadedSlideAnimation(
                                      ShowGallery(
                                          i: 2, userId: userDetails!.id),
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
                )
              : Center(
                  child: SpinKitFadingCircle(
                    color: Colors.yellow,
                  ),
                ),
        ),
      ),
    );
  }

  findUserDetails() async {
    await ApiHandle.getUserById(celUserId!).then((user) => {
          setState(() {
            isLoading = false;
            user != null ? userDetails = user : "";
            Future.delayed(Duration(seconds: 1), () {
              getVideoList(celUserId!);
              getLikedVideoList(celUserId!);
            });
          })
        });
  }

  Future addWishlist(String userId, String fUserId) async {
    print(userId + "   " + fUserId);
    Response resp = await Apis().addWishList(userId, fUserId);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        setState(() {
          isWishlist == true ? isWishlist = false : isWishlist = true;
          Future.delayed(Duration(seconds: 1), () {
            findCurrentUser();
            findUserDetails();
          });
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }

  Future findCurrentUser() async {
    us.User user = await ApiHandle.fetchUser();
    setState(() {
      currentUserId = user.id;
    });
  }

  Future getVideoList(String userId) async {
    List<UserVideo> userVideoList = await ApiHandle.getVideo(userId);
    if (mounted) {
      setState(() {
        list = userVideoList;

        print(" Length is ${list.length}");
      });
    }
  }

  Future getLikedVideoList(String userId) async {
    List<UserVideo> userVideoList = await ApiHandle.getLikedVideo(userId);
    if (mounted) {
      setState(() {
        likedVideoList = userVideoList;
      });
    }
  }

  Future bookCelebrity(
      String language, String duration, String amount, celebrityId) async {
    Response resp = await Apis()
        .bookCelebrity(currentUserId!, celebrityId, language, duration, amount);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(resp.body);
      if (res == "success") {
        MyToast(message: msg).toast;
        /* CustomPopup(context: context).popup.show(
              title: "",
              content: 'Successfully Booked',

              // bool barrierDismissible = false,
              // Widget close,
            ); */
        return "";
      } else {
        MyToast(message: msg).toast;
        return "";
      }
    } else {
      return "";
    }
  }

  bool valid(String lan) {
    if (lan == "Hindi" ? hDuration.isEmpty : eDuration.isEmpty) {
      MyToast(message: "Please Select duration").toast;
      return false;
    } else {
      return true;
    }
  }

  Future followUser(userId, fId) async {
    Response resp = await Apis().followUser(userId, fId);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        setState(() {
          isFollowed == true ? isFollowed = false : isFollowed = true;
          Future.delayed(Duration(seconds: 1), () {
            findCurrentUser();
            findUserDetails();
          });
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }
}
