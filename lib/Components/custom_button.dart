import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function? onPressed;

  CustomButton(this.icon, this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: transparentColor,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          icon,
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white),
          )
        ],
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
