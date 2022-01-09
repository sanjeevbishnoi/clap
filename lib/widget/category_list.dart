import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/user_categories.dart';

class CategoryList extends StatefulWidget {
  //final List<String> categoryList;
  final List<UserCategories> categoryList;
  final int status;
  CategoryList(this.categoryList, this.status);

  @override
  _CategoryListState createState() => _CategoryListState(status);
}

class _CategoryListState extends State<CategoryList> {
  //String selectedChoice = "";

  static List<String> selectChoice = [];
  static List<String> selectCategoryName = [];
  late int sta;
  @override
  void initState() {
    //selectChoice.clear();
    super.initState();
  }

  _CategoryListState(int status) {
    sta = status;
    if (sta == 1) {
    } else {}
  }

  //this method will build and return the choice list
  _buildTalentList() {
    List<Widget> choiceList = [];

    widget.categoryList.forEach((item) {
      choiceList.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            selectedColor: buttonColor,
            label: Text(
              item.name,
              style: TextStyle(
                  fontSize: 12,
                  color: selectChoice.contains(item.id)
                      ? Colors.white
                      : Colors.white),
            ),
            //selected: selectedChoice == item,
            selected: selectChoice.contains(item.id),

            backgroundColor: cardColor,
            onSelected: (selected) {
              /* setState(() {
                selectedChoice = item;
              }); */
              setState(() {
                print("sdsd");

                selectChoice.contains(item.id)
                    ? selectChoice.remove(item.id)
                    : selectChoice.add(item.id);
                selectCategoryName.contains(item.name)
                    ? selectCategoryName.remove(item.name)
                    : selectCategoryName.add(item.name);
              });
            },
          )));
    });
    print(selectCategoryName);
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

  List<String> getSelectedCategoryName() {
    return selectCategoryName;
  }
}
