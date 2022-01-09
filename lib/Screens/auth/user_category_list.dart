import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/widget/category_list.dart';
import 'package:qvid/widget/toast.dart';

class AvaliableCategoryList extends StatefulWidget {
  @override
  State<AvaliableCategoryList> createState() => _AvaliableCategoryListState();
}

class _AvaliableCategoryListState extends State<AvaliableCategoryList> {
  GlobalKey<NavigatorState> _key = GlobalKey();
  List<UserCategories>? list;
  List<UserCategories>? filterList;
  String? userId;
  bool isSearching = false;
  bool isLoading = true;
  String categoryNam = "";
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      findUser();
      fetchCategoriesName();
    });
  }

  @override
  Widget build(BuildContext context) {
    var catName = ModalRoute.of(context)!.settings.arguments as String;
    categoryNam = catName;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Column(
          children: [
            AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: buttonColor),
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context, {});
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "Available Expertise list",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
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
                      getSearchCategory(value);
                      isSearching = true;
                      /* isSearching = true;
                          isLoading == true;
                          searchChatUser(value); */
                    });
                    //print("searching");
                  } else {
                    setState(() {
                      getSearchCategory("");
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
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                      child: list != null
                          ? CategoryList(
                              isSearching == false ? list! : filterList!, 2)
                          : Container())
                ],
              ),
            ],
          ),
        ),
        isLoading == true
            ? Align(
                alignment: Alignment.center,
                child: SpinKitFadingCircle(
                  color: buttonColor,
                ),
              )
            : Container(),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              if (valid()) {
                Navigator.pop(context, {
                  "idlist": listToString(idList),
                  "categoryName": listToString(categoryName)
                });
                idList.clear();
                categoryName.clear();
              }
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              color: buttonColor,
            ),
          ),
        )
      ]),
    );
  }

  Future<List<UserCategories>> loadCategies() async {
    Response response = await Apis().getCategories(categoryNam);
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
        return [];
      }
    } else {
      return [];
    }
  }

  void fetchCategoriesName() async {
    List<UserCategories> lis = await loadCategies();
    setState(() {
      isLoading = false;
      list = lis;
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

  Future<String> findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
    return user.id;
  }

  late List<String> idList;
  late List<String> categoryName;
  bool valid() {
    idList = CategoryList(list!, 2).createState().getSelectedList();
    categoryName =
        CategoryList(list!, 2).createState().getSelectedCategoryName();
    if (idList.isEmpty) {
      MyToast(message: "Please Select Category").toast;
      return false;
    } else if (categoryName.isEmpty) {
      MyToast(message: "Please Select Category").toast;
      return false;
    } else {
      return true;
    }
  }

  // search user

  Future<List<UserCategories>> getSearchCategory(String search) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<UserCategories> filterCategoryList = [];

    list!.forEach((UserCategories) {
      if (UserCategories.name.toLowerCase().contains(search.toLowerCase()))
        filterCategoryList.add(UserCategories);
    });

    print(filterCategoryList.length);

    final suggestionList = search.isEmpty ? list! : filterCategoryList;
    setState(() {
      filterList = filterCategoryList;
    });
    return suggestionList;
  }

  Future<bool> _willPopCallback() async {
    if (_key.currentState!.canPop()) {
      _key.currentState!.pop();

      return false;
    }

    return true;
  }
}
