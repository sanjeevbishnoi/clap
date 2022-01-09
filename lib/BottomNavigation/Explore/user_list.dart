import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/search_user_design.dart';

class SearchUserList extends StatefulWidget {
  List<User> users;
  bool isLoading;
  bool isSearchStatus;
  SearchUserList(
      {required this.users,
      required this.isSearchStatus,
      required this.isLoading});

  @override
  _SearchUserListState createState() => _SearchUserListState();
}

class _SearchUserListState extends State<SearchUserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.isSearchStatus == true
            ? widget.isLoading == false
                ? widget.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.users.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.userProfilePage,
                                    arguments: widget.users[index].id);
                              },
                              child: SearchUserDesign(user: widget.users[index])
                                  .searchDesign,
                            ))
                    : Center(
                        child: Lottie.asset(
                          "assets/animation/no-data.json",
                          width: 250,
                          height: 250,
                        ),
                      )
                : Center(
                    child: SpinKitFadingCircle(
                      color: buttonColor,
                    ),
                  )
            : Center(
                child: Text(
                  "Search User Here..",
                  style: TextStyle(color: buttonColor, fontFamily: 'Times'),
                ),
              ));
  }
}
