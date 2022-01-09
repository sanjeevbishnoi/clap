import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/wishlist_user_desgin.dart';

class WishlistUsers extends StatefulWidget {
  @override
  _WishlistUsersState createState() => _WishlistUsersState();
}

class _WishlistUsersState extends State<WishlistUsers> {
  List<User> wishlistUser = [];
  bool isLoading = true;
  @override
  void initState() {
    loadWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Wishlist",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading == false
          ? wishlistUser.isNotEmpty
              ? ListView.builder(
                  itemCount: wishlistUser.length,
                  itemBuilder: (context, index) => WishlistUserDesign(
                          user: wishlistUser[index], context: context)
                      .wishlistUserDesign)
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
            ),
    );
  }

  Future loadWishlist() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getWishList(user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      print(response.body);
      if (res == "success") {
        var re = data['data'] as List;

        setState(() {
          wishlistUser = re.map<User>((e) => User.fromMap(e)).toList();

          isLoading = false;
        });

        return re.map<User>((e) => User.fromMap(e)).toList();
      } else {
        if (mounted)
          setState(() {
            wishlistUser = [];

            isLoading = false;
          });
      }
    } else {}
  }
}
