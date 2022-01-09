import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';

class SearchUserDesign {
  User user;
  SearchUserDesign({required this.user});
  Widget get searchDesign => Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Row(
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
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.name}",
                                style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${user.userCategoryName}",
                                style: TextStyle(color: buttonColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Divider(
                color: Colors.grey.shade500,
              )
            ],
          ),
        ),
      );
}
