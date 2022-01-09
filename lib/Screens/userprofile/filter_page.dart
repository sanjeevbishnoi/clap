import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/toast.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var filterUserList = <User>[];
  bool isLoading = true;

  String tMainCategory = "",
      tGender = "",
      tCategory = "",
      tAge = "",
      tHairType = "",
      tSkinColor = "",
      tBodyType = "";
  String selectedCategoryId = "";
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
  final TextEditingController _city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
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
                      overflow: TextOverflow.ellipsis, color: Colors.white),
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
                              color: Colors.grey.shade500, fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    print(val);

                    setState(() {
                      //    defaultName = val;
                      tGender = val;

                      categoryNameList.clear();
                      fetchCategoriesName(tMainCategory + "," + tGender);
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
                  items: categoryNameList.map((UserCategories category) {
                    return new DropdownMenuItem<dynamic>(
                      value: category,
                      child: new Text(category.name,
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    //tCategory = val;
                    setState(() {
                      //    defaultName = val;
                      tCategory = val.name;
                      selectedCategoryId = val.id;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _city,
            style: TextStyle(color: Colors.white),
            //maxLength: 10,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              counterText: "",
              hintText: "City Name",
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
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: tMainCategory == "Artist" || tMainCategory == "Model"
                ? true
                : false,
            child: Column(
              children: [
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    color: Colors.grey.shade500, fontSize: 16)),
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
                                    color: Colors.grey.shade500, fontSize: 16)),
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
                                    color: Colors.grey.shade500, fontSize: 16)),
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
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 5.0, right: 10.0),
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
                        Text(bikiniPrintShootStatus == false ? "No" : "Yes",
                            style: TextStyle(color: buttonColor))
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: true, child: Divider(color: Colors.white30)),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 5.0, right: 10.0),
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
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => FutureProgressDialog(filterUser()));
            },
            child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Filter",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(5))),
          )
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

  Future filterUser() async {
    /* var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>); */
    Response response = await Apis().filterUser(
        tMainCategory,
        tGender,
        selectedCategoryId,
        tHairType,
        tSkinColor,
        tBodyType,
        tAge,
        passportStatus == false ? "" : "Yes",
        drivingStatus == false ? "" : "Yes",
        swimmingStatus == false ? "" : "Yes",
        danceStatus == false ? "" : "Yes",
        boldContent == false ? "" : "Yes",
        printShootStatus == false ? "" : "Yes",
        bodyPrintShootStatus == false ? "" : "Yes",
        nudePrintShootStatus == false ? "" : "Yes",
        bikiniPrintShootStatus == false ? "" : "Yes",
        trainedActorStatus == false ? "" : "Yes",
        unionCardStatus == false ? "" : "Yes",
        experinceStatus == false ? "" : "Yes",
        disablitilyStatus == true ? "Yes" : "",
        workshopStatus == true ? "Yes" : "",
        _city.text);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re);
        print(re.length);
        if (mounted)
          setState(() {
            filterUserList = re.map<User>((e) => User.fromMap(e)).toList();
            print(filterUserList);
            //isSearching = false;
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context, filterUserList);
            });
            isLoading = false;

            FocusManager.instance.primaryFocus!.unfocus();
          });
        return re.map<User>((e) => User.fromMap(e)).toList();
      } else {
        MyToast(message: msg).toast;
        var re = data['data'] as List;
        setState(() {
          print("hi");
          filterUserList = [];
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context, filterUserList);
          });
          //isSearching = false;
          isLoading = false;
        });
        return re.map<User>((e) => User.fromMap(e)).toList();
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
