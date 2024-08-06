

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils.dart';


class VideoViewer extends StatefulWidget {
  VideoViewer({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoViewer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  ColorClass colorClass = ColorClass();

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://equigro.org/video/blueprint.mp4',
    );

    _initializeVideoPlayerFuture = _controller!.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorClass.appBlack,
      appBar: AppBar(
        title: Text('Intro Video'),
        backgroundColor: colorClass.appBlue,
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the VideoPlayer.
              _controller!.play();
              return AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,

                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller!),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              // If the video is paused, play it.
              _controller!.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
