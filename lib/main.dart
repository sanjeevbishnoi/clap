import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/custom_splash_fle.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/Theme/style.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';

import 'model/user.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
/*   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
      overlays: [SystemUiOverlay.bottom]); */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print(message.data);
  print("hi");
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bollywood clap",
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.openSansTextTheme().copyWith(
          subtitle1: TextStyle(color: disabledTextColor),
          caption: TextStyle(color: disabledTextColor),
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
          headline6: TextStyle(fontSize: 18.0, color: Colors.black),
          button: TextStyle(fontSize: 16.0, letterSpacing: 1),
          subtitle2: TextStyle(),
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        primaryColor: mainColor,
//  accentColor: mainColor,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(color: Colors.red),
            unselectedLabelStyle: TextStyle(color: disabledTextColor)),

        ///appBar theme
        appBarTheme: AppBarTheme(
            color: transparentColor,
            elevation: 0.0,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent)),
      ),
      routes: PageRoutes().routes(),
      home: MySplashFile(),
    );
  }
}
