import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qvid/Theme/colors.dart';

class CustomeLoader {
  static get customLoader => SpinKitCircle(
        color: Colors.blue,
        size: 70,
      );
}
