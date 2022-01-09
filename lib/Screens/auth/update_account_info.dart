import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/static_list.dart';
import 'package:qvid/widget/eye_color_list.dart';
import 'package:qvid/widget/hair_color_list.dart';
import 'package:qvid/widget/hair_type_list.dart';
import 'package:qvid/widget/muliple_language_list.dart';
import 'package:qvid/widget/skin_color_list.dart';
import 'package:qvid/widget/toast.dart';

class UpdateAccountInfo extends StatefulWidget {
  @override
  State<UpdateAccountInfo> createState() => _UpdateAccountInfoState();
}

class _UpdateAccountInfoState extends State<UpdateAccountInfo>
    with WidgetsBindingObserver {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  bool bikiniPrintShootStatus = false;
  bool bodyPrintShootStatus = false;
  bool boldContent = false;
  bool busyStatus = false;
  List<String> cat = [];
  bool danceStatus = false;
  String defaultName = "India";
  bool disablitilyStatus = false;
  bool drivingStatus = false;
  String dropdownValue = 'One';
  bool experinceStatus = false;
  int h = -1;
  String industry = "";
  //String? _userCategoryGender = genderList[0];

  int i = -1;

  bool iSelect = false;
  bool isLoading = true;
  int j = -1;
  int l = -1;
  bool nudePrintShootStatus = false;
  bool passportStatus = false;
  bool printShootStatus = false;
  DateTime selectedDate = DateTime.now();
  String? sidList;
  bool swimmingStatus = false;
  String tChestSize = "";
  String tCountry = "", tState = "", tCity = "";
  String tHeight = "", tWaistSize = "", tHipSize = "", tExperienceYear = "";
  List<String>? tLang;
  String? tBodyType, tMaeritial;
  bool trainedActorStatus = false;
  bool unionCardStatus = false;
  User? userDetails;
  String _chooseDate = "";
  late String tname,
      tEmailid,
      tDob,
      tSkincolor,
      tHairtype,
      tHhaircolor,
      tEyeColor,
      userId;

  bool workshopStatus = false;

  TextEditingController _address = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _experience_area = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _experienceYear = TextEditingController();
  String _userCategory = categoryList[0];
  String _userCategoryGender = categorygender[0];
  TextEditingController _weight = TextEditingController();
  TextEditingController _institute = TextEditingController();

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    getUser();

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1100, 8),
        lastDate: DateTime(3000, 2));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        DateFormat dateFormat = DateFormat("dd MMM yyyy");
        String date = dateFormat.format(selectedDate);
        _dob.text = date;
      });
  }

  void setData() {
    _name.text = "${userDetails!.name}";
//    _mobile.text = "${userDetails!.mobile}";
    _email.text = "${userDetails!.email}";
    _dob.text = "${userDetails!.dob}";
    tHeight = userDetails!.height;
    tState = userDetails!.state;
    tCountry = userDetails!.country;
    tCity = userDetails!.city;
    tBodyType = userDetails!.bodyType;
    tMaeritial = userDetails!.maritialStatus;
    _weight.text = userDetails!.weight;
    _userCategoryGender = userDetails!.gender;
    tWaistSize = userDetails!.waistSize;
    tHipSize = userDetails!.hipSize;
    _institute.text = userDetails!.instituteName;
    _experienceYear.text = userDetails!.experienceYear;
    print(userDetails!.filmIndustry!);
    industry = userDetails!.filmIndustry!;
    _userCategory = userDetails!.type;
    _category.text = userDetails!.userCategoryName;
    tChestSize = userDetails!.gender != "Transgender"
        ? userDetails!.gender == "Male"
            ? userDetails!.chestSize
            : userDetails!.breastSize
        : userDetails!.chestSize;
    print("Chestsize" + tChestSize);
    _state.text = userDetails!.state;
    _city.text = userDetails!.city;
    String lan = userDetails!.langauge;
    var da = lan.split(",");
    print(da);
    LanguageList(lang, 1).createState().setSelected(da);
    _address.text = userDetails!.address;
    _pincode.text = userDetails!.pincode;

    //set status
    passportStatus = userDetails!.passport == "No" ? false : true;
    drivingStatus = userDetails!.driving == "No" ? false : true;
    swimmingStatus = userDetails!.swimming == "No" ? false : true;
    danceStatus = userDetails!.dance != "No" ? true : false;
    boldContent = userDetails!.boldContent != "No" ? true : false;
    nudePrintShootStatus = userDetails!.nudePrintShoot != "No" ? true : false;
    nudePrintShootStatus = userDetails!.nudePrintShoot != "No" ? true : false;
    bikiniPrintShootStatus =
        userDetails!.bikiniPrintShoot != "No" ? true : false;
    trainedActorStatus = userDetails!.trainedActor != "No" ? true : false;
    unionCardStatus = userDetails!.unionCard != "No" ? true : false;
    experinceStatus = userDetails!.experince != "No" ? true : false;
    disablitilyStatus = userDetails!.disability != ""
        ? userDetails!.disability != "No"
            ? true
            : false
        : false;

    _experience_area.text = userDetails!.experienceArea;

    print("sedn succ");
    /* for (int i = 0; i < da.length; i++) {
      for (int j = 0; j < lang.length; j++) {
        if (da[i] ==lang[i]) {
          print("skincolor ${userDetails!.skinColor}");
          SkinColorSelectChip.sItem = userDetails!.skinColor;
        }
      }
    } */

    print(lan);

    /* tCountry = userDetails!.country;
    //tState = userDetails!.state;
    tCity = userDetails!.city; */
    //print(userDetails!.langauge);

    for (int i = 0; i < skinColor.length; i++) {
      if (userDetails!.skinColor == skinColor[i]) {
        print("skincolor ${userDetails!.skinColor}");
        SkinColorSelectChip.sItem = userDetails!.skinColor;
      }
    }

    for (int i = 0; i < hair.length; i++) {
      if (userDetails!.hairStyle == hair[i]) {
        print(userDetails!.langauge);

        HairTypeSelectChip.sItem = userDetails!.hairStyle;
      }
    }
    for (int i = 0; i < hairColor.length; i++) {
      if (userDetails!.hairColor == hairColor[i]) {
        print(userDetails!.hairColor);
        HairColorSelectChip.sItem = userDetails!.hairColor;
      }
    }

    for (int i = 0; i < eyeColor.length; i++) {
      if (userDetails!.eyecolor == eyeColor[i]) {
        print(userDetails!.eyecolor);
        EyeColorSelectChip.sItem = userDetails!.eyecolor;
      }
    }

    /* _isSelected(2);
    _isHairSelected(1);
    _isGenderSelected(0);
    _isSkinColorSelected(2); */
  }

  Future getUser() async {
    Future.delayed(Duration(seconds: 1), () async {
      User user = await ApiHandle.fetchUser();
      print("sdsd");
      if (mounted) {
        setState(() {
          isLoading = false;
          userDetails = user;
          setData();
        });
      }
    });
  }

  // update details
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
      String instituteName) async {
    // var s=SingleSelectChip(lang).createState().getSelectedItem();
    //print(s);
    print(gender);
    print("sidList $sidList");
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
        sidList == null ? userDetails!.userCategory : sidList!,
        tCountry,
        tState,
        tCity,
        _weight.text,
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
        tBodyType == null ? "" : tBodyType!,
        disablitilyStatus == true ? "Yes" : "No",
        tMaeritial == null ? "" : tMaeritial!,
        _userCategory,
        workshopStatus == true ? "Yes" : "No",
        instituteName,
        _address.text,
        _pincode.text,
        industry);
    var statusCode = res.statusCode;
    print("statuscode $statusCode");

    if (statusCode == 200) {
      var response = jsonDecode(res.body);
      String re = response["res"];
      String msg = response["msg"];
      if (re == "success") {
        MyToast(message: msg).toast;
        /*   Future.delayed(Duration(seconds: 1),
            () => Navigator.pushNamed(context, PageRoutes.choose_talent)); */
      } else {
        MyToast(message: msg).toast;
      }
    }
  }

  bool valid() {
    tname = _name.text;
    tEmailid = _email.text;
    tDob = _dob.text;
    tLang = LanguageList(lang, 1).createState().getSelectedList();
    tSkincolor = SkinColorSelectChip(skinColor).createState().getSelectedItem();
    tHairtype = HairTypeSelectChip(hair).createState().getSelectedItem();
    tHhaircolor =
        HairColorSelectChip(hairColor).createState().getSelectedItem();

    tEyeColor = EyeColorSelectChip(hair).createState().getSelectedItem();
    print(tLang);
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
    } else if (_userCategory == "Artist" || _userCategory == "Model") {
      if (tLang!.isEmpty) {
        MyToast(message: "Please Choose Your Language").toast;
        return false;
      } else if (tHeight.isEmpty) {
        MyToast(message: "Please Choose Your Height").toast;
        return false;
      } else if (tChestSize.isEmpty) {
        MyToast(message: "Please Choose Your Chest Size").toast;
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
      } else if (_userCategoryGender.isEmpty) {
        MyToast(message: "Please Choose Your Gender").toast;
        return false;
      } else if (tEyeColor.isEmpty) {
        MyToast(message: "Please Choose Your Eye Color").toast;
        return false;
      }
      return true;
    } else {
      return true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
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
                              hintStyle: TextStyle(color: Colors.grey.shade300),
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
                            maxLength: 10,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              prefixIcon: Icon(
                                Icons.email,
                                color: buttonColor,
                              ),
                              hintText: "Email id",
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade300),
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
                              counterText: "",
                              suffixIcon: InkWell(
                                onTap: () {
                                  //_selectDate(context);
                                  openCupterTinoDatePicker();
                                },
                                child: Icon(
                                  Icons.date_range,
                                  color: buttonColor,
                                ),
                              ),
                              hintText: "Dob",
                              hintStyle: TextStyle(color: Colors.grey.shade300),
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
                                    width: 125,
                                    child: ListTile(
                                      title: const Text('Female',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        value: categorygender[1],
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
                                    width: 150,
                                    child: ListTile(
                                      title: const Text('Transgenders',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categorygender[2],
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
                                contentPadding: EdgeInsets.all(0),
                                horizontalTitleGap: 1,
                                leading: Radio<String>(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => buttonColor),
                                  value: categorygender[3],
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
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[0],
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
                                      title: const Text('Model',
                                          style: TextStyle(
                                            fontSize: 10,
                                          )),
                                      horizontalTitleGap: 1,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[1],
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[2],
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[3],
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
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Creative Head',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[4],
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
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Musician',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[6],
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[5],
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
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Technician & Vendors',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[7],
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
                                  Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text(
                                        'Producer & Production House',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      horizontalTitleGap: 5,
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => buttonColor),
                                        value: categoryList[8],
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
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: false,
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
                        visible: false,
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
                                    'Male',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  horizontalTitleGap: 1,
                                  leading: Radio<String>(
                                    value: categorygender[0],
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
                                width: 120,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: const Text('Female',
                                      style: TextStyle(
                                        fontSize: 10,
                                      )),
                                  horizontalTitleGap: 1,
                                  leading: Radio<String>(
                                    value: categorygender[1],
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
                                  title: const Text('Transgenders',
                                      style: TextStyle(
                                        fontSize: 10,
                                      )),
                                  horizontalTitleGap: 1,
                                  leading: Radio<String>(
                                    value: categorygender[2],
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
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          cat.clear();
                          cat.add(_userCategory);
                          if (_userCategory == "Model") {
                            cat.add(_userCategoryGender);
                          }
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
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: disabledTextColor)),
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
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
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
                              color: backgroundColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: DropdownButtonFormField<dynamic>(
                              //underline: SizedBox(),
                              value: tCountry.isEmpty ? null : tCountry,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Country",
                                hintStyle: TextStyle(color: Colors.white),
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
                      SizedBox(
                        height: 10,
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
                              value: industry.isEmpty ? null : industry,
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
                    ],
                  )),
                  Visibility(
                    visible: _userCategory == "Technician & Vendors" ||
                            _userCategory == "Creative Director" ||
                            _userCategory == "Creative Head" ||
                            _userCategory == "Singer" ||
                            _userCategory == "Writer" ||
                            _userCategory == "Musician" ||
                            _userCategory == "Director" ||
                            _userCategory == "Producer & Production House"
                        ? false
                        : true,
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
                                labelStyle: TextStyle(color: Colors.white),
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
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText: "Body type",
                                  contentPadding: EdgeInsets.all(5),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
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
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  hintText: "Marital Status",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
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
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: DropdownButtonFormField<dynamic>(
                                      //underline: SizedBox(),
                                      value: tHeight.isEmpty ? null : tHeight,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        hintText: "Height",
                                        labelText: "Height",
                                        contentPadding: EdgeInsets.all(5),

                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //  labelT: TextStyle(fontSize: 14),
                                        border: InputBorder.none,
                                      ),
                                      items: height.map((String name) {
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
                                        tHeight = val;
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
                                  margin: EdgeInsets.all(3),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: DropdownButtonFormField<dynamic>(
                                      //underline: SizedBox(),
                                      value: tChestSize.isEmpty
                                          ? null
                                          : tChestSize,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),

                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        hintText:
                                            _userCategoryGender != "Transgender"
                                                ? _userCategoryGender == "Male"
                                                    ? "Chest Size (inch)"
                                                    : "Breast  Size (inch)"
                                                : "Chest Size (inch)",
                                        labelText:
                                            _userCategoryGender != "Transgender"
                                                ? _userCategoryGender == "Male"
                                                    ? "Chest Size (inch)"
                                                    : "Breast  Size (inch)"
                                                : "Chest Size (inch)",
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                      items: chestSize.map((String name) {
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
                                  margin: EdgeInsets.all(3),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: DropdownButtonFormField<dynamic>(
                                      //underline: SizedBox(),

                                      value: tHipSize.isEmpty ? null : tHipSize,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),

                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        hintText: "Hip Size (inch)",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        labelText: "Hip Size (inch)",
                                        border: InputBorder.none,
                                      ),
                                      items: hiPSize.map((String name) {
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
                                  margin: EdgeInsets.all(3),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: DropdownButtonFormField<dynamic>(
                                      //underline: SizedBox(),
                                      style: TextStyle(color: Colors.white),
                                      value: tWaistSize.isEmpty
                                          ? null
                                          : tWaistSize,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        hintText: "Waist Size (inch)",
                                        labelText: "Waist Size (inch)",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                      items: waistSize.map((String name) {
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
                                        tWaistSize = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Choose your language",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: LanguageList(lang, 2),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Choose your Skin Color ",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: SkinColorSelectChip(skinColor),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Choose your Hair Type ",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: HairTypeSelectChip(hair),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Choose your Eye  Color",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: EyeColorSelectChip(eyeColor),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Choose your Hair  Color",
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: HairColorSelectChip(hairColor),
                          ),
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
                                      "Do You Have Passport",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: passportStatus,
                                onChanged: (val) {
                                  setState(() {
                                    passportStatus = val;
                                  });
                                },
                              ),
                              Text(
                                passportStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                      "Do You Know Driving",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: drivingStatus,
                                onChanged: (val) {
                                  setState(() {
                                    drivingStatus = val;
                                  });
                                },
                              ),
                              Text(
                                drivingStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                      "Do You Know Swimming",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: swimmingStatus,
                                onChanged: (val) {
                                  setState(() {
                                    swimmingStatus = val;
                                  });
                                },
                              ),
                              Text(
                                swimmingStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                      "Do You Know Dance",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: danceStatus,
                                onChanged: (val) {
                                  setState(() {
                                    danceStatus = val;
                                  });
                                },
                              ),
                              Text(
                                danceStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: boldContent,
                                onChanged: (val) {
                                  setState(() {
                                    boldContent = val;
                                  });
                                },
                              ),
                              Text(
                                boldContent == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: printShootStatus,
                                onChanged: (val) {
                                  setState(() {
                                    printShootStatus = val;
                                  });
                                },
                              ),
                              Text(
                                printShootStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: bodyPrintShootStatus,
                                onChanged: (val) {
                                  setState(() {
                                    bodyPrintShootStatus = val;
                                  });
                                },
                              ),
                              Text(
                                bodyPrintShootStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: nudePrintShootStatus,
                                onChanged: (val) {
                                  setState(() {
                                    nudePrintShootStatus = val;
                                  });
                                },
                              ),
                              Text(
                                nudePrintShootStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),
                        Visibility(
                          visible:
                              _userCategoryGender == "Female" ? true : false,
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
                                          color: buttonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: bikiniPrintShootStatus,
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
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            visible:
                                _userCategoryGender == "Female" ? true : false,
                            child: Divider(color: Colors.grey.shade50)),
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
                                            color: buttonColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: trainedActorStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        trainedActorStatus = val;
                                      });
                                    },
                                  ),
                                  Text(
                                    trainedActorStatus == false ? "No" : "Yes",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                visible:
                                    trainedActorStatus == true ? true : false,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                        controller: _institute,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: "Insitute Name",
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
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: disabledTextColor)),
                                        ))),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade50),

                        /*                       Divider(color: Colors.grey.shade50),
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
                                              color: buttonColor,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: disablitilyStatus,
                                onChanged: (val) {
                                  setState(() {
                                    disablitilyStatus = val;
                                  });
                                },
                              ),
                              Text(
                                disablitilyStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(color: Colors.grey.shade50),
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
                                      "Are you interested in Workshop",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: buttonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: workshopStatus,
                                onChanged: (val) {
                                  setState(() {
                                    workshopStatus = val;
                                  });
                                },
                              ),
                              Text(
                                workshopStatus == false ? "No" : "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade50),
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
                                  color: buttonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: unionCardStatus,
                          onChanged: (val) {
                            setState(() {
                              unionCardStatus = val;
                            });
                          },
                        ),
                        Text(
                          unionCardStatus == false ? "No" : "Yes",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade50),
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
                                  color: buttonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: experinceStatus,
                          onChanged: (val) {
                            setState(() {
                              experinceStatus = val;
                            });
                          },
                        ),
                        Text(
                          experinceStatus == false ? "No" : "Yes",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
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
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (valid()) {
                        print("hello");
                        showDialog(
                            context: context,
                            builder: (context) => FutureProgressDialog(
                                updatePersionalDetails(
                                    userDetails!.id,
                                    tname,
                                    tEmailid,
                                    _userCategoryGender,
                                    tDob,
                                    tLang!.isEmpty ? "" : listToString(tLang!),
                                    tSkincolor.isEmpty ? "" : tSkincolor,
                                    tHairtype.isEmpty ? "" : tHairtype,
                                    tHhaircolor.isEmpty ? "" : tHhaircolor,
                                    tHeight.isEmpty ? "" : tHeight,
                                    tChestSize.isEmpty ? "" : tChestSize,
                                    tWaistSize.isEmpty ? "" : tWaistSize,
                                    tHipSize.isEmpty ? "" : tHipSize,
                                    tEyeColor.isEmpty ? "" : tEyeColor,
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
                                    _institute.text)));
                      }

                      /* Navigator.pushNamedAndRemoveUntil(
                          context, PageRoutes.bottomNavigation, (route) => false); */
                      //Navigator.pushNamed(context, PageRoutes.personal_info);
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Update",
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
          isLoading == true
              ? Align(
                  alignment: Alignment.center,
                  child: SpinKitCircle(
                    color: buttonColor,
                    size: 100,
                  ),
                )
              : Container()
        ]),
      ),
    );
  }

  void openCupterTinoDatePicker() {
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

  void getAge(DateTime selectedDate) {
    String datePattern = "dd-MM-yyyy";

    DateTime birthDate = selectedDate;
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    if (yearDiff < 1) {
      MyToast(message: "You are not eligible").toast;
      _dob.text = "";
      //uage = "";
    } else {
      //uage = "${yearDiff}";
    }
    print(yearDiff);
  }
}
