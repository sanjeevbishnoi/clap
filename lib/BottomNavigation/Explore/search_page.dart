import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qvid/Screens/auth/basic_profile_details.dart';
import 'package:qvid/Screens/custom_appbar.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/utils/static_list.dart' as sta;
import 'package:qvid/widget/user_design.dart';
import 'package:qvid/widget/wishing_list.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String tMainCategory = "",
      tGender = "",
      tCategory = "",
      tAge = "",
      tLocation = "",
      tHeight = "",
      tSkinColor = "",
      tEyeColor = "",
      tBodySize = "";

  RangeValues _currentAgeRange = const RangeValues(17, 25);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* appBar: PreferredSize(
            preferredSize: Size.fromHeight(180),
            child: Container(
                padding: EdgeInsets.only(top: 40),
                child: MyCustomAppBar(context: context,user: ).myCustomAppBar)), */
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Choose Filter Option",
            style: TextStyle(
                color: buttonColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 160,
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButtonFormField<dynamic>(
                        //underline: SizedBox(),
                        //value: tCountry,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "User category",
                          border: InputBorder.none,
                        ),
                        items: sta.categoryList.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: Text(
                              name,
                              style: TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tMainCategory = val;
                          setState(() {
                            //    defaultName = val;
                            if (val == "Creative ,Technician & Vendors") {
                              tGender = "";
                              tCategory = "";
                              tLocation = "";
                              tHeight = "";
                              tSkinColor = "";
                              tEyeColor = "";
                              tBodySize = "";
                            }
                            tMainCategory = val;
                          });
                        }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: tMainCategory.isEmpty
                      ? false
                      : tMainCategory != "Creative ,Technician & Vendors"
                          ? true
                          : false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButtonFormField<dynamic>(
                        //underline: SizedBox(),
                        //value: tCountry,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Gender",
                          border: InputBorder.none,
                        ),
                        items: sta.gender.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tGender = val;
                          setState(() {
                            //    defaultName = val;
                            tGender = val;
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
                  visible: tGender.isNotEmpty &&
                          tMainCategory.isNotEmpty &&
                          tMainCategory != "Creative ,Technical & Vendors"
                      ? true
                      : false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Category",
                          border: InputBorder.none,
                        ),
                        items: sta.gender.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tCategory = val;
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
                  width: 10,
                ),
                Visibility(
                  visible: false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Location",
                          border: InputBorder.none,
                        ),
                        items: sta.gender.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tLocation = val;
                          setState(() {
                            //    defaultName = val;
                            tLocation = val;
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
                      tCategory.isNotEmpty && tGender.isNotEmpty ? true : false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Height",
                          border: InputBorder.none,
                        ),
                        items: sta.height.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tHeight = val;
                          setState(() {
                            //    defaultName = val;
                            tHeight = val;
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
                  visible: tHeight.isEmpty ? false : true,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Skin Color",
                          border: InputBorder.none,
                        ),
                        items: sta.skinColor.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
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
                  visible: tSkinColor.isNotEmpty ? true : false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Eye Color",
                          border: InputBorder.none,
                        ),
                        items: sta.eyeColor.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tEyeColor = val;
                          setState(() {
                            //    defaultName = val;
                            tEyeColor = val;
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
                  visible: tEyeColor.isNotEmpty ? true : false,
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Body Size",
                          border: InputBorder.none,
                        ),
                        items: sta.bodyType.map((String name) {
                          return new DropdownMenuItem<dynamic>(
                            value: name,
                            child: new Text(name,
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          tBodySize = val;
                          setState(() {
                            //    defaultName = val;
                            tBodySize = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: tCategory.isNotEmpty && tGender.isNotEmpty ? true : false,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Choose Age range",
                    style: TextStyle(
                        color: buttonColor, fontWeight: FontWeight.bold),
                  ),
                ),
                RangeSlider(
                  values: _currentAgeRange,
                  min: 0,
                  max: 100,
                  activeColor: buttonColor,
                  divisions: 2,
                  labels: RangeLabels(
                    _currentAgeRange.start.round().toString(),
                    _currentAgeRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentAgeRange = values;
                      print(_currentAgeRange);
                    });
                  },
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: tMainCategory.isNotEmpty ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                "You Can search your celebrity here..",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Visibility(
          visible: tMainCategory.isNotEmpty ? true : false,
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      primary: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) =>
                          UserDesign(context: context).list,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
