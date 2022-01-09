import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/booking/booking.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Screens/post_list.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:flutter/services.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/celebrity_user.dart';
import 'package:qvid/model/slider.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/utils/constaints.dart' as con;
import 'package:qvid/widget/custome_loader.dart';
import 'package:qvid/widget/homepage_shimmer_design.dart';
import 'package:qvid/widget/popuptemplate/template.dart';
import 'package:qvid/widget/toast.dart';
import 'package:qvid/widget/wishing_list.dart';
import 'package:shimmer/shimmer.dart';

List<String> carouselImages = [];

class MyContainer extends StatefulWidget {
  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  int currentPos = 0;
  int i = 0;
  late List<MySlider> slide;
  late String userId;
  User? userDetails;
  List<UserPost>? postList;
  List<CelebrityUser>? userList;
  List<User>? newUserList;
  bool isLoading = true;
  bool isSwitch = false;
  FirebaseMessaging? messaging;
  String se = "";
  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    getToken(messaging);

    Future.delayed(Duration(seconds: 1), () async {
      await fetchUser();
      fetchSlider();
      loadCelebrityWishes();
      loadNewUser();
      //loadCelebrityWishesh();
      getUserMatchPost(userId).then((list) => {
            setState(() {
              //postList = re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
              postList = list;
            })
          });
    });

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
/*     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]); */
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    carouselImages.clear();
    clearShareData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: buttonColor,
        statusBarBrightness:
            Brightness.light //or set color with: Color(0xFF0000FF)
        ));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: PreferredSize(
              child: Container(
                  //margin: EdgeInsets.only(top: 10),
                  child: MyCustomAppBar(context: context, user: userDetails)
                      .myCustomAppBar),
              preferredSize: Size.fromHeight(100)),
          body: SafeArea(
            top: true,
            bottom: true,
            child: Stack(children: [
              isLoading == true
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade900,
                      highlightColor: cardColor,
                      enabled: true,
                      child: ShimmerLayout(context: context).shimmerDesign)
                  : ListView(
                      scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      children: [
                        /* Container(
                    margin: EdgeInsets.only(top: 20),
                    child: MyCustomAppBar.myCustomAppBar,
                  ), */
                        Visibility(
                          visible: false,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, PageRoutes.explore);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  //margin: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Search here...",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(
                                        Icons.search,
                                        color: buttonColor,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 165.0,
                          child: Stack(children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  height: 165.0,
                                  aspectRatio: 3.0,
                                  autoPlay: true,
                                  reverse: false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  scrollDirection: Axis.horizontal,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(
                                      () {
                                        currentPos = index;
                                      },
                                    );
                                  }),
                              items: carouselImages.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 10,
                                            right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: carouselImages.length == 0
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
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                    imageUrl: con.Constraints
                                                            .BANNER_URL +
                                                        carouselImages[
                                                            currentPos],
                                                    fit: BoxFit.fill,
                                                    placeholder: (context,
                                                            url) =>
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 100.0,
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey.shade900,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade700,
                                                            enabled: true,
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )),
                                              ));
                                    // errorWidget: (context, url, error) => Icon(Icons.error),
                                  },
                                );
                              }).toList(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: carouselImages.map((url) {
                                    int index = carouselImages.indexOf(url);
                                    return Card(
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      child: Container(
                                        width: 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentPos == index
                                              ? buttonColor
                                              : Color.fromRGBO(
                                                  255, 255, 255, 1),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ]),
                        ),

                        /* Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text("Upgrade To Premium"),
                    decoration: BoxDecoration(
                        color: buttonColor, borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text("Upgrade To Monologue"),
                    decoration: BoxDecoration(
                        color: buttonColor, borderRadius: BorderRadius.circular(5)),
                  ), */
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          elevation: 1,
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Bollywood Creative Directory",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontFamily: 'Times',
                                      //fontStyle:FontStyle.italic,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "If You Contact Someone then Browse our Directory",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            PageRoutes.directory_screen);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, bottom: 5),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text(
                                            "Explore",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: goldColor),
                                          ),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: goldColor),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageRoutes.allPostList);
                                },
                                child: Visibility(
                                  /* visible: postList == null || postList!.isEmpty
                                ? false
                                : false, */
                                  visible: true,
                                  child: Card(
                                    color: cardColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text(
                                                    "Job For You",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "View All",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            postList == null || postList!.isEmpty
                                ? Container()
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: postList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      UserPost userPost = postList![index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                PageRoutes.post_full_view,
                                                arguments: userPost);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(5),
                                            width: double.infinity,
                                            //color: postColor,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  topLeft: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5)),
                                              color: Colors.blue.shade900,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    userPost.image == null
                                                        ? CircleAvatar(
                                                            radius: 25.0,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/user_icon.png'),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 25.0,
                                                            backgroundImage:
                                                                NetworkImage(con
                                                                        .Constraints
                                                                        .IMAGE_BASE_URL +
                                                                    userPost
                                                                        .image!)),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${userPost.postName}",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "${userPost.postLocation}",
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "Job For - ${userPost.categoryName}",
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "${userPost.date}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            userPost.isWishlistStatus ==
                                                                    false
                                                                ? userPost
                                                                        .isWishlistStatus =
                                                                    true
                                                                : userPost
                                                                        .isWishlistStatus =
                                                                    false;
                                                          });

                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  FutureProgressDialog(
                                                                      addToFavorurite(
                                                                          userPost
                                                                              .id)));
                                                        },
                                                        child: userPost
                                                                    .isWishlistStatus ==
                                                                false
                                                            ? Icon(
                                                                Icons
                                                                    .favorite_outline_outlined,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () => shareApp(),
                                                        child: Card(
                                                          elevation: 2,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Container(
                                                            //                          padding: EdgeInsets.all(10),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                Text("Share"),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          User user =
                                                              await ApiHandle
                                                                  .fetchUser();
                                                          userPost.postType ==
                                                                      "Artist" ||
                                                                  userPost.postType ==
                                                                      "Model"
                                                              ? Navigator.pushNamed(
                                                                  context,
                                                                  PageRoutes
                                                                      .applied_details,
                                                                  arguments:
                                                                      userPost)
                                                              : showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (context) =>
                                                                      FutureProgressDialog(applyJob(
                                                                          userPost
                                                                              .id!,
                                                                          "",
                                                                          null)));

                                                          // print('dfdf');
                                                        },
                                                        child: Card(
                                                          elevation: 2,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          color: buttonColor,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10),
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              "Apply",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                            Card(
                              elevation: 1,
                              color: cardColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Broadcast",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontFamily: 'Times',
                                          //fontStyle:FontStyle.italic,
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Create broadcast for notify ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                PageRoutes.broadcastPage,
                                                arguments: userDetails!.id);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, bottom: 5),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              alignment: Alignment.center,
                                              height: 40,
                                              child: Text(
                                                "Create",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: goldColor),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: goldColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.allCelebrityList);
                              },
                              child: Card(
                                color: cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "Celebrity Wishes",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "View All",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            userList != null
                                ? SizedBox(
                                    height: 210,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: userList!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  PageRoutes.userProfilePage,
                                                  arguments:
                                                      userList![index].id);
                                            },
                                            child: WisheshList(
                                                    context1: context,
                                                    user: userList![index],
                                                    userId: userId)
                                                .list,
                                          );
                                        }),
                                  )
                                : Container(),
                            Visibility(
                              visible: userDetails != null
                                  ? userDetails!.celebrity == "false"
                                      ? false
                                      : true
                                  : false,
                              child: Card(
                                color: cardColor,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Booking History",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontFamily: 'Times',
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "Check Your Booking History",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, bottom: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookingList(
                                                                type:
                                                                    "booked_me")));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                alignment: Alignment.center,
                                                height: 40,
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: goldColor),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: goldColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: cardColor,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Search profile",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontFamily: 'Times',
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Check user profile",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20, bottom: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  PageRoutes.userProfile);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              alignment: Alignment.center,
                                              height: 40,
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: goldColor),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: goldColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: cardColor,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Workshop Videos & Literature",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontFamily: 'Times',
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Workshop for fresher",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20, bottom: 5),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              alignment: Alignment.center,
                                              height: 40,
                                              child: Text(
                                                "Comming Soon",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: goldColor),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: goldColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.newUserPage);
                              },
                              child: Card(
                                color: cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "New Users",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "View All",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              visible: newUserList != null ? true : false,
                              child: SizedBox(
                                  height: 130,
                                  child: ListView.builder(
                                      itemCount: newUserList != null
                                          ? newUserList!.length
                                          : 3,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (context, index) => Container(
                                                margin: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    newUserList != null
                                                        ? newUserList![index]
                                                                .image
                                                                .isEmpty
                                                            ? CircleAvatar(
                                                                radius: 40.0,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/user/user1.png'))
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      PageRoutes
                                                                          .userProfilePage,
                                                                      arguments:
                                                                          newUserList![index]
                                                                              .id);
                                                                },
                                                                child: CircleAvatar(
                                                                    radius:
                                                                        40.0,
                                                                    backgroundImage: NetworkImage(con
                                                                            .Constraints
                                                                            .IMAGE_BASE_URL +
                                                                        newUserList![index]
                                                                            .image)),
                                                              )
                                                        : CircleAvatar(
                                                            radius: 40.0,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/user/user1.png')),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      newUserList != null
                                                          ? "${newUserList![index].name}"
                                                          : "New User",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ))),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        )
                      ],
                    ),
              /* isLoading == true
                  ? Align(
                      alignment: Alignment.center,
                      child: CustomeLoader.customLoader)
                  : Container() */

              se == "Yes"
                  ? Lottie.asset(
                      "assets/animation/sparkle.json",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      repeat: false,
                    )
                  : Container(),
            ]),
          ),
        ),
      ),
    );
  }

  Future<List<MySlider>> loadSlider() async {
    Response response = await Apis().getSlider();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      if (res == "success") {
        var re = data['data'] as List;
        print(re.length);
        return re.map<MySlider>((e) => MySlider.fromJson(e)).toList();
        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void fetchSlider() async {
    loadSlider().then((slide) => {
          for (int i = 0; i < slide.length; i++)
            {carouselImages.add(slide[i].image)}
        });
  }

  //fetch matching post

  Future<List<UserPost>> getUserMatchPost(String userId) async {
    Response response = await Apis().getMatchingPost(userId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      print(data);
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        setState(() {
          isLoading = false;
        });
        return re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> fetchUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");

    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    User userDet = await ApiHandle.fetchUser();
    //print(user.id + user.name);
    if (mounted) {
      setState(() {
        userId = user.id;
        userDetails = userDet;
      });
    }
  }

  Future<List<CelebrityUser>> loadCelebrityWishes() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getCelebrity(user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        setState(() {
          isLoading = false;
        });
        userList =
            re.map<CelebrityUser>((e) => CelebrityUser.fromJson(e)).toList();
        return re.map<CelebrityUser>((e) => CelebrityUser.fromJson(e)).toList();

        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i]; 
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        setState(() {
          isLoading = false;
        });
        MyToast(message: msg).toast;
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
            context: context,
            builder: (context) => Dialog(
                child: Container(
                    width: 200,
                    height: 340,
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
  }

  Future loadNewUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getNewUser(user.id);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            newUserList = re.map<User>((e) => User.fromMap(e)).toList();
            isLoading = false;
          });

        return re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void getToken(FirebaseMessaging? messaging) async {
    String? token = await messaging!.getToken();
    updateToken(token);
    print(token);
  }

  void updateToken(String? token) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().updateToken(user.id, token!);
    print(res.body);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        // MyToast(message: msg).toast;
      } else {
        //MyToast(message: msg).toast;
      }
    }
  }

  Future addToFavorurite(String? id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response res = await Apis().addFavouriteJob(user.id, id!);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  Future applyJob(String postId, String type, File? file) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);
    var result = await MyPrefManager.prefInstance().getData("user");
    print("hello");
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
        /* Future.delayed(
            Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(
                context, PageRoutes.bottomNavigation, (route) => false)); */
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  void clearShareData() async {
    bool result = await MyPrefManager.prefInstance().addData("New", "");
  }

  void fetchData() async {
    se = await MyPrefManager.prefInstance().getData("New");
  }
}
