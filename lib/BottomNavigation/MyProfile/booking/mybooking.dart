import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:qvid/Screens/booking/booking_card_design.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/booking.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/widget/toast.dart';

class MyBooking extends StatefulWidget {
  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  List<Booking>? bookingList;
  bool isLoading = false;
  bool isDataFound = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      findUser().then((user) => getCelebrityWishesh(user.id));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          brightness: Brightness.light,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: buttonColor),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Your Booking History",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            isLoading == false && isDataFound == true
                ? ListView.builder(
                    itemCount: bookingList!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        BookingDesign(
                                context: context, booking: bookingList![index])
                            .list)
                : Center(child: Text("")),
            isLoading == true
                ? Align(
                    alignment: Alignment.center,
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                    ),
                  )
                : Container(),
          ],
        ));
  }

  //fina user
  Future<User> findUser() async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    //print(user.id + user.name);
    return user;
  }

  //load Booking

  Future<List<Booking>> getCelebrityWishesh(String userId) async {
    setState(() {
      isLoading = true;
    });

    Response response = await Apis().getMyBookingList(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'] as List;
        print("sdsd");
        print(re);
        print(re.length);

        if (mounted)
          setState(() {
            bookingList = re.map<Booking>((e) => Booking.fromJson(e)).toList();
            //isSearching = false;
            isLoading = false;
            isDataFound = true;
            FocusManager.instance.primaryFocus!.unfocus();
          });
        return re.map<Booking>((e) => Booking.fromJson(e)).toList();
      } else {
        MyToast(message: msg).toast;
        setState(() {
          //isSearching = false;
          isLoading = false;
          isDataFound = false;
        });
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
