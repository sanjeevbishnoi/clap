import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:qvid/BottomNavigation/MyProfile/my_profile_page.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_achievment.dart';
import 'package:qvid/model/user_experience.dart';
import 'package:qvid/model/user_resume.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/multiple_chip.dart';
import 'package:qvid/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPersonalInfo extends StatefulWidget {
  final Map data;
  ShowPersonalInfo({required this.data});
  @override
  State<ShowPersonalInfo> createState() => _ShowPersonalInfoState();
}

class _ShowPersonalInfoState extends State<ShowPersonalInfo> {
  User? userDetails;
  UserResume? userResume;
  String? fileName;
  @override
  void initState() {
    st = widget.data["i"];
    uId = widget.data['id'];
    Future.delayed(Duration(seconds: 1), () {
      getUser();
      getUserExperience();
      getUserAchievment();
      getUserResume();
    });
    super.initState();
  }

  TextEditingController _dob = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _heightSize = TextEditingController();
  TextEditingController _chestSize = TextEditingController();
  TextEditingController _waistSize = TextEditingController();
  TextEditingController _hipSize = TextEditingController();

  TextEditingController _projectNane = TextEditingController();
  TextEditingController _role = TextEditingController();
  TextEditingController _directoryCompanyName = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _date = TextEditingController();

  TextEditingController _achievmentNane = TextEditingController();
  TextEditingController _movieName = TextEditingController();
  TextEditingController _achievmentDate = TextEditingController();

  TextEditingController _youtube = TextEditingController();
  TextEditingController _instagram = TextEditingController();
  TextEditingController _facebook = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _linkedin = TextEditingController();
  TextEditingController _industry = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool iSelect = false;
  bool isExperienceLoading = true;
  bool isAchievmentLoading = true;
  int i = -1;
  int j = -1;
  int h = -1;
  int l = -1;
  bool isLoading = true;
  bool expericeCard = false;
  bool acheivementCard = false;
  List<Object> list1 = [];
  List<UserExperience> experienceList = [];
  List<Object> list2 = [];
  List<UserAchievment> achievmentList = [];
  String _chooseDate = "";
  int st = 0;

  bool facebookEnabled = true;
  bool instagramEnabled = true;
  bool youtubeEnabled = true;
  bool twitterEnabled = true;
  bool linkedinEnabled = true;
  bool resumeSelected = false;
  File? pdfFile;
  String resumeId = "";

