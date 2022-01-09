import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:qvid/Theme/colors.dart';

class UserDesign {
  BuildContext context;

  UserDesign({required this.context});

  Padding get list => Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
          //gradient: LinearGradient(colors: [buttonColor, Colors.black87]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage('assets/user/user1.png')),
            SizedBox(
              height: 10,
            ),
            Text(
              "Search User",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                width: 100,
                height: 30,
                child: Text(
                  "View Profile",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ));
}
