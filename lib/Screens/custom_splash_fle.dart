import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/chat/chat_controller.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/main.dart';
import 'package:qvid/model/user.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

/* void main() {
  runApp(MySplashFile());
} */

class MySplashFile extends StatefulWidget {
  const MySplashFile({Key? key}) : super(key: key);
  @override
  State<MySplashFile> createState() => _MySplashFileState();
}

class _MySplashFileState extends State<MySplashFile> {
  late VideoPlayerController _controller;
  ChatController chatController = Get.put(ChatController());
  @override
  void initState() {
    print("hi");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification);
      DateTime now = DateTime.now();
      var currentTime = now.hour.toString() + ":" + now.minute.toString();
      print(message.data['body']);
      chatController.receiveMessage(
          message.notification!.body, "1", currentTime);
      // showNotification();
      //RemoteNotification notification = message.notification!;
      //AndroidNotification? android = message.notification?.android;

      //if (android != null) {
      //showNotification();
      /*      flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            )); */
      //}
    });
    Future.delayed(Duration(seconds: 8), () {
      hanldleNavigation(context);
    });
    super.initState();
    _controller = VideoPlayerController.asset("assets/audio/splash_video.mp4")
      ..initialize().then((value) {
        setState(() {
          print("is Intilized");
          //_controller.setLooping(true);
          _controller.play();
        });
      });
  }

  /* showNotification() async {
    print("hiello");
    var android = new AndroidNotificationDetails('channel id', 'channel NAME',
        channelDescription: 'CHANNEL DESCRIPTION',
        priority: Priority.high,
        importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Tutorial', 'Local Notification', platform,
        payload: 'AndroidCoding.in');
  } */

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: buttonColor,
        statusBarBrightness:
            Brightness.light //or set color with: Color(0xFF0000FF)
        ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: videoColor,
        body: Align(
          alignment: Alignment.center,
          child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  height: _controller.value.size.height,
                  width: _controller.value.size.width,
                  child: VideoPlayer(_controller))),
        ));
  }

  hanldleNavigation(BuildContext context) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    print(result);
    if (result == null) {
      print("user not found");
      Navigator.pushNamedAndRemoveUntil(
          context, PageRoutes.login_screen, (route) => false);
    } else {
      print("user  found");
      User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
      if (user.otpStatus == "true") {
        http.Response response = await Apis().getUser(user.id);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          String res = data['res'];
          if (res == "success") {
            User user = User.fromMap(data['data'] as Map<String, dynamic>);
            //update shareprefernce

            bool result = await MyPrefManager.prefInstance()
                .addData("user", jsonEncode(data['data']));

            if (user.name.isEmpty) {
              print("sdsd ${user.name}");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutes.personal_info, (route) => false);
            } /* else if (user.talent.isEmpty || user.interest.isEmpty) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutes.choose_talent, (route) => false);
            } /*  else if (user.youtubeLink.isEmpty || user.instagramLink.isEmpty) {
              */ Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutes.social_media_info, (route) => false);
            } */
            else if (user.bio.isEmpty || user.image.isEmpty) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutes.basic_profile_info, (route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutes.bottomNavigation, (route) => false);
            }
          } else {}
        } else {}
      } else {}
    }
  }
}
