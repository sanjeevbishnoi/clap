import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class WorkshopPage extends StatefulWidget {
  @override
  _WorkshopPageState createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Comming soon",
          style: TextStyle(fontSize: 20, color: color2),
        ),
      ),
    );
  }
}
