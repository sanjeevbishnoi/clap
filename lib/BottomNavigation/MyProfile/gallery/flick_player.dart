import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class FlickerDemoPlayer extends StatefulWidget {
  final String fileName;
  String? i;
  FlickerDemoPlayer({required this.fileName, this.i = ""});

  @override
  _FlickerDemoPlayerState createState() => _FlickerDemoPlayerState();
}

class _FlickerDemoPlayerState extends State<FlickerDemoPlayer> {
  FlickManager? flickManager;

  VideoPlayerController? _controller;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    print("File Name");
    _controller = VideoPlayerController.network(
      widget.i == "2"
          ? Constraints.AUDIO_URL + widget.fileName
          : Constraints.Video_URL + widget.fileName,
    );
    chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
    );
    print(widget.i == "2"
        ? Constraints.AUDIO_URL
        : Constraints.Video_URL + widget.fileName);
    flickManager = FlickManager(videoPlayerController: _controller!);
  }

  @override
  void dispose() {
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* print("height ${_controller!.value.size.height}");
    print("width ${_controller!.value.size.width}"); */
    return Scaffold(
      body: Container(
        //alignment: Alignment.center,
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: FlickVideoPlayer(

              //flickVideoWithControlsFullscreen: Container(),
              flickManager: flickManager!),
        ),
      ),
    );
  }
}
