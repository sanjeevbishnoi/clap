import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  final String message;
  MyToast({required this.message});

  get toast =>
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
}
