import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamer/screens/feedback.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final int startPosition;

  VideoScreen({this.id, this.startPosition = 0});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  YoutubePlayerController _controller;
  bool isShown = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        startAt: widget.startPosition,
      ),
    );
    _controller.addListener(() {
      print('POSITION ${_controller.value.position.inSeconds}');
      if (_controller.value.position.inSeconds == 60 && !isShown) {
        _controller.pause();
        setState(() {
          isShown = true;
        });

        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                key: key,
                title: Text('Do you like the video?'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int currentNo = prefs.getInt('No${widget.id}') ?? 0;
                        print(currentNo);
                        prefs.setInt('No${widget.id}', currentNo + 1);
                        _controller.play();
                        Navigator.of(ctx).pop();
                      },
                      child: Text('No')),
                  TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int currentYes = prefs.getInt('Yes${widget.id}') ?? 0;
                        print('YES $currentYes');
                        prefs.setInt('Yes${widget.id}', currentYes + 1);
                        _controller.play();
                        // key.currentContext
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Yes')),
                ],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    _prefs.then((value) {
      int currentPosition = _controller.value.position.inSeconds;
      value.setInt(widget.id, currentPosition);
      _controller.dispose();
    });
    super.dispose();
  }

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedBack(
                              id: widget.id,
                            )));
              },
              icon: Icon(Icons.thumb_up)),
        ],
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }
}
