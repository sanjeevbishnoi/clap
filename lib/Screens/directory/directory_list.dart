import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/directory/category_card_design.dart';
import 'package:qvid/Screens/directory/directory_card_design.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/directory_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/widget/toast.dart';

class DirectoryScreen extends StatefulWidget {
  DirectoryScreen({Key? key}) : super(key: key);

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  List<DirectoryUser>? users;
  List<DirectoryUser>? filterUsers;
  List<UserCategories>? list;
  List<UserCategories>? filterList;

  List<DirectoryUser>? catUser;

  bool isCategory = true;
  bool isLoading = true;
  bool isSearching = false;
  bool isDataFound = false;
  String? userId;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      getDirectoryUser();
    });
    findUser().then((value) => fetchCategoriesName());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  child: /* Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: Icon(Icons.arrow_back_ios),
                    )), */
                      GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: buttonColor,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: TextField(
                      controller: _controller,
                      //onTap: () => Navigator.pushNamed(context, PageRoutes.searchPage),
                      decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white),
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
                        if (value.length > 0) {
                          setState(() {
                            isCategory == false
                                ? getSearchUser(value)
                                : getSearchCategory(value);
                            isSearching = true;
                            /* isSearching = true;
                            isLoading == true;
                            searchChatUser(value); */
                          });
                          //print("searching");
                        } else {
                          setState(() {
                            isCategory == true
                                ? getSearchUser("")
                                : getSearchCategory("");
                            isSearching = false;
                            /* isSearching = true;
                            isLoading == true;
                            searchChatUser(value); */
                          });
                          //print("Not searching");

                          /* 
                          isLoading == false; */
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategory = true;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: isCategory == true
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue)
                            : null,
                        child: Text(
                          "Category",
                          style: TextStyle(
                              color: isCategory == true
                                  ? Colors.white
                                  : buttonColor),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategory = false;
                        isSearching = false;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: isCategory == false
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue,
                              )
                            : null,
                        child: Text(
                          "All People",
                          style: TextStyle(
                              color: isCategory == false
                                  ? Colors.white
                                  : buttonColor),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            isLoading == false
                ? list != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: catUser == null || catUser!.isEmpty
                            ? isSearching == false
                                ? isCategory == true && list != null
                                    ? list!.length
                                    : users != null
                                        ? users!.length
                                        : 0
                                : isCategory == true
                                    ? filterList!.length
                                    : filterUsers!.length
                            : catUser!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return isCategory == false
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PageRoutes.userProfilePage,
                                        arguments: users![index].id);
                                  },
                                  child: users != null
                                      ? DirectoryDesign(
                                          context: context,
                                          user: isSearching == false
                                              ? users![index]
                                              : filterUsers![index],
                                        ).list
                                      : Container(),
                                )
                              : catUser != null && catUser!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PageRoutes.userProfilePage,
                                            arguments: catUser![index].id);
                                      },
                                      child: DirectoryDesign(
                                              context: context,
                                              user: catUser![index])
                                          .list,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        getDirectoryUserByCategory(
                                            isSearching == false
                                                ? list![index].id
                                                : filterList![index].id);
                                        setState(() {
                                          isLoading = true;
                                        });
                                      },
                                      child: CategoryCardDesign(
                                        context: context,
                                        category: isSearching == false
                                            ? list![index]
                                            : filterList![index],
                                      ).list,
                                    );
                        })
                    : Center(child: Text(""))
                : Center(
                    child: /* Lottie.asset(
                      "assets/animation/no-data.json",
                      width: 250,
                      height: 250,
                    ), */
                        Container()),

            /*  : Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          "Search User Here.... ",
                          style: TextStyle(
                            color: buttonColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ))), */
            isLoading == true
                ? Align(
                    alignment: Alignment.center,
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                    ),
                  )
                : Container(),
          ],
        ));
  }

  //get Directory User
  Future<List<DirectoryUser>> getDirectoryUser() async {
    /* setState(() {
      isLoading = true;
    }); */
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getDirectory(user.id);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re);
        print(re.length);

        if (mounted)
          setState(() {
            users = re
                .map<DirectoryUser>((e) => DirectoryUser.fromJson(e))
                .toList();
            //isSearching = false;
            //     isLoading = false;
            isDataFound = true;
            FocusManager.instance.primaryFocus!.unfocus();
          });
        return re.map<DirectoryUser>((e) => DirectoryUser.fromJson(e)).toList();
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

  //

  Future<List<DirectoryUser>> getSearchUser(String search) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<DirectoryUser> filterUserList = [];

    users!.forEach((DirectoryUser) {
      if (DirectoryUser.name!.toLowerCase().contains(search.toLowerCase()))
        filterUserList.add(DirectoryUser);
    });

    print(filterUserList.length);

    final suggestionList = search.isEmpty ? users! : filterUserList;
    setState(() {
      filterUsers = filterUserList;
    });
    return suggestionList;
  }
  //load Category

  Future<List<UserCategories>> getSearchCategory(String search) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<UserCategories> filterCategoryList = [];

    list!.forEach((UserCategories) {
      if (UserCategories.name.toLowerCase().contains(search.toLowerCase())) {
        print(UserCategories.id + UserCategories.name);
        filterCategoryList.add(UserCategories);
      }
    });
    print(filterCategoryList.length);
    print("$filterCategoryList");
    final suggestionList = search.isEmpty ? list! : filterCategoryList;
    setState(() {
      filterList = filterCategoryList;
    });
    return suggestionList;
  }

  Future<List<UserCategories>> loadCategies() async {
    Response response = await Apis().getUserCategories();
    var statusCode = response.statusCode;
    print(response.body);
    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var cat = data['data'] as List;
        print("category size ${cat.length}");
        return cat
            .map<UserCategories>((e) => UserCategories.fromJson(e))
            .toList();
      } else {
        throw Exception("somthing wrong");
      }
    } else {
      throw Exception("sdsds");
    }
  }

  void fetchCategoriesName() async {
    List<UserCategories> lis = await loadCategies();
    setState(() {
      isLoading = false;
      list = lis;
    });
  }

  Future findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
  }

  Future<List<DirectoryUser>> getDirectoryUserByCategory(String catId) async {
    setState(() {
      isLoading = true;
    });
    print(catId);
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getDirectoryByCategory(catId, user.id);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re);
        print(re.length);

        if (mounted)
          setState(() {
            catUser = re
                .map<DirectoryUser>((e) => DirectoryUser.fromJson(e))
                .toList();
            //isSearching = false;
            isLoading = false;
            isDataFound = true;
            FocusManager.instance.primaryFocus!.unfocus();
          });
        return re.map<DirectoryUser>((e) => DirectoryUser.fromJson(e)).toList();
      } else {
        MyToast(message: msg).toast;
        var re = data['data'] as List;
        setState(() {
          print("hi");
          catUser =
              re.map<DirectoryUser>((e) => DirectoryUser.fromJson(e)).toList();
          //isSearching = false;
          isLoading = false;
          isDataFound = true;
        });
        return re.map<DirectoryUser>((e) => DirectoryUser.fromJson(e)).toList();
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
