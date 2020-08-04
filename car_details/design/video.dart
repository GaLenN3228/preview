import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class AVideo extends StatefulWidget {
  final String url;

  const AVideo({Key key, @required this.url}) : super(key: key);

  @override
  _AVideoState createState() => _AVideoState();
}

class _AVideoState extends State<AVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    _controller
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero);
        }
        setState(() {});
      });
  }

  bool isInitialized() => _controller != null && _controller.value.initialized;

  @override
  Widget build(BuildContext context) {
    Widget video;
    Widget playButton;
    if (isInitialized()) {
      video = AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
      playButton = _playButton();
    } else {
      video = Container(
        color: Thm.of(context).lightBackgroundColor,
      );
      playButton = CupertinoActivityIndicator();
    }

    return Tappable(
      onTap: isInitialized()
          ? () {
              if (!_controller.value.isPlaying) {
                _controller.play();
              } else {
                _controller.pause();
              }
              setState(() {});
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          video,
          playButton,
        ],
      ),
    );
  }

  Widget _playButton() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Thm.of(context).primaryColor.withOpacity(0.4),
        child: Center(
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
