import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/model/user_categories.dart';
import 'package:qvid/widget/interest_list.dart';
import 'package:qvid/widget/multiple_chip.dart';
import 'package:qvid/widget/toast.dart';

List<String> talent = [
  "ACTOR",
  "DANCER",
  "MUSICIAN",
  "SCRIPT WRITER",
  "ANCHOR/EMCEE",
  "JUNIOR ARTIST",
  "SINGER",
  "CHOREOGRAPHER",
  "MODEL",
  "RADIO JOCKEY",
  "COMEDIAN",
  "DIRECTOR",
  "PRODUCTION CREW",
];
List<String> interst = [
  "THEATRE ",
  "RADIO",
  "REALITY SHOWS ",
  "TV",
  "WORKSHOP",
  "PRINT MEDIA",
  "SHORT FILMS ",
  "WEBSERIES",
  "MUSIC VIDEOS",
  "STAGE/LIVE PERFORMACES"
];

class ChoiceTalent extends StatefulWidget {
  @override
  State<ChoiceTalent> createState() => _ChoiceTalentState();
}

class _ChoiceTalentState extends State<ChoiceTalent> {
  static late String userId, talents, interests;
  TextEditingController _category = TextEditingController();

  bool isSelected = false;
  List<UserCategories>? list;
  String? sidList;
  String? categoryName;
  @override
  void initState() {
    findUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text("Select Talent/Interest",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Talent",
                style: TextStyle(
                    fontSize: 17,
                    color: buttonColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: MultiSelectChip(talent, 2),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Select Interest",
                style: TextStyle(
                    fontSize: 17,
                    color: buttonColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              /* Container(
                child: InterestList(interst, 2),
              ), */
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                      context, PageRoutes.avaliable_categories) as Map;
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
                          hintText: "Select Your Expertise",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: mainColor),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              borderSide: BorderSide(color: disabledTextColor)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: disabledTextColor)))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, PageRoutes.choose_talent);
                  //Navigator.pushNamed(context, PageRoutes.social_media_info);
                  if (valid()) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            FutureProgressDialog(updateTalentdata(
                              userId,
                              tal,
                              sidList!,
                            )));
                  }
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
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    userId = user.id;
  }

  Future updateTalentdata(
      String userId, List<String> talent, String interst) async {
    Response resp =
        await Apis().updateTalentDetails(userId, listToString(talent), interst);

    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        Future.delayed(Duration(microseconds: 1), () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PageRoutes.basic_profile_info);
          MyToast(message: msg).toast;
        });
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }

  late List<String> tal, inter;
  bool valid() {
    tal = MultiSelectChip(talent, 2).createState().getSelectedList();
    print(tal.toString());
    inter = InterestList(interst, 2).createState().getSelectedList();
    print(inter.toString());
    if (tal.length == 0) {
      MyToast(message: "Please select Your talent").toast;
      return false;
    } else if (_category.text.isEmpty) {
      MyToast(message: "Please Select Your Expertise").toast;
      return false;
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
}
