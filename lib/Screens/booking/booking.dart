import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/apis/api.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/bookings.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:qvid/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingList extends StatefulWidget {
  String type;
  BookingList({required this.type});

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<Bookings> bookingList = [];
  bool isLoading = true;
  bool isUpdateStatus = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      fetchBookingList(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.type == "booked_me" ? "Bookings" : "My Bookings",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: isLoading == false
            ? bookingList.isNotEmpty
                ? ListView.builder(
                    itemCount: bookingList.length,
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                        child: GestureDetector(
                          onTap: () {
                            print("id ${bookingList[index].userId}");
                            Navigator.pushNamed(
                                context, PageRoutes.userProfilePage,
                                arguments: widget.type == "booked_me"
                                    ? bookingList[index].bookedBy!
                                    : bookingList[index].userId!);
                          },
                          child: widget.type == "booked_me"
                              ? Card(
                                  color: cardColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      //color:
                                      /*  Colors.primaries[Random().nextInt(Colors.primaries.length)], */
                                      //color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  bookingList[index].image ==
                                                          null
                                                      ? CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/user/user1.png'))
                                                      : CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage:
                                                              NetworkImage(Constraints
                                                                      .IMAGE_BASE_URL +
                                                                  bookingList[
                                                                          index]
                                                                      .image!),
                                                        ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "${bookingList[index].name}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            Text(
                                                              "${bookingList[index].date}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "${bookingList[index].category}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Duration : ${bookingList[index].duration}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Amount : ₹ ${bookingList[index].amount}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "${bookingList[index].bookingStatus}",
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        color: bookingList[index].bookingStatus == "Pending"
                                                                            ? Colors.blue
                                                                            : bookingList[index].bookingStatus == "Accept"
                                                                                ? Colors.green
                                                                                : Colors.red))
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            /* Visibility(
                                              visible:
                                                  //userList[index].mobileStatus == "true"
                                                  //?
                                                  true,
                                              //: false,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    launch('tel:${"23232323"}');
                                                  },
                                                  child: Card(
                                                    color: Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      child: Icon(
                                                        Icons.call,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ) */
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: bookingList[index]
                                                      .bookingStatus ==
                                                  "Pending"
                                              ? true
                                              : false,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.green),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              Dialog(
                                                                  child:
                                                                      Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            width: 200,
                                                            height: 135,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top:
                                                                          15.0),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "Are you sure want to Accept this Booking",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black54),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child: ElevatedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: Text("No"))),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                        child: ElevatedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                              showDialog(context: context, builder: (context) => FutureProgressDialog(changeBookingStatus(bookingList[index].id, "Accept", index)));
                                                                            },
                                                                            child: Text("Yes"))),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                        );
                                                      },
                                                      child: Text("Accept"))),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              Dialog(
                                                                  child:
                                                                      Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            width: 200,
                                                            height: 135,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top:
                                                                          15.0),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "Are you sure want to Reject this Booking",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black54),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child: ElevatedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: Text("No"))),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                        child: ElevatedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                              showDialog(context: context, builder: (context) => FutureProgressDialog(changeBookingStatus(bookingList[index].id, "Reject", index)));
                                                                            },
                                                                            child: Text("Yes"))),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                        );
                                                      },
                                                      child: Text("Reject"))),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                              : Card(
                                  color: cardColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      //color:
                                      /*  Colors.primaries[Random().nextInt(Colors.primaries.length)], */
                                      //color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  bookingList[index].image ==
                                                          null
                                                      ? CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/user/user1.png'))
                                                      : CircleAvatar(
                                                          radius: 25.0,
                                                          backgroundImage:
                                                              NetworkImage(Constraints
                                                                      .IMAGE_BASE_URL +
                                                                  bookingList[
                                                                          index]
                                                                      .image!),
                                                        ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "${bookingList[index].name}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            "${bookingList[index].bookingStatus}",
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: bookingList[index].bookingStatus == "Pending"
                                                                                ? Colors.blue
                                                                                : bookingList[index].bookingStatus == "Accept"
                                                                                    ? Colors.green
                                                                                    : Colors.red))
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "${bookingList[index].category}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Duration : ${bookingList[index].duration}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "Amount : ₹ ${bookingList[index].amount}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: bookingList[
                                                                          index]
                                                                      .acceptedDate!
                                                                      .isEmpty
                                                                  ? true
                                                                  : false,
                                                              child: Text(
                                                                  " ${bookingList[index].date} ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                            Visibility(
                                                              visible: bookingList[
                                                                          index]
                                                                      .acceptedDate!
                                                                      .isEmpty
                                                                  ? false
                                                                  : true,
                                                              child: Text(
                                                                  "Date:  ${bookingList[index].acceptedDate} ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue)),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  //userList[index].mobileStatus == "true"
                                                  //?
                                                  false,
                                              //: false,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    launch('tel:${"23232323"}');
                                                  },
                                                  child: Card(
                                                    color: Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      child: Icon(
                                                        Icons.call,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                        )))
                : Center(
                    child: Lottie.asset(
                      "assets/animation/no-data.json",
                      width: 250,
                      height: 250,
                    ),
                  )
            : Center(
                child: SpinKitFadingCircle(
                  color: Colors.yellow,
                ),
              ));
  }

  void fetchBookingList(String type) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    Response response = await Apis().getBookingList(user.id, type);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      print(response.body);
      if (res == "success") {
        var re = data['data'] as List;
        setState(() {
          isLoading = false;
        });
        bookingList = re.map<Bookings>((e) => Bookings.fromJson(e)).toList();
      } else {
        print("error");
        setState(() {
          isLoading = false;
        });
        MyToast(message: msg).toast;
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future changeBookingStatus(String? id, String s, int index) async {
    Response resp = await Apis().updateBooking(id!, s);
    print(resp.body);
    if (resp.statusCode == 200) {
      var response = jsonDecode(resp.body);
      String res = response['res'];
      String msg = response['msg'];
      // String userType = response['user_type'];
      if (res == "success") {
        MyToast(message: msg).toast;
        if (mounted) {
          setState(() {
            bookingList[index].bookingStatus = s;
          });
        }
      } else {
        MyToast(message: msg).toast;
      }
    } else {}
  }
}
