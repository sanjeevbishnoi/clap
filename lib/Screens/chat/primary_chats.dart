import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/widget/converation_screen.dart';

class PrimaryChats extends StatefulWidget {
  final List<ChatUser> users;
  PrimaryChats({required this.users});
  @override
  State<PrimaryChats> createState() => _PrimaryChatsState();
}

class _PrimaryChatsState extends State<PrimaryChats> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? widget.users.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: widget.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ConversationScreen(user: widget.users[index], i: 1);
                  })
              : Center(
                  child: Lottie.asset(
                    "assets/animation/no-data.json",
                    width: 250,
                    height: 250,
                  ),
                )
          : Container(),
    );
  }
}
