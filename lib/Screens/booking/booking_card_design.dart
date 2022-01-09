import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/model/booking.dart';
import 'package:qvid/utils/constaints.dart';

class BookingDesign {
  BuildContext context;
  final Booking booking;

  BookingDesign({required this.context, required this.booking});
  Widget get list => Padding(
      padding: EdgeInsets.only(top: 5, right: 5, left: 5),
      child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              //color   :
              /*  Colors.primaries[Random().nextInt(Colors.primaries.length)], */
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          booking.userProfile!.isEmpty
                              ? CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage:
                                      AssetImage('assets/user/user1.png'))
                              : CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(
                                      Constraints.IMAGE_BASE_URL +
                                          booking.userProfile!)),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${booking.userName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${booking.userEmail}",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    /* Container(
                      margin: EdgeInsets.all(10),
                      padding:
                          EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                      alignment: Alignment.center,
                      height: 30,
                      child: Text(
                        "View Profile",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                    ), */
                    Text(
                      "${booking.bookingStatus}",
                      style: TextStyle(color: buttonColor),
                    )
                  ],
                ),
              ],
            ),
          )));
}
