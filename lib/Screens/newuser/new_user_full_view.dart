import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';

class NewUserFullView extends StatefulWidget {
  NewUserFullView({Key? key}) : super(key: key);

  @override
  _NewUserFullViewState createState() => _NewUserFullViewState();
}

class _NewUserFullViewState extends State<NewUserFullView> {
  bool isLoading = true;
  List<User> newUserList = [];
  @override
  void initState() {
    loadNewUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "All New Users",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: newUserList.length,
          itemBuilder: (context, index) => Card(
              color: cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.userProfilePage,
                      arguments: newUserList[index].id);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            newUserList[index].image.isEmpty
                                ? CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage:
                                        AssetImage('assets/user/user1.png'))
                                : CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                        Constraints.IMAGE_BASE_URL +
                                            newUserList[index].image),
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${newUserList[index].name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Times',
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${newUserList[index].type}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Visibility(
                                  visible:
                                      newUserList[index].mobileStatus == "true"
                                          ? true
                                          : false,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      newUserList[index].mobileStatus == "true"
                                          ? true
                                          : false,
                                  child: Text(
                                    "${newUserList[index].mobile}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${newUserList[index].gender} ,",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${newUserList[index].city}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  Future loadNewUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getNewUser(user.id);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            newUserList = re.map<User>((e) => User.fromMap(e)).toList();
            isLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
