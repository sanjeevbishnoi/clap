import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/converation_screen.dart';
import 'package:qvid/widget/toast.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({Key? key}) : super(key: key);

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  List<ChatUser> users = [];
  bool isLoading = false;
  bool isSearching = false;
  bool isDataFound = false;
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: buttonColor, //or set color with: Color(0xFF0000FF)
    ));
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: buttonColor,
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
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
                        icon: Icon(Icons.search, color: Colors.black),
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
                            });
                          },
                        )),
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          isSearching = true;
                          isLoading == true;
                          searchChatUser(value);
                        });
                        print("searching");
                      } else {
                        print("Not searching");
                        /*  isSearching = false;
                        isLoading == false; */
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              isSearching == true
                  ? users.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ConversationScreen(
                              user: users[index],
                              i: 2,
                            );
                          })
                      : Center(
                          child: Lottie.asset(
                            "assets/animation/no-data.json",
                            width: 250,
                            height: 250,
                          ),
                        )
                  : Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "Search User Here.... ",
                            style: TextStyle(
                              color: buttonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
              isLoading == true
                  ? Align(
                      alignment: Alignment.center,
                      child: SpinKitFadingCircle(
                        color: buttonColor,
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }

  //search here
  Future<List<ChatUser>> searchChatUser(String value) async {
    setState(() {
      isLoading = true;
    });
    print(value);
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().searchChatUserList(value, user.id);
    print(response);
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
            users = re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
            //isSearching = false;
            isLoading = false;
            isDataFound = true;
            FocusManager.instance.primaryFocus!.unfocus();
            print(users.length);
          });
        return re.map<ChatUser>((e) => ChatUser.fromJson(e)).toList();
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
}
