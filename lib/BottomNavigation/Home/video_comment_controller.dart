import 'dart:convert';

import 'package:get/get.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/model/video_comment.dart';
import 'package:qvid/widget/toast.dart';

class UserVideoComment extends GetxController {
  var commentList = [].obs;
  var userId = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  void getUserMatchPost(String videoId) async {
    print("userId ${userId}");
    dynamic response = await Apis().getVideoComment(videoId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        commentList.clear();
        commentList.value =
            re.map<VideoComment>((e) => VideoComment.fromJson(e)).toList();
        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i];
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        MyToast(message: msg).toast;
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  setUserId(String id) {
    userId.value = id;

    getUserMatchPost(userId.value);
  }
}
