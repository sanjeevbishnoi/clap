import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/auth/wishlist_users.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class WishlistUserDesign {
  User user;
  BuildContext context;
  WishlistUserDesign({required this.user, required this.context});
  Widget get wishlistUserDesign => Padding(
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.userProfilePage,
                arguments: user.id);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    user.image.isEmpty
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/user_icon.png"),
                            radius: 30,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                Constraints.IMAGE_BASE_URL + user.image),
                            radius: 30,
                          ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.name}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          /* Text(
                            "${user.userCategoryName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ), */
                        ],
                      ),
                    ),
                  ],
                )),
                GestureDetector(
                  onTap: () {
                    removeFromWishlist(user.id);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Future<void> removeFromWishlist(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().addWishList(user.id, id);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      if (res == "success") {
        MyToast(message: msg).toast;
        Navigator.popAndPushNamed(context, PageRoutes.wishlistUsers);
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Retry").toast;
    }
  }
}
