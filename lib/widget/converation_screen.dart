import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/chat/chat_details.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/utils/constaints.dart';

class ConversationScreen extends StatefulWidget {
  ChatUser user;
  int i;
  ConversationScreen({required this.user, required this.i});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      receiver: widget.user,
                    )));
      },
      child: Padding(
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
                      widget.user.image != null && widget.user.image!.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  Constraints.IMAGE_BASE_URL +
                                      widget.user.image!),
                              radius: 30,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/user_icon.png"),
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
                                widget.user.name!,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.i == 1
                                    ? widget.user.message!
                                    : widget.user.bio!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                  widget.user.chatTime != null &&
                          widget.user.chatTime!.isNotEmpty
                      ? Visibility(
                          visible:
                              widget.user.chatTime!.isNotEmpty ? true : false,
                          child: Text(
                              widget.user.chatTime != null
                                  ? widget.user.chatTime!.split(":")[0] +
                                      ":" +
                                      widget.user.chatTime!.split(":")[1] +
                                      " " +
                                      widget.user.chatTime!
                                          .split(":")[2]
                                          .split(" ")[1]
                                  : "",
                              style: TextStyle(color: goldColor)))
                      : Container(),
                ],
              ),
              Divider(
                color: Colors.grey.shade500,
              )
            ],
          ),
        ),
      ),
    );
  }
}
