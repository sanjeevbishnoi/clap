import 'package:flutter/material.dart';
import 'package:qvid/Screens/auth/detail.dart';
import 'package:qvid/Theme/colors.dart';

class SkinColorSelectChip extends StatefulWidget {
  final List<String> itemList;

  static String? sItem;
  SkinColorSelectChip(this.itemList);

  @override
  _SkinColorSelectChipState createState() => _SkinColorSelectChipState();
}

String selectItem = "";

class _SkinColorSelectChipState extends State<SkinColorSelectChip> {
  //bool isSelect=false;
  //this is used to build list
  @override
  void initState() {
    selectItem = "";
    super.initState();
  }

  @override
  void dispose() {
    SkinColorSelectChip.sItem = "";
    super.dispose();
  }

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
                  color: SkinColorSelectChip.sItem != null
                      ? SkinColorSelectChip.sItem == item
                          ? Colors.white
                          : Colors.grey.shade400
                      : selectItem == item
                          ? Colors.white
                          : Colors.grey.shade400),
            ),
            selectedColor: buttonColor,
            backgroundColor: cardColor,
            padding: EdgeInsets.all(10),
            selected: SkinColorSelectChip.sItem != null
                ? SkinColorSelectChip.sItem == item
                : selectItem == item,
            onSelected: (selected) {
              SkinColorSelectChip.sItem = null;

              setState(() {
                selectItem = item;

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
    if (SkinColorSelectChip.sItem != null) {
      return SkinColorSelectChip.sItem!;
    } else {
      return selectItem;
    }
  }
}