  var uId = "";
  void openCupterTinoDatePicker(int i) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            child: Container(
                height: 330,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 30,
                            ),
                          )),
                    ),
                    Container(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (val) {
                            setState(() {
                              print("${val.day}/${val.month}/${val.year}");
                              DateFormat dateFormat = DateFormat("dd MMM yyyy");
                              String date = dateFormat.format(val);
                              _chooseDate = date;
                              print(date);
                              //_chosenDateTime = val;
                            });
                          }),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.center,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_chooseDate.isEmpty) {
                                MyToast(message: "Please Choose date").toast;
                                return;
                              } else {
                                Navigator.pop(context);
                                i == 1
                                    ? _date.text
                                    : _achievmentDate.text = _chooseDate;

                                //getAge(selectedDate);

                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.center,
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    /* var data = ModalRoute.of(context)!.settings.arguments as Map;
    if (data != null) {
      st = data["i"];
      uId = data['id'];
    } */

    return Scaffold(
      appBar: /*  st == 1
          ? AppBar(
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: buttonColor),
              iconTheme: IconThemeData(color: buttonColor),
              title: Text(
                "Celebrity Details",
                style: TextStyle(color: buttonColor),
              ),
            )
          :  */
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: SafeArea(
        top: true,
        child: isLoading == true
            ? SpinKitFadingCircle(
                color: buttonColor,
              )
            : Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    /*  Text(
                "Your Persional Details",
                style: TextStyle(fontSize: 20),
              ), */
                    Visibility(
                      visible: st == 2
                          ? true
                          : experienceList.isEmpty
                              ? false
                              : true,
                      child: Card(
                          color: cardColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          expericeCard = false;
                                          list1.remove("1");
                                        });
                                      },
                                      child: Visibility(
                                        visible:
                                            expericeCard == true ? true : false,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )),
                                Text(
                                  "Experience",
                                  style: TextStyle(
                                      fontFamily: 'Times',
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expericeCard = true;

                                      list1.insert(0, '1');
                                    });
                                  },
                                  child: Visibility(
                                    visible: st == 2
                                        ? expericeCard == true
                                            ? false
                                            : true
                                        : false,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Icon(
                                          Icons.add,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Add Your Experience Here",
                                          style: TextStyle(
                                              color: buttonColor, fontSize: 16),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                isExperienceLoading == false
                                    ? ListView.builder(
                                        itemCount: list1.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          UserExperience? experience;
                                          if (list1[index] is UserExperience) {
                                            experience =
                                                list1[index] as UserExperience;
                                          }

                                          return list1[index] is UserExperience
                                              ? Card(
                                                  color: Colors.black,
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Column(children: [
                                                        Visibility(
                                                          visible: st == 2
                                                              ? true
                                                              : false,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  /* print("hi");
                                                                  setState(() {
                                                                    list1.insert(
                                                                        index,
                                                                        "1");
                                                                    expericeCard =
                                                                        true;
                                                                  }); */
                                                                  showUpdateDialog(
                                                                      experience,
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (context) =>
                                                                          FutureProgressDialog(
                                                                              deleteExperience(experience!.id!)));
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Project Name :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                  "${experience!.projectName!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Role :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            //SizedBox(width: 40),
                                                            Expanded(
                                                              child: Text(
                                                                  "${experience.role!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Directo/Company :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                  "${experience.dirCoName!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Location :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            //SizedBox(width: 40),
                                                            Expanded(
                                                              child: Text(
                                                                  "${experience.location!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                  "Date :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            //SizedBox(width: 40),
                                                            Expanded(
                                                              child: Text(
                                                                  "${experience.date!}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          ],
                                                        )
                                                      ])),
                                                )
                                              : Visibility(
                                                  visible: expericeCard == true
                                                      ? true
                                                      : false,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller:
                                                              _projectNane,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Project name",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller: _role,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Role",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller:
                                                              _directoryCompanyName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Director or Company name",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller: _location,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Location",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            openCupterTinoDatePicker(
                                                                1);
                                                          },
                                                          child: TextFormField(
                                                              controller: _date,
                                                              enabled: false,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                counterText: "",
                                                                suffixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .date_range,
                                                                  color:
                                                                      buttonColor,
                                                                ),
                                                                hintText:
                                                                    "DD/MM/YYYY",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                mainColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                disabledTextColor)),
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  list1.remove(
                                                                      "1");
                                                                  expericeCard =
                                                                      false;
                                                                });
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        //color: buttonColor,
                                                                        //color: buttonColor,
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (context) =>
                                                                        FutureProgressDialog(
                                                                            addExperience()));
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Save",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        //color: buttonColor,
                                                                        color:
                                                                            buttonColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                        })
                                    : Center(
                                        child: SpinKitFadingCircle(
                                        color: Colors.yellow,
                                      ))
                              ]))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: st == 2
                          ? true
                          : achievmentList.isEmpty
                              ? false
                              : true,
                      child: Card(
                          color: cardColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                Text(
                                  "Achievments",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Times'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      list2.insert(0, '1');
                                      acheivementCard = true;
                                    });
                                  },
                                  child: Visibility(
                                    visible: st == 2
                                        ? acheivementCard == true
                                            ? false
                                            : true
                                        : false,
                                    child: Column(children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Icon(
                                        Icons.add,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Add Your Achievments Here",
                                        style: TextStyle(
                                            color: buttonColor, fontSize: 16),
                                      ),
                                      SizedBox(height: 20),
                                    ]),
                                  ),
                                ),
                                isAchievmentLoading == false
                                    ? ListView.builder(
                                        itemCount: list2.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          UserAchievment? userAchievment;
                                          if (list2[index] is UserAchievment) {
                                            userAchievment =
                                                list2[index] as UserAchievment;
                                          }
                                          return list2[index] is UserAchievment
                                              ? Card(
                                                  color: Colors.black,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    child: Column(children: [
                                                      Visibility(
                                                        visible: st == 2
                                                            ? true
                                                            : false,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                achievmentUpdateDialog(
                                                                    userAchievment!);
                                                              },
                                                              child: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(width: 5),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (context) =>
                                                                        FutureProgressDialog(
                                                                            deleteAchievment(userAchievment!.id!)));
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                "Achievment Name :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${userAchievment!.achvName!}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                "Movie Name :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${userAchievment.movieName!}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                "Achievment Date :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${userAchievment.date!}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                    ]),
                                                  ),
                                                )
                                              : Visibility(
                                                  visible:
                                                      acheivementCard == false
                                                          ? false
                                                          : true,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller:
                                                              _achievmentNane,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Achievement name",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextFormField(
                                                          controller:
                                                              _movieName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),

                                                          //maxLength: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            counterText: "",
                                                            hintText:
                                                                "Enter Movie Name",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            border:
                                                                OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            mainColor),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            disabledTextColor)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            openCupterTinoDatePicker(
                                                                2);
                                                          },
                                                          child: TextFormField(
                                                              controller:
                                                                  _achievmentDate,
                                                              enabled: false,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                counterText: "",
                                                                suffixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .date_range,
                                                                  color:
                                                                      buttonColor,
                                                                ),
                                                                hintText:
                                                                    "DD/MM/YYYY",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                mainColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                disabledTextColor)),
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  list2.remove(
                                                                      "1");
                                                                  acheivementCard =
                                                                      false;
                                                                });
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        //color: buttonColor,
                                                                        //color: buttonColor,
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (context) =>
                                                                        FutureProgressDialog(
                                                                            addAchievment()));
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Save",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        //color: buttonColor,
                                                                        color:
                                                                            buttonColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                        })
                                    : Container(),
                              ]))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: st == 2
                          ? true
                          : facebookEnabled == false
                              ? false
                              : true,
                      child: Card(
                          color: cardColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                Text(
                                  "Socia Media",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Times'),
                                ),
                                SizedBox(height: 5),
                                Card(
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 2,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "facebook.com/",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              facebookEnabled = true;
                                            });
                                          },
                                          child: TextField(
                                              controller: _facebook,
                                              enabled: facebookEnabled,
                                              decoration: InputDecoration(
                                                  suffixIcon: Visibility(
                                                    visible: st == 2
                                                        ? facebookEnabled ==
                                                                true
                                                            ? false
                                                            : true
                                                        : false,
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white),
                                                  ),
                                                  hintText:
                                                      "Enter your facedbook id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                  border: InputBorder.none)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Card(
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "instagram.com/",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              instagramEnabled = true;
                                            });
                                          },
                                          child: TextField(
                                              controller: _instagram,
                                              enabled: instagramEnabled,
                                              decoration: InputDecoration(
                                                  suffixIcon: Visibility(
                                                    visible: st == 2
                                                        ? instagramEnabled ==
                                                                true
                                                            ? false
                                                            : true
                                                        : false,
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white),
                                                  ),
                                                  hintText:
                                                      "Enter instagram  id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                  border: InputBorder.none)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Card(
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.youtube,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "youtube.com/",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              youtubeEnabled = true;
                                            });
                                          },
                                          child: TextField(
                                              controller: _youtube,
                                              enabled: youtubeEnabled,
                                              decoration: InputDecoration(
                                                  suffixIcon: Visibility(
                                                    visible: st == 2
                                                        ? youtubeEnabled == true
                                                            ? false
                                                            : true
                                                        : false,
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white),
                                                  ),
                                                  hintText: "Enter youtube id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                  border: InputBorder.none)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Card(
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.twitter,
                                        color: Colors.blue.shade600,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "twitter.com/",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              twitterEnabled = true;
                                            });
                                          },
                                          child: TextField(
                                              controller: _twitter,
                                              enabled: twitterEnabled,
                                              decoration: InputDecoration(
                                                  suffixIcon: Visibility(
                                                    visible: st == 2
                                                        ? twitterEnabled == true
                                                            ? false
                                                            : true
                                                        : false,
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white),
                                                  ),
                                                  hintText:
                                                      "Enter your twitter id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                  border: InputBorder.none)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Card(
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.linkedinIn,
                                        color: Colors.lightBlue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "linkedin.com/",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              linkedinEnabled = true;
                                            });
                                          },
                                          child: TextField(
                                              enabled: linkedinEnabled,
                                              controller: _linkedin,
                                              decoration: InputDecoration(
                                                  suffixIcon: Visibility(
                                                    visible: st == 2
                                                        ? linkedinEnabled ==
                                                                true
                                                            ? false
                                                            : true
                                                        : false,
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white),
                                                  ),
                                                  hintText:
                                                      "Enter your linkedin id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54),
                                                  border: InputBorder.none)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(
                                                updateSocialMedia(
                                                    _youtube.text,
                                                    _instagram.text,
                                                    _facebook.text,
                                                    _twitter.text,
                                                    _linkedin.text)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        //color: buttonColor,
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ]))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: cardColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Form(
                            child: Column(
                          children: [
                            Text(
                              "Persional Details",
                              style:
                                  TextStyle(color: buttonColor, fontSize: 18),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  enabled: false,
                                  controller: _name,
                                  readOnly: true,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: buttonColor,
                                      ),
                                      labelText: "Your name",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: userDetails != null
                                  ? userDetails!.mobileStatus == "true"
                                      ? true
                                      : false
                                  : false,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    enabled: false,
                                    controller: _mobile,
                                    readOnly: true,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(1),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: buttonColor,
                                        ),
                                        counterText: "",
                                        labelText: "Mobile no",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade300),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white))
                                        /*  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.white)), */
                                        )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: st == 1 ? false : true,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    enabled: false,
                                    controller: _email,
                                    readOnly: true,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: buttonColor,
                                        ),
                                        counterText: "",
                                        labelText: "Email Id",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade300),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white))
                                        /*  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.white)), */
                                        )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  controller: _dob,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      prefixIcon: Icon(
                                        Icons.date_range_rounded,
                                        color: buttonColor,
                                      ),
                                      labelText: "Date of Birth",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      counterText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))
                                      /*  focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                   borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.white)), */
                                      )),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  controller: _industry,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      labelText: "Industry Name",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      counterText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)))),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Visibility(
                      visible: userDetails!.type == "Artist" ||
                              userDetails!.type == "Modal"
                          ? true
                          : false,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Visibility(
                      visible: userDetails!.type == "Artist" ||
                              userDetails!.type == "Modal"
                          ? true
                          : false,
                      child: Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Basic Details",
                                  style: TextStyle(
                                      color: buttonColor, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your language",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.langauge}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Hair Style",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.hairStyle}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Hair Color",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.hairColor}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Skin Color",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.skinColor}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Eye Color",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.eyecolor}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Gender",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${userDetails!.gender}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: Divider(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price For 30 to 60 sec video",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "₹ 90000",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: userDetails!.type == "Artist" ||
                              userDetails!.type == "Modal"
                          ? true
                          : false,
                      child: Card(
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Physical  Details",
                                        style: TextStyle(
                                            color: buttonColor, fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormField(
                                          enabled: false,
                                          controller: _heightSize,
                                          readOnly: true,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              counterText: "",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: buttonColor,
                                              ),
                                              labelText: "Your Height",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white)))),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: userDetails!.type == "Artist" ||
                                              userDetails!.type == "Modal"
                                          ? true
                                          : false,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextFormField(
                                            enabled: false,
                                            controller: _hipSize,
                                            readOnly: true,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                                counterText: "",
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                prefixIcon: Icon(
                                                  Icons.person,
                                                  color: buttonColor,
                                                ),
                                                labelText: "Your HipSize",
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            disabledTextColor)))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormField(
                                          enabled: false,
                                          controller: _waistSize,
                                          readOnly: true,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              counterText: "",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: buttonColor,
                                              ),
                                              labelText: "Your Waist Size",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white)))),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormField(
                                          enabled: false,
                                          controller: _chestSize,
                                          readOnly: true,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              counterText: "",
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: buttonColor,
                                              ),
                                              labelText:
                                                  userDetails!.gender != "Other"
                                                      ? userDetails!.gender ==
                                                              "Male"
                                                          ? "Your Chest Size"
                                                          : "Your Breast Size"
                                                      : "Your Chest Size",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white)))),
                                    ),
                                  ]))),
                    ),
                    Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "More Info",
                                      style: TextStyle(
                                          color: buttonColor, fontSize: 18),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userDetails!.type == "Artist" ||
                                            userDetails!.type == "Model"
                                        ? true
                                        : false,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Passport:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.passport,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Driving:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.driving,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Swimming:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.swimming,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("dance:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.dance,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Bold Content:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.boldContent,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Print Shoot:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.printShoot,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Body Print Shoot:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.bodyPrintShoot,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Nude Print Shoot:",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.nudePrintShoot,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Bikini Print Shoot :",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(
                                                  userDetails!.bikiniPrintShoot,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Trained Actor :",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(userDetails!.trainedActor,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              userDetails!.trainedActor == "Yes"
                                                  ? true
                                                  : false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 10, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Institute Name :",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Text(userDetails!.instituteName,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Union card:",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(userDetails!.unionCard,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Experience:",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(userDetails!.experince,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: userDetails!.experince == "No"
                                        ? false
                                        : true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Experience Year:",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text("${userDetails!.experienceYear}",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userDetails!.experince == "No"
                                        ? false
                                        : true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Experience Area:",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text("${userDetails!.experienceArea}",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  )
                                ]))),
                    Visibility(
                      visible: st == 2
                          ? true
                          : fileName == null
                              ? false
                              : true,
                      child: Card(
                          color: cardColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: fileName == null || i == 1
                                  ? Visibility(
                                      visible: st == 2 ? true : false,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  deleteResume(resumeId);
                                                },
                                                child: Visibility(
                                                  visible: fileName != null
                                                      ? true
                                                      : false,
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: fileName != null
                                                  ? false
                                                  : true,
                                              child: Text(
                                                "No Resume Uploaded",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Text(
                                              "Kindly upload a resume in PDF Format",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectFile();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,
                                                      color: Colors.white,
                                                      size: 60),
                                                  Visibility(
                                                    visible:
                                                        resumeSelected == true
                                                            ? true
                                                            : false,
                                                    child: Text("File Selected",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (pdfFile == null) {
                                                  MyToast(
                                                          message:
                                                              "Please Select file")
                                                      .toast;
                                                  return;
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          FutureProgressDialog(
                                                              uploadResume(
                                                                  pdfFile!)));
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                width: 100,
                                                child: Text(
                                                  "Upload",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                decoration: BoxDecoration(
                                                    //color: buttonColor,
                                                    color: buttonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ]),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    i = 1;
                                                    st = 2;
                                                  });
                                                },
                                                child: Visibility(
                                                  visible:
                                                      st == 2 ? true : false,
                                                  child: Icon(Icons.edit,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                        FaIcon(FontAwesomeIcons.filePdf,
                                            color: Colors.yellow, size: 40),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            var url =
                                                Constraints.PDF_URL + fileName!;

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {}
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            width: 100,
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                //color: buttonColor,
                                                color: buttonColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ],
                                    ))),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void setData() {
    if (userDetails != null) {
      final User user = userDetails!;
      _name.text = "${user.name}";
      _mobile.text = "${user.mobile}";
      _email.text = "${user.email}";
      _dob.text = "${user.dob}";
      _heightSize.text = "${user.height}";
      getAge(user.dob);
      _chestSize.text = userDetails!.gender != "Other"
          ? userDetails!.gender == "Male"
              ? "${user.chestSize} inch"
              : "${user.breastSize} inch"
          : "${user.chestSize} inch";
      _industry.text = "${user.filmIndustry}";
      _hipSize.text = "${user.hipSize} inch";
      _waistSize.text = "${user.waistSize} inch";
      _facebook.text = "${user.facebookLink}";
      _instagram.text = "${user.instagramLink}";
      _youtube.text = "${user.youtubeLink}";
      _twitter.text = "${user.twitterLink}";
      _linkedin.text = "${user.telegramLink}";
      st == 2
          ? setState(() {
              facebookEnabled = user.facebookLink.isEmpty ? true : false;
              instagramEnabled = user.instagramLink.isEmpty ? true : false;
              youtubeEnabled = user.youtubeLink.isEmpty ? true : false;
              twitterEnabled = user.twitterLink.isEmpty ? true : false;
              linkedinEnabled = user.telegramLink.isEmpty ? true : false;
            })
          : setState(() {
              facebookEnabled = false;
              instagramEnabled = false;
              youtubeEnabled = false;
              twitterEnabled = false;
              linkedinEnabled = false;
            });
    } else {
      _name.text = "Atul";
      _mobile.text = "3434434343";
      _email.text = "atulmaurya7@gmail.com";
      _dob.text = "1 feb 2021";
    }
  }

  Future getUser() async {
    Future.delayed(Duration(seconds: 1), () async {
      User user = st != 1
          ? await ApiHandle.fetchUser()
          : await ApiHandle.getUserById(uId);
      if (mounted) {
        setState(() {
          userDetails = user;

          setData();
          isLoading = false;
        });
      }
    });
  }

  void getAge(String dob) {
    /*  String datePattern = "dd-MMM-yyyy";

    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    if (yearDiff < 1) {
      MyToast(message: "You are not eligible").toast;
      _dob.text = "";
      //uage = "";
    } else {
      //uage = "${yearDiff}";

    }
    print("age is ${yearDiff}"); */
  }

  Future deleteExperience(String s) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteExperienceId(user.id, s);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          Future.delayed(Duration(seconds: 1), () {
            getUserExperience();
          });
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future deleteAchievment(String s) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteAchievment(user.id, s);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          Future.delayed(Duration(seconds: 1), () {
            getUserAchievment();
          });
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future addExperience([String s = ""]) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().addExperices(user.id, s, _projectNane.text,
        _role.text, _directoryCompanyName.text, _location.text, _date.text);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          expericeCard = false;
          if (s.isNotEmpty) {
            Navigator.pop(context);
          }
          Future.delayed(Duration(seconds: 1), () {
            getUserExperience();
          });
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  Future addAchievment([String s = ""]) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().addAchievement(user.id, s,
        _achievmentNane.text, _movieName.text, _achievmentDate.text);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          acheivementCard = false;
          if (s.isNotEmpty) {
            Navigator.pop(context);
          }
          Future.delayed(Duration(seconds: 1), () {
            getUserAchievment();
          });
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  void getUserExperience() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getExperience(st == 2 ? user.id : uId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            experienceList = re
                .map<UserExperience>((e) => UserExperience.fromJson(e))
                .toList();
            list1 = List.from(experienceList);
            print("length of list1 ${list1.length}");
            isExperienceLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isExperienceLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void getUserAchievment() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getAchievments(st == 2 ? user.id : uId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);

        if (mounted)
          setState(() {
            achievmentList = re
                .map<UserAchievment>((e) => UserAchievment.fromJson(e))
                .toList();
            list2 = List.from(achievmentList);
            print("length of list1 ${list2.length}");
            isAchievmentLoading = false;
          });
      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isAchievmentLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future updateSocialMedia(String youtube, String instagramId,
      String facebookid, String twitterId, String telegramId) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().updateSocialDetails(
        user.id, youtube, instagramId, facebookid, twitterId, telegramId);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          facebookEnabled = false;
          instagramEnabled = false;
          youtubeEnabled = false;
          twitterEnabled = false;
          linkedinEnabled = false;
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        resumeSelected = true;
        pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future uploadResume(File uploadFile) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().uploadResume(user.id, uploadFile);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        setState(() {
          i = 2;
        });
        MyToast(message: msg).toast;
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  void getUserResume() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getResume(st == 2 ? user.id : uId);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re.length);
        if (mounted)
          setState(() {
            // dynamic userResume = re[0];
            //userResume = UserResume();
            fileName = re[0]['filename'];
            resumeId = re[0]['id'];
          });
      } else {
        print("error");
        MyToast(message: msg).toast;
        setState(() {
          isAchievmentLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void showUpdateDialog(UserExperience? experience, BuildContext context1) {
    _projectNane.text = experience!.projectName!;
    _role.text = experience.role!;
    _directoryCompanyName.text = experience.dirCoName!;
    _location.text = experience.location!;
    _date.text = experience.date!;

    showDialog(
      context: context1,
      builder: (context1) => Scaffold(
        appBar: AppBar(
          title: Text("Update Here", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _projectNane,
                    style: TextStyle(color: Colors.white),

                    //maxLength: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      counterText: "",
                      hintText: "Enter Project name",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: disabledTextColor)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _role,
                    style: TextStyle(color: Colors.white),

                    //maxLength: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      counterText: "",
                      hintText: "Enter Role",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: disabledTextColor)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _directoryCompanyName,
                    style: TextStyle(color: Colors.white),

                    //maxLength: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      counterText: "",
                      hintText: "Enter Director or Company name",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: disabledTextColor)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _location,
                    style: TextStyle(color: Colors.white),

                    //maxLength: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      counterText: "",
                      hintText: "Enter Location",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: disabledTextColor)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      openCupterTinoDatePicker(1);
                    },
                    child: TextFormField(
                        controller: _date,
                        enabled: false,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          counterText: "",
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: buttonColor,
                          ),
                          hintText: "DD/MM/YYYY",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(5)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: disabledTextColor)),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                            addExperience(experience.id!)));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        //color: buttonColor,
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  achievmentUpdateDialog(UserAchievment userAchievment) {
    _achievmentNane.text = userAchievment.achvName!;
    _movieName.text = userAchievment.movieName!;
    _achievmentDate.text = userAchievment.date!;

    showDialog(
        context: context,
        builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text("Update Here", style: TextStyle(color: Colors.white)),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Container(
                child: SingleChildScrollView(
                    child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: _achievmentNane,
                  style: TextStyle(color: Colors.white),
                  //maxLength: 10
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    counterText: "",
                    hintText: "Enter Achievement name",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: _movieName,
                  style: TextStyle(color: Colors.white),

                  //maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    counterText: "",
                    hintText: "Enter Movie Name",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: disabledTextColor)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    openCupterTinoDatePicker(2);
                  },
                  child: TextFormField(
                      controller: _achievmentDate,
                      enabled: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        counterText: "",
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: buttonColor,
                        ),
                        hintText: "DD/MM/YYYY",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor),
                            borderRadius: BorderRadius.circular(5)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: disabledTextColor)),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                          addAchievment(userAchievment.id!)));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      //color: buttonColor,
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ])))));
  }

  void deleteResume(String resumeId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(fontSize: 15, color: Colors.black),
            content: Text("Are You Sure want to Delete your resume"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(deleteUserResume(resumeId)));
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  Future deleteUserResume(String resumeId) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response resp = await Apis().deleteData(resumeId, "tbl_resume ");
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      print(response);

      if (res == "success") {
        MyToast(message: msg).toast;
        setState(() {
          i = 2;
        });
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyProfilePage()));
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {
      print('sdds');
    }
  }
}
