import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/chat/chat_details.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/chat_user.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var newUserList = <User>[];
  bool isLoading = true;
  String tMainCategory = "",
      tGender = "",
      tCategory = "",
      tAge = "",
      tHairType = "",
      tSkinColor = "",
      tBodyType = "";
  bool passportStatus = false;
  bool drivingStatus = false;
  bool swimmingStatus = false;
  bool danceStatus = false;
  bool boldContent = false;
  bool printShootStatus = false;
  bool bodyPrintShootStatus = false;
  bool nudePrintShootStatus = false;
  bool bikiniPrintShootStatus = false;
  bool trainedActorStatus = false;
  bool unionCardStatus = false;
  bool experinceStatus = false;
  bool busyStatus = false;
  bool disablitilyStatus = false;
  bool workshopStatus = false;
  List<UserCategories> categoryNameList = [];
  RangeValues _currentAgeRange = const RangeValues(17, 25);
  List<String> cat = [];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      fetchNewUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Profile"),
        actions: [
          GestureDetector(
            onTap: () async {
              //openBottomSheet();
              dynamic result =
                  await Navigator.pushNamed(context, PageRoutes.filterPage);
              setState(() {
                if (result == null) {
                  isLoading = true;
                  Future.delayed(Duration(seconds: 1), () {
                    fetchNewUsers();
                  });
                } else {
                  newUserList = result as List<User>;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.filter_alt_rounded,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: isLoading == false
          ? newUserList.isNotEmpty
              ? ListView.builder(
                  itemCount: newUserList.length,
                  itemBuilder: (context, index) => Card(
                      color: cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageRoutes.userProfilePage,
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
                                            backgroundImage: AssetImage(
                                                'assets/user/user1.png'))
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          "${newUserList[index].userCategoryName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Visibility(
                                          visible:
                                              newUserList[index].mobileStatus ==
                                                      "true"
                                                  ? true
                                                  : false,
                                          child: SizedBox(
                                            height: 5,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              newUserList[index].mobileStatus ==
                                                      "true"
                                                  ? true
                                                  : false,
                                          child: Text(
                                            "${newUserList[index].mobile}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
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
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${newUserList[index].city}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Visibility(
                                    visible: newUserList[index].mobileStatus ==
                                            "true"
                                        ? true
                                        : false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          launch(
                                              'tel:${newUserList[index].mobile}');
                                        },
                                        child: Card(
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Container(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.call,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        ChatUser user = ChatUser(
                                            id: newUserList[index].id,
                                            name: newUserList[index].name,
                                            image: newUserList[index].image);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      receiver: user,
                                                    )));
                                      },
                                      child: Card(
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Container(
                                            padding: EdgeInsets.all(7),
                                            child: Image.asset(
                                              "assets/images/massege_icon.png",
                                              height: 20,
                                              width: 20,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )))
              : Center(
                  child: Lottie.asset(
                    "assets/animation/no-data.json",
                    width: 250,
                    height: 250,
                  ),
                )
          : SpinKitFadingCircle(
              color: color2,
            ),
    );
  }

  void fetchNewUsers() async {
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
          newUserList = [];
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        builder: (context1) => Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Filter Options",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: goldColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white),
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "User category",
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                              items: categoryList.map((String name) {
                                return new DropdownMenuItem<dynamic>(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16),
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);
                                //tMainCategory = val;
                                setState(() {
                                  //    defaultName = val;

                                  categoryNameList.clear();
                                  fetchCategoriesName(val);

                                  /*                               tGender = "";
                            //tCategory = "";
                            tSkinColor = "";
                            tBodyType = "";
                            tHairType = ""; */

                                  tMainCategory = val;
                                });
                              }),
                        ),
                      ),
                      Visibility(
                        //visible: tMainCategory.isEmpty ? false : true,
                        visible: true,
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Visibility(
                        //visible: tMainCategory.isEmpty ? false : true,
                        visible: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Gender",
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                              items: gender.map((String name) {
                                return new DropdownMenuItem<dynamic>(
                                  value: name,
                                  child: new Text(name,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);

                                setState(() {
                                  //    defaultName = val;
                                  tGender = val;

                                  categoryNameList.clear();
                                  fetchCategoriesName(
                                      tMainCategory + "," + tGender);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        //visible: tMainCategory.isNotEmpty ? true : false,
                        visible: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,hh
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Category",
                                contentPadding: EdgeInsets.all(5),
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                              items: categoryNameList
                                  .map((UserCategories category) {
                                return new DropdownMenuItem<dynamic>(
                                  value: category.name,
                                  child: new Text(category.name,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);
                                //tCategory = val;
                                setState(() {
                                  //    defaultName = val;
                                  tCategory = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        //visible: tCategory.isNotEmpty ? true : false,
                        visible: true,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(color: Colors.grey.shade300),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "Choose Age range",
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              RangeSlider(
                                values: _currentAgeRange,
                                min: 0,
                                max: 100,
                                activeColor: buttonColor,
                                labels: RangeLabels(
                                  _currentAgeRange.start.round().toString(),
                                  _currentAgeRange.end.round().toString(),
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    tAge =
                                        "${values.start.toInt()}-${values.end.toInt()}";
                                    print(tAge);
                                    _currentAgeRange = values;
                                    print(_currentAgeRange);
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Start: ${_currentAgeRange.start.round().toString()}",
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                        "Up To: ${_currentAgeRange.end.round().toString()}",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(color: Colors.grey.shade300),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        /* visible: tMainCategory.isNotEmpty && tAge.isNotEmpty
                        ? true
                        : false, */
                        visible: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Hair Type",
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: hair.map((String name) {
                                return new DropdownMenuItem<dynamic>(
                                  value: name,
                                  child: new Text(name,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);
                                tHairType = val;
                                setState(() {
                                  //    defaultName = val;
                                  tHairType = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        /* visible: tMainCategory.isNotEmpty && tHairType.isNotEmpty
                        ? true
                        : false, */
                        visible: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Skin Color",
                                hintStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none,
                              ),
                              items: skinColor.map((String name) {
                                return new DropdownMenuItem<dynamic>(
                                  value: name,
                                  child: new Text(name,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);
                                tSkinColor = val;
                                setState(() {
                                  //    defaultName = val;
                                  tSkinColor = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        /* visible: tMainCategory.isNotEmpty && tSkinColor.isNotEmpty
                        ? true
                        : false, */
                        visible: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              //value: tCountry,
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Body Type",
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: bodyType.map((String name) {
                                return new DropdownMenuItem<dynamic>(
                                  value: name,
                                  child: new Text(name,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                print(val);
                                tBodyType = val;
                                setState(() {
                                  //    defaultName = val;
                                  tBodyType = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Passport",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: passportStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  passportStatus = val;
                                });
                              },
                            ),
                            Text(
                              passportStatus == false ? "No" : "Yes",
                              style: TextStyle(color: buttonColor),
                            )
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Know Driving",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: drivingStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  drivingStatus = val;
                                });
                              },
                            ),
                            Text(drivingStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Know Swimming",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: swimmingStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  swimmingStatus = val;
                                });
                              },
                            ),
                            Text(drivingStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Dance",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: danceStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  danceStatus = val;
                                });
                              },
                            ),
                            Text(danceStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Bold Content",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: boldContent,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  boldContent = val;
                                });
                              },
                            ),
                            Text(boldContent == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Print Shoot",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: printShootStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  printShootStatus = val;
                                });
                              },
                            ),
                            Text(printShootStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Body Print Shoot",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: bodyPrintShootStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  bodyPrintShootStatus = val;
                                });
                              },
                            ),
                            Text(bodyPrintShootStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Nude Print Shoot",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: nudePrintShootStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  nudePrintShootStatus = val;
                                });
                              },
                            ),
                            Text(nudePrintShootStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 5.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Bikini Print Shoot",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: bikiniPrintShootStatus,
                                inactiveTrackColor: Colors.white,
                                activeColor: buttonColor,
                                onChanged: (val) {
                                  setState(() {
                                    bikiniPrintShootStatus = val;
                                  });
                                },
                              ),
                              Text(
                                bikiniPrintShootStatus == false ? "No" : "Yes",
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                          visible: true, child: Divider(color: Colors.white30)),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Trained Artist",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: trainedActorStatus,
                                  inactiveTrackColor: Colors.white,
                                  activeColor: buttonColor,
                                  onChanged: (val) {
                                    setState(() {
                                      trainedActorStatus = val;
                                    });
                                  },
                                ),
                                Text(trainedActorStatus == false ? "No" : "Yes",
                                    style: TextStyle(color: buttonColor))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Union Card",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: unionCardStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  unionCardStatus = val;
                                });
                              },
                            ),
                            Text(unionCardStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "User  Experince",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: experinceStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  experinceStatus = val;
                                });
                              },
                            ),
                            Text(experinceStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "User Disablity",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: disablitilyStatus,
                              inactiveTrackColor: Colors.white,
                              activeColor: buttonColor,
                              onChanged: (val) {
                                setState(() {
                                  disablitilyStatus = val;
                                });
                              },
                            ),
                            Text(disablitilyStatus == false ? "No" : "Yes",
                                style: TextStyle(color: buttonColor))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(color: Colors.white30),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 5.0, right: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Workshop",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: workshopStatus,
                                  inactiveTrackColor: Colors.white,
                                  activeColor: buttonColor,
                                  onChanged: (val) {
                                    setState(() {
                                      workshopStatus = val;
                                    });
                                  },
                                ),
                                Text(workshopStatus == false ? "No" : "Yes",
                                    style: TextStyle(color: buttonColor))
                              ])),
                      Container(
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Filter",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(5)))
                    ]),
              ),
            ));
  }

  Future<List<UserCategories>> loadCategies(String categoryName) async {
    setState(() {
      isLoading = true;
    });
    Response response = await Apis().getCategories(categoryName);
    var statusCode = response.statusCode;
    print(response.body);
    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var cat = data['data'] as List;
        setState(() {
          isLoading = false;
        });
        print("category size ${cat.length}");
        return cat
            .map<UserCategories>((e) => UserCategories.fromJson(e))
            .toList();
      } else {
        setState(() {
          isLoading = false;
        });
        return [];
      }
    } else {
      return [];
    }
  }

  void fetchCategoriesName(String categoryname) async {
    print(categoryname);
    List<UserCategories> lis = await loadCategies(categoryname);
    setState(() {
      print("d");
      categoryNameList = lis;
    });
  }

  String listToString(List<String> list) {
    String data = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        data = list[i];
      } else {
        data += "," + list[i];
      }
    }
    return data;
  }
}
