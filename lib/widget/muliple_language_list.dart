import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';

class LanguageList extends StatefulWidget {
  final List<String> langaugeList;
  final int status;

  LanguageList(this.langaugeList, this.status);

  @override
  _LanguageListState createState() => _LanguageListState(status);
}

class _LanguageListState extends State<LanguageList> {
  //String selectedChoice = "";
  static List<String> selectChoice = [];
  late int sta;
  @override
  void initState() {
    selectChoice.clear();

    super.initState();
  }

  _LanguageListState(int status) {
    sta = status;
    if (sta == 1) {
    } else {}
  }

  //this method will build and return the choice list
  _buildTalentList() {
    List<Widget> choiceList = [];

    widget.langaugeList.forEach((item) {
      choiceList.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            selectedColor: buttonColor,

            label: Text(
              item,
              style: TextStyle(
                  color: selectChoice.contains(item)
                      ? Colors.white
                      : Colors.grey.shade400),
            ),
            //selected: selectedChoice == item,
            selected: selectChoice.contains(item),

            backgroundColor: cardColor,
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
    return ListView(
        scrollDirection: Axis.horizontal, children: _buildTalentList());
  }

  List<String> getSelectedList() {
    print(selectChoice.length);
    return selectChoice;
  }

  setSelected(List<String> l) {
    print("hi");
    print(l);
    selectChoice.addAll(l);

    print(selectChoice);
    print("byee");
  }
}
