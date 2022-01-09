import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/Components/custom_button.dart';

import 'package:qvid/Theme/colors.dart';

class VideoOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoOption();
  }
}

class VideoOption extends StatefulWidget {
  @override
  _VideoOptionState createState() => _VideoOptionState();
}

class _VideoOptionState extends State<VideoOption> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return FadedSlideAnimation(
      Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/thumbnails/food/Layer 783.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          AppBar(
            actions: <Widget>[
              PopupMenuButton(
                color: backgroundColor,
                icon: Icon(Icons.more_vert, color: secondaryColor),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none),
                onSelected: (dynamic value) => Navigator.pop(context),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text("Delete"),
                      value: "Delete",
                      textStyle: TextStyle(color: secondaryColor),
                    ),
                  ];
                },
              ),
            ],
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: -10.0,
            bottom: 80.0,
            child: Column(
              children: <Widget>[
                CustomButton(
                  ImageIcon(
                    AssetImage('assets/icons/ic_views.png'),
                    color: secondaryColor,
                  ),
                  '1.2k',
                ),
                CustomButton(
                    ImageIcon(
                      AssetImage('assets/icons/ic_comment.png'),
                      color: secondaryColor,
                    ),
                    '287', onPressed: () {
                  commentSheet(context);
                }),
                CustomButton(
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: secondaryColor,
                  ),
                  '8.2k',
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                SizedBox(height: 12.0),
                CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user_icon.png'))
              ],
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 12.0,
            bottom: 72.0,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '@emiliwilliamson\n',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                TextSpan(text: "Wow"),
                TextSpan(
                    text: 'See More',
                    style: TextStyle(
                        color: secondaryColor.withOpacity(0.5),
                        fontStyle: FontStyle.italic))
              ]),
            ),
          )
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
