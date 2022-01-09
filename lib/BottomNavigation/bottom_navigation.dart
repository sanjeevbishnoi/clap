import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/Explore/search.dart';
import 'package:qvid/BottomNavigation/Home/home_page.dart';
import 'package:qvid/BottomNavigation/MyProfile/my_profile_page.dart';
//import 'package:qvid/Locale/locale.dart';
//import 'package:qvid/Routes/routes.dart';
import 'package:qvid/BottomNavigation/Notifications/notification_messages.dart';
//import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Screens/dummy_container_screen.dart';
import 'package:qvid/Theme/colors.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _children = [
    MyContainer(),
    //ExplorePage(),
    // SearchPage(),
    Search(),
    //Container(),
    NotificationMessages(),
    HomePage(),
    //UserCustomProfile(),
    MyProfilePage()
  ];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //var locale = AppLocalizations.of(context)!;
    final List<BottomNavigationBarItem> _bottomBarItems = [
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/icons/ic_home.png'),
        ),
        activeIcon: ImageIcon(
          AssetImage('assets/icons/ic_homeactive.png'),
        ),
        //label: locale.home,
        label: "Home",
      ),
      BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/ic_explore.png'),
          ),
          activeIcon: ImageIcon(
            AssetImage('assets/icons/ic_exploreactive.png'),
          ),
          // label: locale.explore,
          label: "Explore"),
      BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/ic_notification.png'),
          ),
          activeIcon: ImageIcon(
            AssetImage('assets/icons/ic_notificationactive.png'),
          ),
          //label: locale.notification,
          label: "Notification"),
      BottomNavigationBarItem(
        /* icon: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 1.5),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: mainColor,
            ),
            child: Icon(Icons.add)), */
        //icon: Icon(Icons.add),
        //activeIcon: ImageIcon(AssetImage('assets/icons/reel.png')),
        icon: Icon(
          Icons.video_collection_sharp,
          color: Colors.white,
        ),
        activeIcon: Icon(Icons.video_collection_sharp),
        label: 'Clap',
      ),
      BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/ic_profile.png'),
          ),
          activeIcon: ImageIcon(
            AssetImage('assets/icons/ic_profileactive.png'),
          ),
          //label: locale.profile,
          label: "Profile"),
    ];
    return Scaffold(
      body: _children[_currentIndex],
      /* Stack(
        children: <Widget>[
          _children[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child:
          ),
        ],
      ), */

      bottomNavigationBar: SafeArea(
        bottom: true,
        left: true,
        right: true,
        maintainBottomViewPadding: true,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: transparentColor,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          iconSize: 22.0,
          selectedItemColor: Colors.red,
          selectedFontSize: 12,

          unselectedFontSize: 10,
          //unselectedItemColor: secondaryColor,
          unselectedItemColor: Colors.white,
          items: _bottomBarItems,
          onTap: onTap,
        ),
      ),
    );
  }
}
