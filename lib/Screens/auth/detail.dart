import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/eye_color_list.dart';
import 'package:qvid/widget/hair_color_list.dart';
import 'package:qvid/widget/hair_type_list.dart';
import 'package:qvid/widget/muliple_language_list.dart';
import 'package:qvid/widget/skin_color_list.dart';
import 'package:qvid/widget/toast.dart';

class UserPersonalInfo extends StatefulWidget {
  @override
  State<UserPersonalInfo> createState() => _UserPersonalInfoState();
}

class _UserPersonalInfoState extends State<UserPersonalInfo> {
  List<UserCategories>? list;
  String? sidList;
  List<String>? tLang;
  String tname = "",
      tEmailid = "",
      tDob = "",
      tSkincolor = "",
      tHairtype = "",
      tHhaircolor = "",
      tGender = "",
      tWeight = "",
      tChestSize = "",
      tWaistSize = "",
      tHipSize = "",
      tEyeColor = "",
      tExperienceYear = "",
      tState = "",
      tCity = "";

  String? userId;

  String tHeight = "";

  String industry = "";
  String? tCountry, tBodyType, tMaeritial;
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

  @override
  void initState() {
    super.initState();
    findUser();
    // loadHipSize();
  }

  TextEditingController _dob = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _experience_area = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _experienceYear = TextEditingController();
  TextEditingController _instituteName = TextEditingController();

  String dropdownValue = 'One';

  DateTime selectedDate = DateTime.now();
  bool iSelect = false;

  //Gender _userCategoryGender = Gender.Male;
  // String _userCategoryGender = genderList[0];
  String _userCategory = categoryList[0];
  String _userCategoryGender = categorygender[0];
  List<String> cat = [];
  String defaultName = "India";
  String uage = "";
  int i = -1;
  int j = -1;
  int h = -1;
  int l = -1;
  int m = -1;
  int n = -1;
  String _chooseDate = "";
  getAge(DateTime dateString) {
    String datePattern = "dd-MM-yyyy";

    DateTime birthDate = dateString;
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    if (yearDiff < 1) {
      MyToast(message: "You are not eligible").toast;
      _dob.text = "";
      uage = "";
    } else {
      uage = "${yearDiff}";
    }
    print(yearDiff);
  }

