import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qvid/Components/thumb_list.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Screens/post_list.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/widget/toast.dart';

List<String> dance = [
  'assets/thumbnails/dance/Layer 951.png',
  'assets/thumbnails/dance/Layer 952.png',
  'assets/thumbnails/dance/Layer 953.png',
  'assets/thumbnails/dance/Layer 954.png',
  'assets/thumbnails/dance/Layer 951.png',
  'assets/thumbnails/dance/Layer 952.png',
  'assets/thumbnails/dance/Layer 953.png',
  'assets/thumbnails/dance/Layer 954.png',
];

List<String> lol = [
  'assets/thumbnails/lol/Layer 978.png',
  'assets/thumbnails/lol/Layer 979.png',
  'assets/thumbnails/lol/Layer 980.png',
  'assets/thumbnails/lol/Layer 981.png',
];
List<String> food = [
  'assets/thumbnails/food/Layer 783.png',
  'assets/thumbnails/food/Layer 784.png',
  'assets/thumbnails/food/Layer 785.png',
  'assets/thumbnails/food/Layer 786.png',
  'assets/thumbnails/food/Layer 787.png',
  'assets/thumbnails/food/Layer 788.png',
];

/* List<String> carouselImages = [
  "assets/images/banner 1.png",
  "assets/images/banner 2.png",
//  "assets/images/banner 1.png",
//  "assets/images/banner 2.png",
];
 */
class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExploreBody();
  }
}

class ExploreBody extends StatefulWidget {
  @override
  _ExploreBodyState createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
//  late List<UserPost> lists;
  List<UserPost>? list;
  bool isSearching = false;
  bool isDataFound = false;
  bool isLoading = false;
  var _controller = TextEditingController();

  final List<ThumbList> thumbLists = [
    ThumbList(dance),
/*     ThumbList(lol),
    ThumbList(food),
    ThumbList(dance),
    ThumbList(lol),
    ThumbList(food), */
  ];

  User? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Column(
          children: [
            Container(
                child: MyCustomAppBar(context: context, user: userDetails!)
                    .myCustomAppBar),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                controller: _controller,

                //onTap: () => Navigator.pushNamed(context, PageRoutes.searchPage),
                decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    hintText: "Search here...",
                    hintStyle: Theme.of(context).textTheme.subtitle1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          isSearching = false;
                        });
                      },
                    )),
                onChanged: (value) {
                  if (value.length > 2) {
                    setState(() {
                      isSearching = true;
                      isLoading == true;
                      searchPost(value);
                    });
                    print("searching");
                  } else {
                    print("Not searching");
                    isSearching = false;
                    isLoading == false;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FadedSlideAnimation(
          ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: thumbLists.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            //titleRows[index],
                            thumbLists[index],
                          ],
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: Text(
                      "Latest Post",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading == true
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  SizedBox(
                    height: 5,
                  ),
                  isSearching == true
                      ? isDataFound == true
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: list!.length,
                              itemBuilder: (context, index) {
                                return /* PostList(
                                        context: context,
                                        userPost: list![index])
                                    .list; */
                                    Container();
                              })
                          : Center(child: Text("No Data Found"))
                      : Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                "Search post Here.... ",
                                style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )))
                ],
              ),
            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    ));
  }

  //search here

  Future<List<UserPost>> searchPost(String value) async {
    Response response = await Apis().searchPost(value);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re);
        print(re.length);

        if (mounted)
          setState(() {
            list = re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
            //isSearching = false;
            isLoading = false;
            isDataFound = true;
            FocusManager.instance.primaryFocus!.unfocus();
          });
        return re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
      } else {
        MyToast(message: msg).toast;
        setState(() {
          //isSearching = false;
          isLoading = false;
          isDataFound = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void fetchUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");

    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    User userDet = await ApiHandle.fetchUser();
    //print(user.id + user.name);
    setState(() {
      userDetails = userDet;
    });
  }
}
