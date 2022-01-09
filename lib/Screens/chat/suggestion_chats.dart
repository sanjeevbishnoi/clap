import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/widget/converation_screen.dart';

class SuggestionChats extends StatefulWidget {
  final List<ChatUser> users;
  SuggestionChats({required this.users});
  @override
  State<SuggestionChats> createState() => _SuggestionChatsState();
}

class _SuggestionChatsState extends State<SuggestionChats> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.users.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 10),
              itemCount: widget.users.length,
              itemBuilder: (BuildContext context, int index) {
                return ConversationScreen(user: widget.users[index], i: 2);
              })
          : Center(
              child: Lottie.asset(
                "assets/animation/no-data.json",
                width: 250,
                height: 250,
              ),
            ),
    );
  }
}
