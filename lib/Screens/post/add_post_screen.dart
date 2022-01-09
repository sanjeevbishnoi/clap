import 'dart:convert';
import 'dart:io' as IO;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:qvid/widget/post_category.dart';
import 'package:qvid/widget/skin_color_list.dart';
import 'package:qvid/widget/toast.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _postStartDate = TextEditingController();
  final TextEditingController _postEndDate = TextEditingController();
  final TextEditingController _postTitle = TextEditingController();
  final TextEditingController _postDescription = TextEditingController();
  final TextEditingController _postLocation = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _nationality = TextEditingController();
  final TextEditingController _skills = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  String? tCountry;
  late String userId;
  IO.File? imageFile;
  List<UserCategories>? list;
  List<String>? catNameList;
  String selectedId = "", tAge = "";

  String? sidList;
  String _userCategory = categoryList[0];
  String _userCategoryGender = categorygender[0];
  List<String> cat = [];
  bool isExperience = false;
  bool isRequiredAudition = false;
  RangeValues _currentAgeRange = const RangeValues(17, 25);
  TextEditingController _category = TextEditingController();

  //all details

  String _gender = genderList[0];
  String _mediaReq = mediaRequirement[0];
  String title = "",
      description = "",
      startDate = "",
      endDate = "",
      location = "",
      categoryId = "",
      age = "",
      nationality = "",
      perSkills = "",
      language = "",
      weight = "",
      tSkinColor = "",
      tHairType = "",
      tHairColor = "",
      tEyeColor = "";
  String tHeight = "", tChestSize = "", tWaistSize = "";

  @override
  void initState() {
    //  loadCategies();
    findUser();
    //
    //loadHipSize();
    fetchCategoriesName();
    super.initState();
  }

  getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        imageFile = IO.File(image.path);
      } else {
        print("File not Selected");
      }
    });
  }

  Future<void> _selectDate(BuildContext context, int i) async {
    DateTime selectedDate = DateTime.now();
    print(selectedDate);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(10100, 1),
        lastDate: DateTime(3000, 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        DateFormat dateFormat = DateFormat("dd MMM yyyy");
        String date = dateFormat.format(selectedDate);
        if (i == 1) {
          _postStartDate.text = date;
        } else {
          _postEndDate.text = date;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: buttonColor),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Create Job",
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: backgroundColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 5, right: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Job Basic Info",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontFamily: 'Times',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                            controller: _postTitle,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              prefixIcon: Icon(
                                Icons.assignment,
                                color: buttonColor,
                              ),
                              hintText: "Job Title",
                              counterText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: disabledTextColor)),
                            )),
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
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                //color: Colors.red,
                                width: 100,

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
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => buttonColor),
                                          activeColor: buttonColor,
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
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => buttonColor),
                                          groupValue: _userCategory,
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
                                          'Musician',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        horizontalTitleGap: 5,
                                        leading: Radio<String>(
                                          value: categoryList[6],
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
                                print(sidList);
                                selectedId = idList;
                              });
                            } else {
                              setState(() {
                                _category.text = "";
                                sidList = "";
                                selectedId = "";
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
                                        borderSide:
                                            BorderSide(color: mainColor),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: false,
                          child: DropdownSearch<String>(
                              popupElevation: 8,
                              mode: Mode.MENU,
                              searchDelay: Duration(microseconds: 100),
                              items: catNameList,
                              onFind: (String? filter) =>
                                  getSearchCategory(filter!),
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(),
                              hint: "choose Job category",
                              dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                prefixIcon:
                                    Icon(Icons.category, color: buttonColor),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: disabledTextColor)),
                              ),
                              onChanged: (value) async {
                                setState(() {
                                  fetchCategoryId(value!)
                                      .then((id) => {selectedId = id});
                                });
                              },
                              selectedItem: "Choose Category"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            height: 150,
                            child: TextFormField(
                                controller: _postDescription,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                                maxLines: 100,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    counterText: "",
                                    hintText: "Job Description",
                                    alignLabelWithHint: true,
                                    labelText: "Job Description",
                                    border: null,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.0),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.0),
                                    ))),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                _selectDate(context, 1);
                              },
                              child: TextFormField(
                                  controller: _postStartDate,
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
                                    hintText: "Job Start Date",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)),
                                  )),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                _selectDate(context, 2);
                              },
                              child: TextFormField(
                                  controller: _postEndDate,
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
                                    hintText: "Post End Date",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: disabledTextColor)),
                                  )),
                            ),
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
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mainColor),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
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
                                  color: Colors.white,
                                ),
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  hintText: "Country",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
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

                                  setState(() {
                                    tCountry = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                              controller: _postLocation,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: buttonColor,
                                ),
                                hintText: "Job Location",
                                counterText: "",
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
                      ],
                    ),
                  ),
                ),
                Card(
                    elevation: 5,
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Project Requirement",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),

                              /* Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Media Requirement",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: buttonColor,
                                  ),
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
                                          'Headshot',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        horizontalTitleGap: 1,
                                        leading: Radio<String>(
                                          value: mediaRequirement[0],
                                          activeColor: buttonColor,
                                          groupValue: _mediaReq,
                                          onChanged: (value) {
                                            setState(() {
                                              _mediaReq = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 135,
                                      child: ListTile(
                                        title: const Text('Side Profile',
                                            style: TextStyle(
                                              fontSize: 10,
                                            )),
                                        horizontalTitleGap: 2,
                                        leading: Radio<String>(
                                          value: mediaRequirement[1],
                                          activeColor: buttonColor,
                                          groupValue: _mediaReq,
                                          onChanged: (value) {
                                            setState(() {
                                              _mediaReq = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: ListTile(
                                        title: const Text(
                                          'Intro Video',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        horizontalTitleGap: 5,
                                        leading: Radio<String>(
                                          value: mediaRequirement[2],
                                          groupValue: _mediaReq,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            setState(() {
                                              _mediaReq = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ), */
                              Visibility(
                                visible: true,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(color: Colors.grey.shade300),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
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
                                          _currentAgeRange.start
                                              .round()
                                              .toString(),
                                          _currentAgeRange.end
                                              .round()
                                              .toString(),
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
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Text(
                                                "Up To: ${_currentAgeRange.end.round().toString()}",
                                                style: TextStyle(
                                                    color: Colors.white))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*           Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                    controller: _age,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: buttonColor,
                                      ),
                                      hintText: "Age",
                                      counterText: "",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mainColor),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: disabledTextColor)),
                                    )),
                              ), */

                              Text(
                                "Language",
                                style: TextStyle(
                                  color: buttonColor,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 40),
                                child: LanguageList(lang, 1),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: buttonColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Experience",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: isExperience,
                                    inactiveTrackColor: Colors.white,
                                    activeColor: buttonColor,
                                    onChanged: (val) {
                                      print(val);
                                      setState(() {
                                        isExperience = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Divider(color: Colors.grey.shade400),
                              Visibility(
                                visible: _userCategory == "Artist" ||
                                        _userCategory == "Model"
                                    ? true
                                    : false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: buttonColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Requires Audition",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: isRequiredAudition,
                                      inactiveTrackColor: Colors.white,
                                      activeColor: buttonColor,
                                      onChanged: (val) {
                                        setState(() {
                                          isRequiredAudition = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]))),
                Visibility(
                  visible: _userCategory == "Artist" || _userCategory == "Model"
                      ? true
                      : false,
                  child: Card(
                      elevation: 5,
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Physical Attributes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                      controller: _weight,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        labelText: "Weight (kg)",
                                        labelStyle: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: disabledTextColor)),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          margin: EdgeInsets.all(3),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: DropdownButtonFormField<
                                                dynamic>(
                                              //underline: SizedBox(),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black,
                                              ),
                                              dropdownColor: Colors.white,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                hintText: "Height",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                border: InputBorder.none,
                                              ),
                                              items: height.map((String name) {
                                                return new DropdownMenuItem<
                                                    dynamic>(
                                                  value: name,
                                                  child: new Text(name,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
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
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          margin: EdgeInsets.all(3),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: DropdownButtonFormField<
                                                dynamic>(
                                              //underline: SizedBox(),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              ),

                                              dropdownColor: Colors.white,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                hintText: _userCategoryGender !=
                                                        "Transgender"
                                                    ? _gender == "Male"
                                                        ? "Chest Size (inch)"
                                                        : "Breast  Size (inch)"
                                                    : "Chest Size (inch)",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                border: InputBorder.none,
                                              ),
                                              items:
                                                  chestSize.map((String name) {
                                                return new DropdownMenuItem<
                                                    dynamic>(
                                                  value: name,
                                                  child: new Text(name,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
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
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          //margin: EdgeInsets.all(3),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: DropdownButtonFormField<
                                                dynamic>(
                                              //underline: SizedBox(),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              ),
                                              dropdownColor: Colors.white,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                hintText: "Waist Size (inch)",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                border: InputBorder.none,
                                              ),
                                              items:
                                                  waistSize.map((String name) {
                                                return new DropdownMenuItem<
                                                    dynamic>(
                                                  value: name,
                                                  child: new Text(name,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
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
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Skin Color ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: buttonColor,
                                    ),
                                  ),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Hair Type ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: buttonColor,
                                    ),
                                  ),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Hair  Color",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: buttonColor,
                                    ),
                                  ),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Eye  Color",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: buttonColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 40),
                                  child: EyeColorSelectChip(eyeColor),
                                ),
                              ]))),
                ),
                GestureDetector(
                  onTap: () {
                    if (valid()) {
                      showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(addPost(
                              userId,
                              selectedId,
                              title,
                              location,
//                              startDate,
                              description,
                              _gender,
                              //_mediaReq,
                              age,
                              nationality,
                              perSkills,
                              listToString(tLang),
                              isExperience == true ? "Yes" : "False",
                              isRequiredAudition == true ? "Yes" : "False",
                              weight,
                              tHeight,
                              _gender != "Transgender"
                                  ? _gender == "Male"
                                      ? tChestSize
                                      : ""
                                  : tChestSize,
                              _gender != "Transgender"
                                  ? _gender == "Male"
                                      ? ""
                                      : tChestSize
                                  : "",
                              tWaistSize,
                              tSkinColor,
                              tHairType,
                              tHairColor,
                              tEyeColor)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
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
                ),
              ],
            ),
          ),
        ));
  }

  Future<List<UserCategories>> loadCategies() async {
    Response response = await Apis().getUserCategories();
    var statusCode = response.statusCode;
    print(response.body);
    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var cat = data['data'] as List;
        print("category size ${cat.length}");
        return cat
            .map<UserCategories>((e) => UserCategories.fromJson(e))
            .toList();
      } else {
        throw Exception("somthing wrong");
      }
    } else {
      throw Exception("sdsds");
    }
  }

  void fetchCategoriesName() async {
    List<UserCategories> lis = await loadCategies();
    List<String> cList = [];
    for (int i = 0; i < lis.length; i++) {
      cList.add(lis[i].name);
    }
    setState(() {
      list = lis;
      catNameList = cList;
    });
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
    //MyToast(message: user.id).toast;
  }

  late List<String> tLang;
  bool valid() {
    title = _postTitle.text;
    description = _postDescription.text;
    /* startDate = _postStartDate.text;
    endDate = _postEndDate.text; */
    location = _postLocation.text;
    //categoryId = PostCategorySelectChip(list!).createState().getSelectedItem();
    //gender and mediaRequirement is defind
    //age = _age.text;
    age = tAge;
    // nationality = _nationality.text;
    //perSkills = _skills.text;
    // isExperience and requires Audition

    tLang = LanguageList(lang, 1).createState().getSelectedList();
    tSkinColor = SkinColorSelectChip(skinColor).createState().getSelectedItem();
    tHairType = HairTypeSelectChip(hair).createState().getSelectedItem();
    tHairColor = HairColorSelectChip(hairColor).createState().getSelectedItem();
    tEyeColor = EyeColorSelectChip(hair).createState().getSelectedItem();
    weight = _weight.text;

    if (title.isEmpty) {
      MyToast(message: "Please Enter Job Title").toast;
      return false;
    } else if (description.isEmpty) {
      MyToast(message: "Please Enter Job Description").toast;
      return false;
    } /* else if (startDate.isEmpty) {
      MyToast(message: "Please Choose Post start Date").toast;
      return false;
    } else if (endDate.isEmpty) {
      MyToast(message: "Please Choose Post end Date").toast;
      return false;
    }  */
    else if (location.isEmpty) {
      MyToast(message: "Please Enter Job Location").toast;
      return false;
    } /*  else if (selectedId.isEmpty) {
      MyToast(message: "Please Enter Job CategoryId").toast;
      return false;
    } */
    else if (age.isEmpty) {
      MyToast(message: "Please Enter Age").toast;
      return false;
    } else if (tLang.isEmpty) {
      MyToast(message: "Please Choose Language").toast;
      return false;
    }

    /* else if (weight.isEmpty) {
      MyToast(message: "Please Enter Weight").toast;
      return false;
    } else if (tHeight.isEmpty) {
      MyToast(message: "Please Enter Height").toast;
      return false;
    } /*  else if (tChestSize.isEmpty) {
      MyToast(
        message: _gender != "Transgender"
            ? _gender == "Male"
                ? "Please Choose Your Chest Size"
                : "Please Choose Your Beast Size"
            : "Please Choose Your Chest Size",
      ).toast;
      return false;
    } */
    else if (tWaistSize.isEmpty) {
      MyToast(message: "Please Waist Size").toast;
      return false;
    } else if (tSkinColor.isEmpty) {
      MyToast(message: "Please Choose Skin Color").toast;
      return false;
    } else if (tHairType.isEmpty) {
      MyToast(message: "Please Choose Hair Type").toast;
      return false;
    } else if (tHairColor.isEmpty) {
      MyToast(message: "Please Choose Hair Color").toast;
      return false;
    } else if (tEyeColor.isEmpty) {
      MyToast(message: "Please Choose Eye Color").toast;
      return false;
    } */
    else {
      return true;
    }
  }

  // add post

  Future addPost(
      String id,
      String categoryId,
      String title,
      String location,
      String description,
      String gender,
      //String mediaRequirement,
      String age,
      String nationality,
      String performingSkills,
      String lanuage,
      String experience,
      String requiresAudition,
      String weight,
      String height,
      String chestSize,
      String breastSize,
      String waistSize,
      String skinColor,
      String hairType,
      String hairColor,
      String eyeColor) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);
    //List<int> imageBytes = await _postImage.readAsBytes();
    //String image = base64Encode(imageBytes);
    print(categoryId);
    Response res = await Apis().addPost(
        id,
        categoryId,
        title,
        location,
        '',
        description,
        gender,
        //mediaRequirement,
        age,
        nationality,
        performingSkills,
        lanuage,
        experience,
        requiresAudition,
        weight,
        height,
        chestSize,
        breastSize,
        waistSize,
        skinColor,
        hairType,
        hairColor,
        eyeColor,
        _userCategory);
    var statusCode = res.statusCode;
    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        Future.delayed(Duration(microseconds: 100), () {
          Navigator.popAndPushNamed(context, PageRoutes.add_post);
        });
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  //get Id
  String? id;
  Future<String> fetchCategoryId(String name) async {
    List<UserCategories> lis = await loadCategies();
    List<String> cList = [];

    for (int i = 0; i < lis.length; i++) {
      if (lis[i].name == name) {
        id = lis[i].id;
      } else {}
    }
    return id!;
  }

  List<String>? filterList;
  Future<List<String>> getSearchCategory(String search) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<String> filterCategoryList = [];

    catNameList!.forEach((val) {
      if (val.toLowerCase().contains(search.toLowerCase()))
        filterCategoryList.add(val);
    });

    //    print(filterCategoryList.length);

    final suggestionList = search.isEmpty ? catNameList! : filterCategoryList;
    setState(() {
      filterList = filterCategoryList;
    });
    return suggestionList;
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
