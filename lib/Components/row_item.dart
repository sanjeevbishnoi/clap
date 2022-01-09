import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class RowItem extends StatelessWidget {
  final String title;
  final String? subtitle;

  RowItem(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14, height: 1.5),
        children: [
          TextSpan(
            text: title + '\n',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextSpan(
            text: subtitle,
            style: TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
