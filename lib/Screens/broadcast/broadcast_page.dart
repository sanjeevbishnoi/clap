import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/utils/static_list.dart' as sta;
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/toast.dart';

class BroadcastPage extends StatefulWidget {
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  String tMainCategory = "",
      tGender = "",
      tCategory = "",
      tAge = "",
      tHairType = "",
      tSkinColor = "",
      tBodyType = "",
      tFileType = "";

  String sendType = "All";
  String tBroadcastType = "Description";
  bool isLoading = false;
  String tCountry = "", tState = "", tCity = "";
  String defaultName = "India";
  List<UserCategories> categoryNameList = [];
  final TextEditingController _description = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  bool isSelectedFile = false;
  File? selectedFile;
  RangeValues _currentAgeRange = const RangeValues(17, 25);
  List<String> chooseType = ["Description", "Attach File"];
  List<String> cat = [];

  @override
  Widget build(BuildContext context) {
    var userId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
          leading: GestureDetector(
              onTap: () {
                // Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back, color: buttonColor))),
          title: Text(
            "Create Broadcast",
            style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          items: sta.categoryList.map((String name) {
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
                    visible: tMainCategory.isEmpty ? false : true,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Visibility(
                    visible: tMainCategory.isEmpty ? false : true,
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
                          items: sta.gender.map((String name) {
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
                    visible: tMainCategory.isNotEmpty ? true : false,
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
                          items:
                              categoryNameList.map((UserCategories category) {
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
                    visible:
                        tMainCategory == "Artist" || tMainCategory == "Model"
                            ? true
                            : false,
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
                    visible: tMainCategory.isNotEmpty && tAge.isNotEmpty
                        ? true
                        : false,
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
                          items: sta.hair.map((String name) {
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
                    visible: tMainCategory.isNotEmpty && tHairType.isNotEmpty
                        ? true
                        : false,
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
                          items: sta.skinColor.map((String name) {
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
                    visible:
                        tMainCategory != "Creative ,Technician & Vendors" &&
                                tSkinColor.isNotEmpty
                            ? true
                            : false,
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
                          items: sta.bodyType.map((String name) {
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
                              borderSide: BorderSide(color: disabledTextColor)),
                        )),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                        controller: _state,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          hintText: "State",
                          counterText: "",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: disabledTextColor)),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: backgroundColor,
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
                          style: TextStyle(color: Colors.white),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Country",
                            hintStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none,
                          ),
                          items: ["India"].map((String name) {
                            return new DropdownMenuItem<dynamic>(
                              value: defaultName,
                              child: new Text(defaultName,
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
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: tMainCategory.isNotEmpty ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Choose Type of Broadcast",
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tMainCategory.isNotEmpty ? true : false,
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            width: 100,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: const Text(
                                'Favourite',
                                style: TextStyle(fontSize: 12),
                              ),
                              horizontalTitleGap: 1,
                              leading: Radio<String>(
                                value: "Favourite",
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => buttonColor),
                                activeColor: buttonColor,
                                groupValue: sendType,
                                onChanged: (value) {
                                  setState(() {
                                    sendType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 115,
                            child: ListTile(
                              title: const Text('All',
                                  style: TextStyle(
                                    fontSize: 10,
                                  )),
                              horizontalTitleGap: 1,
                              leading: Radio<String>(
                                value: "All",
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => buttonColor),
                                activeColor: buttonColor,
                                groupValue: sendType,
                                onChanged: (value) {
                                  setState(() {
                                    sendType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 10, bottom: 10),
                    child: Text("What Type of info you Broadcast",
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold)),
                  ),
                  Visibility(
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
                          value: tBroadcastType,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Choose Broadcast Type",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          items: chooseType.map((String name) {
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
                            tBroadcastType = val;
                            setState(() {
                              //    defaultName = val;
                              tBroadcastType = val;
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
                    visible: tBroadcastType == "Attach File" ? true : false,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: cardColor,
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
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
                            hintText: "Choose File Type",
                            contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none,
                          ),
                          items: ["Pdf", "Doc", "Audio", "Video"]
                              .map((String name) {
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
                              tFileType = val;
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
                    visible: tBroadcastType == "Description" ? false : true,
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isSelectedFile == false
                                ? "Choose File"
                                : "File Selected",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                              onTap: () {
                                loadFile();
                              },
                              child: Icon(Icons.upload,
                                  size: 30, color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tBroadcastType == "Description" ? true : false,
                    child: Container(
                      height: 100,
                      child: TextFormField(
                          controller: _description,
                          maxLines: 100,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Write Description",
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (valide()) {
                        showDialog(
                            context: context,
                            builder: (context) => FutureProgressDialog(
                                broadCast(
                                    userId,
                                    tMainCategory,
                                    tGender,
                                    tCategory,
                                    tAge,
                                    tCountry,
                                    _state.text,
                                    _city.text,
                                    sendType,
                                    _description.text,
                                    isSelectedFile == true
                                        ? selectedFile
                                        : null)));
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Send",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ],
              ),
            ),
          ),
          isLoading == true
              ? Align(
                  alignment: Alignment.center,
                  child: SpinKitFadingCircle(color: buttonColor))
              : Container()
        ]));
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

  Future<void> loadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: tFileType == "Video" ? FileType.video : FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        selectedFile = file;
        isSelectedFile = true;
      });
    } else {
      // User canceled the picker
    }
  }

  Future broadCast(
      String userId,
      String mainCategory,
      String gender,
      String category,
      String age,
      String country,
      String state,
      String city,
      String typeOfBroadcast,
      String description,
      File? attachedFile) async {
    Response res = await Apis().sendBroadcast(
        userId,
        mainCategory,
        gender,
        category,
        age,
        country,
        state,
        city,
        typeOfBroadcast,
        description,
        selectedFile);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(microseconds: 100), () {
          Navigator.popAndPushNamed(context, PageRoutes.broadcastPage);
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  bool valide() {
    if (tMainCategory.isEmpty) {
      MyToast(message: "Please Choose MainCategory").toast;
      return false;
    } /* else if (tGender.isEmpty) {
      MyToast(message: "Please Choose Gender").toast;
      return false;
    }  */
    else if (tCategory.isEmpty) {
      MyToast(message: "Please Choose Category").toast;
      return false;
    } /* else if (tCountry.isEmpty) {
      MyToast(message: "Please Choose Country").toast;
      return false;
    } else if (_state.text.isEmpty) {
      MyToast(message: "Please Choose State").toast;
      return false;
    } else if (tMainCategory != "Technician & Vendors") {
      if (tAge.isEmpty) {
        MyToast(message: "Please Choose Age Range").toast;
        return false;
      } else if (tHairType.isEmpty) {
        MyToast(message: "Please Choose Hair Type").toast;
        return false;
      } else if (tSkinColor.isEmpty) {
        MyToast(message: "Please Choose Skin Color").toast;
        return false;
      } else if (tBodyType.isEmpty) {
        MyToast(message: "Please Choose Body Type").toast;
        return false;
      }
      return true;
    }  */
    else if (sendType.isEmpty) {
      MyToast(message: "Please Choose sendType").toast;
      return false;
    }

    /* else if (typeOfBroadcast != "Description") {
        if (selectedFile == null) {
          MyToast(message: "Please select File").toast;
          return false;
        }
        return true;
      } */ /* else if (typeOfBroadcast == "Description") {
        if (_description.text.isEmpty) {
          MyToast(message: "Please Write some description ").toast;
          return false;
        }
        return true;
      } */
    else {
      return true;
    }
  }
}
