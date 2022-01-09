import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/AddVideo/my_trimmer.dart';
import 'package:qvid/Screens/auth/detail.dart';
import 'package:qvid/Theme/colors.dart';

import 'package:qvid/widget/hair_color_list.dart';
import 'package:qvid/widget/hair_type_list.dart';
import 'package:qvid/widget/skin_color_list.dart';
import 'package:qvid/widget/toast.dart';

class SingleSelectChip extends StatefulWidget {
  final List<String> itemList;

  static String? sItem;
  SingleSelectChip(
    this.itemList,
  );

  @override
  _SingleSelectChipState createState() => _SingleSelectChipState();
}

String selectItem = "";

class _SingleSelectChipState extends State<SingleSelectChip> {
  //bool isSelect=false;
  //this is used to build list

  _buildList() {
    List<Widget> choices = [];
    widget.itemList.forEach((item) {
      choices.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(
                  color: SingleSelectChip.sItem != null
                      ? SingleSelectChip.sItem == item
                          ? Colors.white
                          : Colors.black
                      : selectItem == item
                          ? Colors.white
                          : Colors.black),
            ),
            selectedColor: buttonColor,
            backgroundColor: Colors.grey.shade200,
            padding: EdgeInsets.all(10),
            selected: SingleSelectChip.sItem != null
                ? SingleSelectChip.sItem == item
                : selectItem == item,
            onSelected: (selected) {
              if (SingleSelectChip.sItem != null) {
                SingleSelectChip.sItem = null;
              }
              setState(() {
                selectItem = item;
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TrimmerView(file)));
                print(selectItem);
              });
            },
          ),
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.horizontal, children: _buildList());
  }

  String getSelectedItem() {
    if (SingleSelectChip.sItem != null) {
      return SingleSelectChip.sItem!;
    } else {
      return selectItem;
    }
  }
}
