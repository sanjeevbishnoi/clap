import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qvid/Routes/routes.dart';

// ignore: must_be_immutable
class NewReleaseList extends StatefulWidget {
  List<String> songsList;

  NewReleaseList({required this.songsList});
  @override
  _NewReleaseListState createState() => _NewReleaseListState();
}

class _NewReleaseListState extends State<NewReleaseList> {
  bool ispressed = false;
  int selectedIndex = -1;
  late AssetsAudioPlayer assetsAudioPlayer;

  @override
  void initState() {
    assetsAudioPlayer = AssetsAudioPlayer();

    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.songsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
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
                        print(index);
                        playAudio(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          ispressed != true
                              ? Icons.play_circle
                              : selectedIndex == index
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.addVideoPage);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  void playAudio(int index) {
    assetsAudioPlayer.open(Audio.network(
        "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3"));
    setState(() {
      if (ispressed == false) {
        print("play");
        assetsAudioPlayer.play();
        ispressed = true;
        selectedIndex = index;
      } else if (ispressed == true) {
        print("stop");
        assetsAudioPlayer.stop();
        ispressed = false;
        selectedIndex = index;
      }
    });
  }
}
