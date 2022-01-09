import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class ProfilePageButton extends StatelessWidget {
  final String? text;
  final Function onTap;
  final Color? color;
  final Color? textColor;
  final double? width;

  ProfilePageButton(this.text, this.onTap,
      {this.color, this.textColor, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        width: width ?? 84.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          text!,
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
