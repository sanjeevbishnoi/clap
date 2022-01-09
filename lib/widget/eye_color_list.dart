import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class EyeColorSelectChip extends StatefulWidget {
  final List<String> itemList;

  static String? sItem;
  EyeColorSelectChip(this.itemList);

  @override
  _EyeColorSelectChipState createState() => _EyeColorSelectChipState();
}

String selectItem = "";

class _EyeColorSelectChipState extends State<EyeColorSelectChip> {
  //bool isSelect=false;
  //this is used to build list
  @override
  void initState() {
    selectItem = "";

    super.initState();
  }

  @override
  void dispose() {
    EyeColorSelectChip.sItem = "";
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
                  color: EyeColorSelectChip.sItem != null
                      ? EyeColorSelectChip.sItem == item
                          ? Colors.white
                          : Colors.grey.shade400
                      : selectItem == item
                          ? Colors.white
                          : Colors.grey.shade400),
            ),
            selectedColor: buttonColor,
            backgroundColor: cardColor,
            padding: EdgeInsets.all(10),
            selected: EyeColorSelectChip.sItem != null
                ? EyeColorSelectChip.sItem == item
                : selectItem == item,
            onSelected: (selected) {
              EyeColorSelectChip.sItem = null;

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
    if (EyeColorSelectChip.sItem != null) {
      return EyeColorSelectChip.sItem!;
    } else {
      return selectItem;
    }
  }
}
