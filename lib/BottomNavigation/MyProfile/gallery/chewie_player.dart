import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:qvid/utils/constaints.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewieDemoPlayer extends StatefulWidget {
  final String fileName;
  String? i;
  ChewieDemoPlayer({required this.fileName, this.i = ""});

  @override
  _FlickerDemoPlayerState createState() => _FlickerDemoPlayerState();
}

class _FlickerDemoPlayerState extends State<ChewieDemoPlayer> {
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
      errorBuilder: (context, errorMessage) => Text(errorMessage),
      videoPlayerController: _controller!,
      autoPlay: true,
      aspectRatio: 16 / 9,
      autoInitialize: true,
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
    return Container(
      child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Chewie(
                controller: chewieController!,
              ))),
    );
  }
}
