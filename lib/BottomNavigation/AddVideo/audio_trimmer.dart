import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/AddVideo/add_video_filter.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:video_trimmer/video_trimmer.dart';

class AudioTrimmer extends StatefulWidget {
  final File file;

  AudioTrimmer(this.file);

  @override
  _AudioTrimmerState createState() => _AudioTrimmerState();
}

class _AudioTrimmerState extends State<AudioTrimmer> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Trim your Audio here..."),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                /* Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ), */
                Center(
                  child: TrimEditor(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,

                    viewerWidth: MediaQuery.of(context).size.width,
                    //maxVideoLength: Duration(seconds: 30),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 80.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 80.0,
                                color: Colors.white,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: _progressVisibility
                            ? null
                            : () async {
                                _saveVideo().then((outputPath) {
                                  print('OUTPUT PATH: $outputPath');
                                  File file = File(outputPath!);
                                  Navigator.pushNamed(
                                      context, PageRoutes.addVideoPage,
                                      arguments: file);

                                  /*   final snackBar = SnackBar(
                                  content: Text('Video Saved successfully'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBar,
                              ); */
                                });
                              },
                        child: Text("SAVE"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
