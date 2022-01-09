/* import 'package:flutter/material.dart';

class CustomMusicList
{

    static Padding get musicLi=>Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: 80,
                                height: 55,
                                child: Image.asset(
                                  "assets/images/slider4.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rim Jhim",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("jubin nautiyal"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      /*   setState(() {
                          selectedIndex = index;
                        });
                        print(index);
                        playAudio(); */
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          ispressed != true && selectedIndex != index
                              ? Icons.play_circle
                              : Icons.pause_circle,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ));
} */