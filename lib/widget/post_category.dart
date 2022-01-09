import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/user_categories.dart';

class PostCategorySelectChip extends StatefulWidget {
  final List<UserCategories> itemList;
  PostCategorySelectChip(this.itemList);

  @override
  _PostCategorySelectChipState createState() => _PostCategorySelectChipState();
}

String selectItem = "";

class _PostCategorySelectChipState extends State<PostCategorySelectChip> {
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
              item.name,
              style: TextStyle(
                  color: selectItem == item.id ? Colors.white : Colors.black),
            ),
            selectedColor: buttonColor,
            backgroundColor: Colors.grey.shade200,
            padding: EdgeInsets.all(10),
            selected: selectItem == item.id,
            onSelected: (selected) {
              setState(() {
                selectItem = item.id;
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
    return selectItem;
  }
}
