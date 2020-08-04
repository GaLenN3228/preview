import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';

class AAudioPlayer extends StatefulWidget {
  final String url;

  AAudioPlayer({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AAudioPlayerState(url);
  }
}

class _AAudioPlayerState extends State<AAudioPlayer> {
  String url;
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  bool get _isPlaying => _audioPlayerState == AudioPlayerState.PLAYING;

  _AAudioPlayerState(this.url);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _audioPlayer
      ..onPlayerStateChanged.listen((state) {
        if (!mounted) return;
        _audioPlayerState = state;
        setState(() {});
      });
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 211,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CircleAvatar(
            radius: 105.5,
            backgroundColor: Thm.of(context).lightBackgroundColor,
            child: Image.asset(Assets.engine),
          ),
          _playButton(),
        ],
      ),
    );
  }

  Widget _playButton() {
    VoidCallback onPressed;
    IconData icon;
    //TODO: Заменить иконки
    if (!_isPlaying) {
      icon = Icons.play_arrow;
      onPressed = play;
    } else {
      icon = Icons.pause;
      onPressed = pause;
    }
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 11.0,
        right: 12.0,
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Tappable(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Thm.of(context).accentColor,
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: Thm.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future play() async {
    await _audioPlayer.play(url);
  }

  Future pause() async {
    await _audioPlayer.pause();
  }
}
