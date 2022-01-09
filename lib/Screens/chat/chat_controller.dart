import 'package:get/get.dart';

class ChatController extends GetxController {
  var chatList = <Map>[].obs;

  receiveMessage(dynamic message, String i, String time) {
    var map = Map();
    map['message'] = message;
    map['i'] = '$i';
    map['time'] = time;
    chatList.add(map);
  }
}
