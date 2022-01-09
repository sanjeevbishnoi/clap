import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:share/share.dart';

class ReferAndEarnPage extends StatefulWidget {
  @override
  _ReferAndEarnPageState createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: buttonColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: buttonColor,
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Refer your friends & win ₹ 100",
                style: TextStyle(fontSize: 25, color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Invite your friends to Clap.When they create a profile on the app and start watching videos you win ₹ 15 per friend and they win ₹ 15 ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white60),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset("assets/images/refer.png",
                  width: MediaQuery.of(context).size.width, height: 200)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: GestureDetector(
                onTap: () {
                  shareApp();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Text(
                    "Invite Friends",
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  shareApp() {
    Share.share('Bollywood clap https://example.com');
  }
}
