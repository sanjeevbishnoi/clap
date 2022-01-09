import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qvid/Screens/chat/chat_controller.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/chat_message.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  ChatUser receiver;
  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  User? sender;
  List<ChatMessage> messages = [];
  ChatController chatController = Get.put(ChatController());
  bool isLoading = true;
  final TextEditingController _message = TextEditingController();
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    chatController.chatList.value = <Map>[];
    Future.delayed(Duration(seconds: 1), () {
      findUser()
          .then((value) => {getChatMessages(sender!.id, widget.receiver.id!)});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      messages.clear();
      Future.delayed(Duration(seconds: 1), () {
        findUser().then(
            (value) => {getChatMessages(sender!.id, widget.receiver.id!)});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: buttonColor,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white)),
                Expanded(
                  child: Row(
                    children: [
                      widget.receiver.image!.isEmpty
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/user_icon.png"),
                              radius: 17,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  Constraints.IMAGE_BASE_URL +
                                      widget.receiver.image!),
                              radius: 17,
                            ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.receiver.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            "online",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      )),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/background.jpg"))),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Obx(
                  () => chatController.chatList.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 75),
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView.builder(
                            itemCount: chatController.chatList.length,
                            shrinkWrap: true,
                            reverse: false,
                            controller: _controller,
                            //                        reverse: true,
                            padding: EdgeInsets.only(bottom: 50),
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Align(
                                    alignment: (chatController.chatList[index]
                                                ['i'] ==
                                            "1")
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Container(
                                      width: chatController
                                                  .chatList[index]['message']
                                                  .length >
                                              10
                                          ? 200
                                          : 100,
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: chatController.chatList[index]
                                                    ['i'] ==
                                                "1"
                                            ? buttonColor
                                            : Colors.deepPurple,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chatController.chatList[index]
                                                ['message'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    /* (messages[index].id == widget.receiver.id
                                                  ? Colors.black
                                                  : Colors.white) */
                                                    Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              chatController.chatList[index]
                                                          ['time']
                                                      .split(":")[0] +
                                                  ":" +
                                                  chatController.chatList[index]
                                                          ['time']
                                                      .split(":")[1],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      /* (messages[index].id == widget.receiver.id
                                                    ? Colors.black
                                                    : Colors.white) */
                                                      Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        )
                      : Container(),
                ),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 75,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.emoji_emotions,
                                    size: 25,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      print("sdsd");
                                      Timer(
                                          Duration(milliseconds: 300),
                                          () => _controller.jumpTo(_controller
                                              .position.maxScrollExtent));
                                    },
                                    controller: _message,
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      hintText: "Write message",
                                      border: InputBorder.none,
                                      /* border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.transparent)) */
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      openBottomSheet();
                                    },
                                    child: Icon(
                                      Icons.attach_file_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if (valid()) {
                              DateTime now = DateTime.now();
                              var currentTime = now.hour.toString() +
                                  ":" +
                                  now.minute.toString();
                              chatController.receiveMessage(
                                  _message.text, "2", currentTime);

                              _message.text = "";
                              Timer(
                                  Duration(milliseconds: 100),
                                  () => _controller.jumpTo(
                                      _controller.position.maxScrollExtent));
                              Future.delayed(Duration(seconds: 1), () {
                                sendMessage(
                                    widget.receiver.id!, sender!.id, message!);
                              });
                            }
                          },
                          child: Icon(
                            Icons.send,
                          ),
                          elevation: 0,
                        ),
                      ],
                    ),
                  )),
              /* isLoading == true
                  ? Align(
                      alignment: Alignment.center,
                      child: SpinKitFadingCircle(color: buttonColor))
                  : Container() */
            ],
          ),
        ),
      ),
    );
  }

  Future findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    setState(() {
      sender = user;
    });

    //MyToast(message: user.id).toast;
  }

  //send Message
  Future<void> sendMessage(
      String receiverId, String senderId, String message) async {
    http.Response response =
        await Apis().sendMessages(senderId, receiverId, message);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        //MyToast(message: msg).toast;
        //isComment = false;

      } else {
        MyToast(message: msg).toast;
      }
    } else {
      MyToast(message: "Server Errror");
    }
  }

  String? message;
  bool valid() {
    message = _message.text;
    if (message!.isEmpty) {
      MyToast(message: "Please Write Message").toast;
      return false;
    } else {
      return true;
    }
  }

  //load chat list

  Future<List<ChatMessage>> getChatMessages(
      String senderId, String receriverId) async {
    messages.clear();
    http.Response response = await Apis().getChatList(senderId, receriverId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            messages =
                re.map<ChatMessage>((e) => ChatMessage.fromJson(e)).toList();
            for (int i = 0; i < messages.length; i++) {
              chatController.receiveMessage(
                  messages[i].message,
                  messages[i].senderId == senderId ? "2" : "1",
                  messages[i].time!);
              Timer(
                  Duration(milliseconds: 10),
                  () =>
                      _controller.jumpTo(_controller.position.maxScrollExtent));
            }
            isLoading = false;
          });

        return re.map<ChatMessage>((e) => ChatMessage.fromJson(e)).toList();
        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void openBottomSheet() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Positioned(
              bottom: 90,
              left: 25,
              right: 25,
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Card(
                                //color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: Icon(
                                    Icons.photo,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                )),
                            SizedBox(width: 10),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                    height: 60,
                                    width: 60,
                                    child: Icon(
                                      Icons.video_camera_back_outlined,
                                      color: Colors.red,
                                      size: 30,
                                    ))),
                          ],
                        )
                      ],
                    ),
                  )),
            ));
  }
}
