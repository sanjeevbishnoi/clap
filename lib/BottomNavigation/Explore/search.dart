import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qvid/BottomNavigation/Explore/post_search_result.dart';
import 'package:qvid/BottomNavigation/Explore/reels_list.dart';
import 'package:qvid/BottomNavigation/Explore/user_list.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/model/user_video.dart';
import 'package:qvid/widget/toast.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  List<User> users = [];
  List<UserVideo> videos = [];
  List<UserPost> posts = [];
  bool isSearching = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (context) {
        final index = DefaultTabController.of(context)!.index;
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(165),
              child: Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      //MyCustomAppBar(context: context).myCustomAppBar,
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.black),
                          //onTap: () => Navigator.pushNamed(context, PageRoutes.searchPage),
                          decoration: InputDecoration(
                              icon: Icon(Icons.search, color: color1),
                              border: InputBorder.none,
                              hintText: "Search here...",
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() {
                                    isSearching = false;
                                    isLoading = false;
                                    if (index == 0) {
                                      users = [];
                                    } else if (index == 1) {
                                      videos = [];
                                    } else {
                                      posts = [];
                                    }
                                  });
                                },
                              )),
                          onChanged: (value) {
                            if (value.length > 0) {
                              setState(() {
                                /*
                                isLoading == true;
                                searchPost(value); */
                                isSearching = true;
                                isLoading = true;
                                searchStart(value, index);
                              });
                              print("searching");
                            } else {
                              if (mounted)
                                setState(() {
                                  isSearching = false;
                                  if (index == 0) {
                                    users = [];
                                  } else if (index == 1) {
                                    videos = [];
                                  } else {
                                    posts = [];
                                  }
                                });
                              print("Not searching");
                              /* isSearching = false;
                              isLoading == false; */
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 84,
                        child: AppBar(
                          bottom: TabBar(
                            onTap: (index) {
                              print(index);
                            },
                            tabs: [
                              Tab(
                                child: Text(
                                  "Users",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Reels",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Jobs",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            body: TabBarView(children: [
              SearchUserList(
                users: users,
                isSearchStatus: isSearching,
                isLoading: isLoading,
              ),
              ReelsList(
                reels: videos,
                isSearchingStatus: isSearching,
                isLoading: isLoading,
              ),
              PostSearch(
                  list: posts,
                  isSearchStatus: isSearching,
                  isLoading: isLoading)
            ]));
      }),
    );
  }

  void getSelectedTab() {
    if (DefaultTabController.of(context) != null) {
      int index = DefaultTabController.of(context)!.index;
      print(index);
    }
  }

  Future searchStart(String value, int index) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response;

    if (index == 0) {
      response = await Apis().searchAll(value, "users", user.id);
      print("users");
    } else if (index == 1) {
      response = await Apis().searchAll(value, "reels", user.id);
      print("reels");
    } else {
      response = await Apis().searchAll(value, "posts", user.id);
      print("posts");
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(data);
        print(re.length);

        if (mounted)
          setState(() {
            isLoading = false;
            if (index == 0) {
              users = re.map<User>((e) => User.fromMap(e)).toList();
            } else if (index == 1) {
              videos = re.map<UserVideo>((e) => UserVideo.fromJson(e)).toList();
            } else {
              posts = re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
            }
          });
        if (index == 0) {
          return re.map<User>((e) => User.fromMap(e)).toList();
        } else if (index == 1) {
          return re.map<UserVideo>((e) => UserVideo.fromJson(e)).toList();
        } else {
          return re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
        }

        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        //  MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
          if (index == 0) {
            users = [];
          } else if (index == 1) {
            videos = [];
          } else {
            posts = [];
          }
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void fetchUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);

    setState(() {
      //userId = user.id;
    });
  }
}
