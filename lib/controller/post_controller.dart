import 'dart:convert';

import 'package:get/get.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_post.dart';
import 'package:qvid/widget/toast.dart';

class PostController extends GetxController {
  List<UserPost> postList = <UserPost>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  void setPostLoading(bool val) {
    isLoading.value = val;
  }

  void fetchProduct() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    dynamic response = await Apis().getMyPost(user.id);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        isLoading.value = false;

        postList = re.map<UserPost>((e) => UserPost.fromJson(e)).toList();
      } else {
        print("error");
        isLoading.value = false;

        MyToast(message: msg).toast;
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> deletePost(int index) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    dynamic resp = await Apis().deleteJob(postList[index].id!);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);
      if (res == "success") {
        MyToast(message: msg).toast;

        fetchProduct();
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }
}
