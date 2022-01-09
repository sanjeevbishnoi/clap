import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:qvid/Theme/colors.dart';

class UserCustomProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(preferredSize: Size.fromHeight(200),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images/user_icon.png'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Atul maurya',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'atul@gmail.com',
                style: TextStyle(fontSize: 14, color: disabledTextColor),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: backgroundColor,
                    ),
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.5,
              ),
              InkWell(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.contact_support,
                      color: backgroundColor,
                    ),
                    title: Text(
                      "About us",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.5,
              ),
              InkWell(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.terrain,
                      color: backgroundColor,
                    ),
                    title: Text(
                      "Terms and Conditions",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
              ),
              InkWell(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.privacy_tip,
                      color: backgroundColor,
                    ),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
              ),
              InkWell(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: backgroundColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
