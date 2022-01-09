import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class HairTypeSelectChip extends StatefulWidget {
  final List<String> itemList;
  static String? sItem;
  HairTypeSelectChip(this.itemList);

  @override
  _HairTypeSelectChipState createState() => _HairTypeSelectChipState();
}

String selectItem = "";

class _HairTypeSelectChipState extends State<HairTypeSelectChip> {
  //bool isSelect=false;
  //this is used to build list
  @override
  void initState() {
    selectItem = "";
    super.initState();
  }

  @override
  void dispose() {
    HairTypeSelectChip.sItem = "";
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
                  color: HairTypeSelectChip.sItem != null
                      ? HairTypeSelectChip.sItem == item
                          ? Colors.white
                          : Colors.grey.shade400
                      : selectItem == item
                          ? Colors.white
                          : Colors.grey.shade400),
            ),
            selectedColor: buttonColor,
            backgroundColor: cardColor,
            padding: EdgeInsets.all(10),
            selected: HairTypeSelectChip.sItem != null
                ? HairTypeSelectChip.sItem == item
                : selectItem == item,
            onSelected: (selected) {
              if (HairTypeSelectChip.sItem != null) {
                HairTypeSelectChip.sItem = null;
              }
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
    if (HairTypeSelectChip.sItem != null) {
      return HairTypeSelectChip.sItem!;
    } else {
      return selectItem;
    }
  }
}
