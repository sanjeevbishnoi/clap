import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/directory_user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectoryDesign {
  BuildContext context;
  DirectoryUser user;

  DirectoryDesign({required this.context, required this.user});
  Widget get list => Padding(
      padding: EdgeInsets.only(top: 5, right: 5, left: 5),
      child: Card(
          color: cardColor,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              //color:
              /*  Colors.primaries[Random().nextInt(Colors.primaries.length)], */
              //color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      user.image!.isEmpty
                          ? CircleAvatar(
                              radius: 25.0,
                              backgroundImage:
                                  AssetImage('assets/user/user1.png'))
                          : CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  Constraints.IMAGE_BASE_URL + user.image!),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.name!}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${user.userCateory}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: user.mobileStatus == "true" ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        launch('tel:${user.mobile}');
                      },
                      child: Card(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.call,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )));
}
