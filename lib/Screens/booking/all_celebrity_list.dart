import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/celebrity_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';
import 'package:qvid/widget/wishing_list.dart';

class AllCelebrityList extends StatefulWidget {
  AllCelebrityList({Key? key}) : super(key: key);

  @override
  _AllCelebrityListState createState() => _AllCelebrityListState();
}

class _AllCelebrityListState extends State<AllCelebrityList> {
  List<CelebrityUser>? userList;
  bool isLoading = true;
  @override
  void initState() {
    loadCelebrityWishes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: buttonColor),
        title: Text(
          "All Celebrity",
          style: TextStyle(color: buttonColor),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
      ),
      body: isLoading == false
          ? userList != null
              ? StaggeredGridView.countBuilder(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 6,
                  primary: true,
                  itemCount: userList!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.userProfilePage,
                          arguments: userList![index].id);
                    },
                    child: WisheshList(
                            context1: context,
                            user: userList![index],
                            userId: "")
                        .list,
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                )
              : Center(
                  child: Lottie.asset(
                    "assets/animation/no-data.json",
                    width: 250,
                    height: 250,
                  ),
                )
          : SpinKitFadingCircle(color: buttonColor),
    );
  }

  Future<List<CelebrityUser>> loadCelebrityWishes() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getCelebrity(user.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      print(response.body);
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        setState(() {
          isLoading = false;
        });
        userList =
            re.map<CelebrityUser>((e) => CelebrityUser.fromJson(e)).toList();
        return re.map<CelebrityUser>((e) => CelebrityUser.fromJson(e)).toList();

        //return MySlider.fromJson(data['data'] as Map<String, dynamic>);
        /* for (int i = 0; i < sliders.length; i++) {
          MySlider slider = sliders[i]; 
          sliderImage[i] = slider.image;
        } */

      } else {
        print("error");
        setState(() {
          isLoading = false;
        });
        MyToast(message: msg).toast;
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
