import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:video_trimmer/video_trimmer.dart';

//this is trimmer view for trimming video

class TrimmerVie extends StatefulWidget {
  final Trimmer _trimmer;
  final ValueSetter<String> onVideoSaved;
  final double maxLength;
  String sound =
      "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3";

  TrimmerVie(this._trimmer, this.onVideoSaved, this.maxLength, this.sound);

  @override
  _TrimmerVieState createState() => _TrimmerVieState();
}

class _TrimmerVieState extends State<TrimmerVie> {
  double _startValue = 0.0;
  double _endValue = 0.0;
  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
  bool _isPlaying = false;
  bool _progressVisibility = false;

//funtion to trim video and save video
  Future<String> _saveVideo() async {
    setState(() {
      if (_startValue + widget.maxLength * 1000 < _endValue) {
        _endValue = _startValue + widget.maxLength * 1000;
      }
      _progressVisibility = true;
    });

    print("_startValue");
    print(_startValue);
    print("_endValue");
    print(_endValue);
    print("widget.maxLength");
    print(widget.maxLength);
    String _value = "";
    await widget._trimmer
        .saveTrimmedVideo(
            applyVideoEncoding: true,
            startValue: _startValue,
            endValue: _endValue,

//            maxLength: widget.maxLength,
            customVideoFormat: '.mp4')
        .then((value) {
      setState(() async {
        _progressVisibility = true;
        _value = value;
      });
    });
    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          " Trim Your Video Here",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Builder(
          builder: (context) => Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Visibility(
                        visible: _progressVisibility,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            //gradient: Gradients.blush
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(_saveVideo()));
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'RockWellStd',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onPressed: _progressVisibility
                            ? null
                            : () async {
                                _saveVideo().then((outputPath) {
                                  print('OUTPUT PATH: $outputPath');
                                  final snackBar = SnackBar(
                                    content: Text('Video Saved successfully'),
                                  );
                                  widget.onVideoSaved(outputPath);
                                  //Scaffold.of(c).showSnackBar(snackBar);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              },
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //video viewr for trimming video

                      Expanded(
                        child: VideoViewer(
                          trimmer: widget._trimmer,
                        ),
                      ),
                      Center(
                        child: TrimEditor(
                            trimmer: widget._trimmer,
                            viewerHeight: 50.0,
                            viewerWidth: MediaQuery.of(context).size.width,
                            maxVideoLength:
                                Duration(seconds: widget.maxLength.toInt()),
                            onChangeStart: (value) {
                              _startValue = value;
                              print("start  $value");
                            },
                            onChangeEnd: (value) {
                              print("End changed");
                              _endValue = value;
                              print("end  $value");
                            },
                            onChangePlaybackState: (value) {
                              print(
                                  "onChangePlaybackState $_endValue $_startValue");
                              if (_endValue - _startValue >=
                                  widget.maxLength * 1000 + 0.1) {
                                setState(() {
                                  _endValue =
                                      _startValue + widget.maxLength * 1000;
                                });
                              }
                              if (widget.sound != "") {
                                if (assetsAudioPlayer
                                        .currentPosition.value.inMilliseconds
                                        .toDouble() >=
                                    _endValue) {
                                  assetsAudioPlayer.playOrPause();
                                }
                                if (!value) {
                                  assetsAudioPlayer.pause();
                                  assetsAudioPlayer.seek(Duration(seconds: 0));
                                } else {
                                  assetsAudioPlayer.play();
                                }
                              }
                              setState(() {
                                _isPlaying = value;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            //gradient: Gradients.blush
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  _isPlaying ? "Pause" : "Play",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'RockWellStd',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onPressed: () async {
                          /* if (widget.sound != "") {
                            if (assetsAudioPlayer.current.value == null) {
                              AssetsAudioPlayer.allPlayers()
                                  .forEach((key, value) {
                                value.pause();
                              });
                              await assetsAudioPlayer.open(
                                  Audio.network(widget.sound),
                                  autoStart: true);
                            } else {
                              AssetsAudioPlayer.allPlayers()
                                  .forEach((key, value) {
                                value.pause();
                              });
                              assetsAudioPlayer.pause();
                            }
                          } */
                          bool playbackState =
                              await widget._trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );

                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  String durationToString(Duration duration) {
    String twoDigits(var n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
