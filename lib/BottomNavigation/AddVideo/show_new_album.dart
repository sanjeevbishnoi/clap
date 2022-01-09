import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:qvid/BottomNavigation/AddVideo/audio_trimmer.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:qvid/BottomNavigation/AddVideo/my_trimmer.dart';
import 'package:qvid/BottomNavigation/bottom_navigation.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/helper/api_handle.dart';
import 'package:qvid/model/audio.dart' as au;
import 'package:qvid/utils/constaints.dart';

List<String> songsList = [
  "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3",
  "",
  "",
  "",
  ""
];

class ShowNewAlbum extends StatefulWidget {
  ShowNewAlbum({Key? key}) : super(key: key);

  @override
  _ShowNewAlbumState createState() => _ShowNewAlbumState();
}

class _ShowNewAlbumState extends State<ShowNewAlbum> {
  bool ispressed = false;
  int selectedIndex = -1;
  bool isDialog = false;
  List<au.Audio> audiosList = [];
  bool isPlayin = false;
  bool isLoading = true;

  _isSelected(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      selectedIndex = index;
      ispressed = true;

      //playAudio(index);
    });
  }

  late AssetsAudioPlayer assetsAudioPlayer;

  @override
  void initState() {
    assetsAudioPlayer = AssetsAudioPlayer();
    Future.delayed(Duration(seconds: 1), () {
      getNewAudioList();
    });
    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: isLoading == false
          ? ListView.builder(
              itemCount: audiosList.length,
              itemBuilder: (BuildContext context1, int index) {
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: 80,
                                      height: 55,
                                      child: audiosList[index]
                                              .thumbnail!
                                              .isEmpty
                                          ? Image.asset(
                                              "assets/images/slider4.jpg",
                                              fit: BoxFit.fill,
                                            )
                                          : Image.network(
                                              Constraints.THUBNAIL_URL +
                                                  audiosList[index].thumbnail!),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${audiosList[index].songName}",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${audiosList[index].artist}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              playAudio(index);
                              _isSelected(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                selectedIndex != null &&
                                        selectedIndex == index &&
                                        isPlayin == false
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
                          /*                 Text(selectedIndex != null && selectedIndex == index
                          ? "selected"
                          : "unselectd"), */
                          GestureDetector(
                            onTap: () async {
                              isDialog = true;
                              showLoade(context);
                              _fileFromImageUrl(context, index)
                                  .then((File file) => {
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          print("hello");
                                          setState(() {
                                            isDialog = false;
                                            showLoade(context);
                                          });
                                          print(file.parent.path);
                                          Navigator.of(context).pop();
                                          Navigator.pushNamed(
                                              context, PageRoutes.addVideoPage,
                                              arguments: file);

                                          /* Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AudioTrimmer(file))); */
                                        })
                                      });
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
              })
          : SpinKitFadingCircle(
              color: buttonColor,
            ),
    ));
  }

  void playAudio(int index) async {
    print("Hello Play audio please");

    final bool isPlaying = assetsAudioPlayer.isPlaying.value;
    setState(() {
      isPlayin = isPlaying;
    });

    if (isPlaying) {
      assetsAudioPlayer.dispose();
      assetsAudioPlayer = AssetsAudioPlayer();

      bool isPlaying = assetsAudioPlayer.isPlaying.value;
      setState(() {
        isPlayin = isPlaying;
      });
      await assetsAudioPlayer.open(
          Audio.network(Constraints.AUDIO_URL + audiosList[index].songUrl!));
      assetsAudioPlayer.play();
    } else {
      await assetsAudioPlayer.open(
          Audio.network(Constraints.AUDIO_URL + audiosList[index].songUrl!));
      assetsAudioPlayer.play();
    }

    /* Future.delayed(Duration(seconds: 1), () {
      print("delte");
      setState(() {
        if (ispressed == false) {
          print("play");
          assetsAudioPlayer.play();
          ispressed = true;
          //selectedIndex = index;
        } else if (ispressed == true) {
          print("stop");
          assetsAudioPlayer.dispose();
          //assetsAudioPlayer.stop();
          ispressed = false;
          //selectedIndex = index;
        }
      });
    }); */
  }

  Future<File> _fileFromImageUrl(BuildContext context, int index) async {
    var url = Uri.parse(Constraints.AUDIO_URL + audiosList[index].songUrl!);
    final response = await http.get(url);
    final Directory? appDirectory = await getExternalStorageDirectory();
    final String outputDirectory = '${appDirectory!.path}/outputAudio';
    await Directory(outputDirectory).create(recursive: true);
    /*final String currentTime =
        "$countVideos" + DateTime.now().millisecondsSinceEpoch.toString();*/
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    //final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(outputDirectory, '${currentTime}.mp4'));
    print(outputDirectory);
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  showLoade(BuildContext context) async {
    /* final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.style(message: "Loading...");
    isDialog == true ? await pr.sho/w() : await pr.hide(); */
  }
  Future getNewAudioList() async {
    List<au.Audio> audioList = await ApiHandle.getNewReleaseAudio();
    setState(() {
      audiosList = audioList;
      isLoading = false;
    });
  }
}