  void openCupterTinoDatePicker() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            child: Container(
                height: 350,
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
                                _dob.text = _chooseDate;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1100, 1),
        lastDate: DateTime(2501));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        DateFormat dateFormat = DateFormat("dd MMM yyyy");
        String date = dateFormat.format(selectedDate);
        _dob.text = date;
        getAge(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: cardColor,

      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              //  Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: buttonColor)),
        title: Text(
          "Fill Your Personal Details",
          style: TextStyle(
              color: buttonColor,
              fontFamily: 'Times',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _name,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              prefixIcon: Icon(
                                Icons.person,
                                color: buttonColor,
                              ),
                              hintText: "Name",
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _email,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              prefixIcon: Icon(
                                Icons.email,
                                color: buttonColor,
                              ),
                              hintText: "Email id",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            // _selectDate(context);
                            openCupterTinoDatePicker();
                          },
                          child: TextFormField(
                              controller: _dob,
                              enabled: false,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  color: buttonColor,
                                ),
                                counterText: "",
                                suffixIcon: Icon(
                                  Icons.date_range,
                                  color: buttonColor,
                                ),
                                hintText: "Dob",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                    borderRadius: BorderRadius.circular(5)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: disabledTextColor)),
                              )),
                        ),
                      ),
                      Visibility(
                        visible: uage.isEmpty ? false : true,
                        child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 15),
                            child: Text("Age is: ${uage}year",
                                style: TextStyle(color: buttonColor))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        //visible: _userCategory == "Model" ? true : false,
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Choose your Gender",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Visibility(
                        //visible: _userCategory == "Model" ? true : false,
                        visible: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    width: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Male',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categorygender[0],
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        activeColor: buttonColor,
                                        groupValue: _userCategoryGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 115,
                                    child: ListTile(
                                      title: const Text('Female',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categorygender[1],
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        groupValue: _userCategoryGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: ListTile(
                                      title: const Text('Transgenders',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categorygender[2],
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        groupValue: _userCategoryGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 230,
                              child: ListTile(
                                title: const Text('Vendor or Company',
                                    style: TextStyle(
                                      fontSize: 10,
                                    )),
                                horizontalTitleGap: 1,
                                contentPadding: EdgeInsets.all(0),
                                leading: Radio<String>(
                                  value: categorygender[3],
                                  activeColor: buttonColor,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => buttonColor),
                                  groupValue: _userCategoryGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _userCategoryGender = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Choose your Category",
                          style: TextStyle(
                              color: buttonColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Artist',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categoryList[0],
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        groupValue: _userCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text('Model',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categoryList[1],
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        groupValue: _userCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Director',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categoryList[2],
                                        groupValue: _userCategory,
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Creative Director',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categoryList[3],
                                        groupValue: _userCategory,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        activeColor: buttonColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Creative Head',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: categoryList[4],
                                        groupValue: _userCategory,
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Musician',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: categoryList[6],
                                        groupValue: _userCategory,
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Writer',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: categoryList[5],
                                        groupValue: _userCategory,
                                        activeColor: buttonColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Technician & Vendors',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: categoryList[7],
                                        groupValue: _userCategory,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        activeColor: buttonColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Producer & Production House',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: categoryList[8],
                                        groupValue: _userCategory,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        activeColor: buttonColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategory = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          cat.clear();
                          cat.add(_userCategory);

                          cat.add(_userCategoryGender);

                          setState(() {
                            _userCategory == cat;
                          });
                          String list = listToString(cat);
                          print(list);

                          final result = await Navigator.pushNamed(
                              context, PageRoutes.avaliable_categories,
                              arguments: list) as Map;
                          if (result != null) {
                            String idList = result['idlist'];
                            String categoryName = result['categoryName'];
                            print(result);
                            setState(() {
                              _category.text = categoryName;
                              sidList = idList;
                            });
                          } else {
                            setState(() {
                              _category.text = "";
                              sidList = "";
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                              controller: _category,
                              enabled: false,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Icon(
                                    Icons.category,
                                    color: buttonColor,
                                  ),
                                  counterText: "",
                                  hintText: "Select Interested area/talent",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: disabledTextColor)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: disabledTextColor)))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _address,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Address",
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _city,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "City",
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                            controller: _pincode,
                            maxLength: 6,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Pin Code",
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  controller: _state,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: "State",
                                    counterText: "",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade500),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)),
                                  )),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          margin: EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
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
                                hintText: "Country",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: countries.map((String name) {
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
                                tCountry = val;
                                setState(() {
                                  defaultName = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          margin: EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
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
                                hintText: "Choose Industry",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5),
                              ),
                              items: industries.map((String name) {
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
                                industry = val;
                                setState(() {
                                  //    defaultName = val;
                                  industry = val;
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
                        visible: _userCategory == "Artist" ||
                                _userCategory == "Model"
                            ? true
                            : false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  //controller: _email,
                                  controller: _weight,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    /* prefixIcon: Icon(
                                  Icons.person,
                                  color: buttonColor,
                                ), */

                                    labelText: "Weight (kg)",
                                    labelStyle:
                                        TextStyle(color: Colors.white38),
                                    hintStyle: TextStyle(color: Colors.white38),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)),
                                  )),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                margin: EdgeInsets.all(3),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: DropdownButtonFormField<dynamic>(
                                    //underline: SizedBox(),
                                    //value: tCountry,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    decoration: InputDecoration(
                                      hintText: "Body type",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
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
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                margin: EdgeInsets.all(3),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: DropdownButtonFormField<dynamic>(
                                    //underline: SizedBox(),
                                    //value: tCountry,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    decoration: InputDecoration(
                                      hintText: "Marital Status",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                    items: maritialStatus.map((String name) {
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
                                      tMaeritial = val;
                                      setState(() {
                                        //defaultName = val;
                                        tMaeritial = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            /*  Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Choose your Gender",
                                style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    width: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Male',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: genderList[0],
                                        activeColor: buttonColor,
                                        groupValue: _userCategoryGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 115,
                                    child: ListTile(
                                      title: const Text('Female',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: genderList[1],
                                        activeColor: buttonColor,
                                        groupValue: _userCategoryGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: ListTile(
                                      title: const Text(
                                        'Transgender',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        value: genderList[2],
                                        groupValue: _userCategoryGender,
                                        activeColor: buttonColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _userCategoryGender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ), */
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: DropdownButtonFormField<dynamic>(
                                          //underline: SizedBox(),
                                          //        value: tHeight,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: "Height",
                                            contentPadding: EdgeInsets.all(5),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white54),
                                            border: InputBorder.none,
                                          ),
                                          items: height.map((String name) {
                                            return new DropdownMenuItem<
                                                dynamic>(
                                              value: name,
                                              child: new Text(name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16)),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            print(val);
                                            tHeight = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: DropdownButtonFormField<dynamic>(
                                          //underline: SizedBox(),
                                          //value: tChestSize,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),

                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            hintText: _userCategoryGender !=
                                                    "Transgender"
                                                ? _userCategoryGender == "Male"
                                                    ? "Chest Size (inch)"
                                                    : "Breast  Size (inch)"
                                                : "Chest Size (inch)",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white54),
                                            border: InputBorder.none,
                                          ),
                                          items: chestSize.map((String name) {
                                            return new DropdownMenuItem<
                                                dynamic>(
                                              value: name,
                                              child: new Text(name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16)),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            print(val);
                                            tChestSize = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: DropdownButtonFormField<dynamic>(
                                          //underline: SizedBox(),
                                          //value: tHipSize,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            hintText: "Hip Size (inch)",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white54),
                                            border: InputBorder.none,
                                          ),
                                          items: hiPSize.map((String name) {
                                            return new DropdownMenuItem<
                                                dynamic>(
                                              value: name,
                                              child: new Text(name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16)),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            print(val);
                                            tHipSize = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      //margin: EdgeInsets.all(3),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: DropdownButtonFormField<dynamic>(
                                          //underline: SizedBox(),
                                          //value: tWaistSize,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: "Waist Size (inch)",
                                            contentPadding: EdgeInsets.all(5),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white54),
                                            border: InputBorder.none,
                                          ),
                                          items: waistSize.map((String name) {
                                            return new DropdownMenuItem<
                                                dynamic>(
                                              value: name,
                                              child: new Text(name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16)),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            print(val);
                                            tWaistSize = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose your language",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: LanguageList(lang, 1),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose your Skin Color ",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: SkinColorSelectChip(skinColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose your Hair Type ",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: HairTypeSelectChip(hair),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose your Hair  Color",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: HairColorSelectChip(hairColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose your Eye  Color",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: EyeColorSelectChip(eyeColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 5.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Do You Have Passport",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Do You Know Driving",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Do You Know Swimming",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Do You Know Dance",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                      bodyPrintShootStatus == false
                                          ? "No"
                                          : "Yes",
                                      style: TextStyle(color: buttonColor))
                                ],
                              ),
                            ),
                            Divider(color: Colors.white30),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                      nudePrintShootStatus == false
                                          ? "No"
                                          : "Yes",
                                      style: TextStyle(color: buttonColor))
                                ],
                              ),
                            ),
                            Divider(color: Colors.white30),
                            Visibility(
                              visible: _userCategoryGender == "Female"
                                  ? true
                                  : false,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, left: 5.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      bikiniPrintShootStatus == false
                                          ? "No"
                                          : "Yes",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                                visible: _userCategoryGender == "Female"
                                    ? true
                                    : false,
                                child: Divider()),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Are You Trained Artist",
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
                                      Text(
                                          trainedActorStatus == false
                                              ? "No"
                                              : "Yes",
                                          style: TextStyle(color: buttonColor))
                                    ],
                                  ),
                                  Visibility(
                                    visible: trainedActorStatus == true
                                        ? true
                                        : false,
                                    child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextFormField(
                                            controller: _instituteName,
                                            style:
                                                TextStyle(color: Colors.white),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              hintText: "Institute Name",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade500),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: mainColor),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          disabledTextColor)),
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.white30),

                            /*                       Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Are You busy ?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: busyStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        busyStatus = val;
                                      });
                                    },
                                  ),
                                  Text(
                                    busyStatus == false ? "No" : "Yes",
                                  )
                                ],
                              ),
                            ), */

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Any Disablity",
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
                                  Text(
                                      disablitilyStatus == false ? "No" : "Yes",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Are you interested in Workshop",
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Divider(color: Colors.white30),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5.0, left: 5.0, right: 10.0),
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
                                "Do You have Union Card",
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
                  Divider(
                    color: Colors.grey.shade600,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5.0, left: 5.0, right: 10.0),
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
                                "Do You have Experince",
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
                  Visibility(
                    visible: experinceStatus == true ? true : false,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade700)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Experice Info",
                                style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                                controller: _experienceYear,
                                maxLength: 2,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Experience Year",
                                  counterText: "",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: disabledTextColor)),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                                controller: _experience_area,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  hintText: "Experience Area",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: disabledTextColor)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (valid()) {
                        showDialog(
                            context: context,
                            builder: (context) => FutureProgressDialog(
                                updatePersionalDetails(
                                    userId!,
                                    tname,
                                    tEmailid,
                                    tGender,
                                    tDob,
                                    listToString(tLang!),
                                    tSkincolor,
                                    tHairtype,
                                    tHhaircolor,
                                    sidList!,
                                    tCountry!,
                                    tState,
                                    tCity,
                                    tWeight,
                                    tHeight,
                                    tChestSize,
                                    tWaistSize,
                                    tHipSize,
                                    tEyeColor,
                                    passportStatus == true ? "Yes" : "No",
                                    drivingStatus == true ? "Yes" : "No",
                                    swimmingStatus == true ? "Yes" : "No",
                                    danceStatus == true ? "Yes" : "No",
                                    boldContent == true ? "Yes" : "No",
                                    printShootStatus == true ? "Yes" : "No",
                                    bodyPrintShootStatus == true ? "Yes" : "No",
                                    nudePrintShootStatus == true ? "Yes" : "No",
                                    bikiniPrintShootStatus == true
                                        ? "Yes"
                                        : "No",
                                    trainedActorStatus == true ? "Yes" : "No",
                                    unionCardStatus == true ? "Yes" : "No",
                                    experinceStatus == true ? "Yes" : "No",
                                    _experienceYear.text,
                                    _experience_area.text,
                                    _instituteName.text
                                    //busyStatus == true ? "Yes" : "No")
                                    )));
                      }
                      //Navigator.pushNamed(context, PageRoutes.personal_info);
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
  }

  Future updatePersionalDetails(
      String id,
      String name,
      String email,
      String gender,
      String dob,
      String language,
      String skinColor,
      String hairStyle,
      String hairColor,
      String expertise,
      String country,
      String ustate,
      String city,
      String weight,
      String height,
      String chest,
      String waist,
      String hip,
      String eye,
      String passportStatus,
      String drivingStatus,
      String swimmingStatus,
      String danceStatus,
      String boldContentStatus,
      String printShootStatus,
      String bodyPrintShootStatus,
      String nudePrintShootStatus,
      String bikiniPrintShootStatus,
      String treainedActorStatus,
      String unionCardStatus,
      String experienceStatus,
      String expericenceYear,
      String expericenceArea,
      String instituteName
      //String busyStatus
      ) async {
    Response res = await Apis().updatePersionalDetails(
        id,
        name,
        email,
        gender,
        dob,
        language,
        skinColor,
        hairStyle,
        hairColor,
        expertise,
        country,
        ustate,
        city,
        weight,
        height,
        _userCategoryGender != "Transgender"
            ? _userCategoryGender == "Male"
                ? chest
                : ""
            : chest,
        _userCategoryGender != "Transgender"
            ? _userCategoryGender == "Male"
                ? ""
                : chest
            : "",
        waist,
        hip,
        eye,
        passportStatus,
        drivingStatus,
        swimmingStatus,
        danceStatus,
        boldContentStatus,
        printShootStatus,
        bodyPrintShootStatus,
        nudePrintShootStatus,
        bikiniPrintShootStatus,
        treainedActorStatus,
        unionCardStatus,
        experienceStatus,
        expericenceYear,
        expericenceArea,
        //busyStatus,
        disablitilyStatus == true ? "Yes" : "No",
        tBodyType == null ? "" : tBodyType!,
        tMaeritial == null ? "" : tMaeritial!,
        _userCategory,
        workshopStatus == true ? "Yes" : "No",
        instituteName,
        _address.text,
        _pincode.text,
        industry);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        Future.delayed(Duration(microseconds: 1), () {
          Navigator.pushNamed(context, PageRoutes.basic_profile_info);
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  //validation
  bool valid() {
    tname = _name.text;
    tEmailid = _email.text;
    tDob = _dob.text;
    tLang = LanguageList(lang, 1).createState().getSelectedList();
    tSkincolor = SkinColorSelectChip(skinColor).createState().getSelectedItem();
    tHairtype = HairTypeSelectChip(hair).createState().getSelectedItem();
    tHhaircolor =
        HairColorSelectChip(hairColor).createState().getSelectedItem();
    //tGender = GenderSelectChip(gender).createState().getSelectedItem();
    tGender = _userCategoryGender;
    tState = _state.text;
    tCity = _city.text;
    tEyeColor = EyeColorSelectChip(hair).createState().getSelectedItem();
    print(_userCategory);
    tWeight = _weight.text;
    print(tHairtype);
    if (tname.isEmpty) {
      MyToast(message: "Please Enter your name").toast;
      return false;
    } else if (tEmailid.isEmpty) {
      MyToast(message: "Please Enter your Email Id").toast;
      return false;
    } else if (tDob.isEmpty) {
      MyToast(message: "Please Enter your Dob").toast;
      return false;
    } /*  else if (tWeight.isEmpty) {
      MyToast(message: "Please Enter Your  Weight").toast;
      return false;
    } */
    else if (tCountry == null || tCountry!.isEmpty) {
      MyToast(message: "Please Choose Country").toast;
      return false;
    } else if (tState.isEmpty) {
      MyToast(message: "Please Choose State").toast;
      return false;
    } else if (tCity.isEmpty) {
      MyToast(message: "Plese Choose Your City").toast;
      return false;
    } else if (industry.isEmpty) {
      MyToast(message: "Plese Choose Your industry").toast;
      return false;
    } else if (_userCategory == "Artist" || _userCategory == "Model") {
      if (tLang!.isEmpty) {
        MyToast(message: "Please Choose Your Language").toast;
        return false;
      } else if (tHeight.isEmpty) {
        MyToast(message: "Please Choose Your Height").toast;
        return false;
      } else if (tChestSize.isEmpty) {
        MyToast(
          message: _userCategoryGender != "Transgender"
              ? _userCategoryGender == "Male"
                  ? "Please Choose Your Chest Size"
                  : "Please Choose Your Beast Size"
              : "Please Choose Your Chest Size",
        ).toast;
        return false;
      } else if (tWaistSize.isEmpty) {
        MyToast(message: "Please Choose Your Waist Size");
        return false;
      } else if (tHipSize.isEmpty) {
        MyToast(message: "Please Choose Your Hip Size");
        return false;
      } else if (tSkincolor.isEmpty) {
        MyToast(message: "Please Choose Your Skin Color").toast;
        return false;
      } else if (tHairtype.isEmpty) {
        MyToast(message: "Please Choose Your Hair Type").toast;
        return false;
      } else if (tHhaircolor.isEmpty) {
        MyToast(message: "Please Choose Your Hair Color").toast;
        return false;
      } else if (tEyeColor.isEmpty) {
        MyToast(message: "Please Choose Your Eye Color").toast;
        return false;
      } else if (tGender.isEmpty) {
        MyToast(message: "Please Choose Your Gender").toast;
        return false;
      }
      return true;
    } else if (_category.text.isEmpty) {
      MyToast(message: "Please Select Your Expertise").toast;
      return false;
    } else {
      return true;
    }
  }

  void loadHipSize() {
    for (int i = 30; i < 61; i++) {
      hiPSize.add(i.toString());
    }
    for (int i = 16; i < 65; i++) {
      chestSize.add(i.toString());
      waistSize.add(i.toString());
    }
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
