import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> talentList;
  final int status;
  MultiSelectChip(this.talentList, this.status);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState(status);
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  //String selectedChoice = "";

  static List<String> selectChoice = [];
  late int sta;
  @override
  void initState() {
    //selectChoice.clear();
    super.initState();
  }

  _MultiSelectChipState(int status) {
    sta = status;
    if (sta == 1) {
    } else {}
  }

  //this method will build and return the choice list
  _buildTalentList() {
    List<Widget> choiceList = [];

    widget.talentList.forEach((item) {
      choiceList.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            selectedColor: buttonColor,

            label: Text(
              item,
              style: TextStyle(
                  color: selectChoice.contains(item)
                      ? Colors.white
                      : Colors.black),
            ),
            //selected: selectedChoice == item,
            selected: selectChoice.contains(item),

            backgroundColor: Colors.grey.shade200,
            onSelected: (selected) {
              /* setState(() {
                selectedChoice = item;
              }); */
              setState(() {
                print("sdsd");

                selectChoice.contains(item)
                    ? selectChoice.remove(item)
                    : selectChoice.add(item);
              });
            },
          )));
    });
    return choiceList;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildTalentList(),
    );
  }

  List<String> getSelectedList() {
    print(selectChoice.length);
    return selectChoice;
  }
}
