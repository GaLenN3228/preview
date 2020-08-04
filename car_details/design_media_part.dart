import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porsche_app/app/data/models/car_models.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/feature/car_details/design/audio.dart';
import 'package:porsche_app/app/presentation/feature/car_details/design/video.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/app/ext/ext.dart';

import 'design/images.dart';

enum DesignState {
  photos,
  video,
  audio,
  empty,
}

class DesignMediaPart extends StatefulWidget {
  final CarMedia carMedia;

  const DesignMediaPart({
    @required this.carMedia,
    Key key,
  }) : super(key: key);

  @override
  _DesignMediaPartState createState() => _DesignMediaPartState();
}

class _DesignMediaPartState extends State<DesignMediaPart> {
  DesignState _designState;

  /*String video =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  String audio = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';*/

  bool get isNoVideo => widget.carMedia.video.isNullOrEmpty;

  bool get isNoPhotos => widget.carMedia.images.isNullOrEmpty;

  bool get isNotAudio => widget.carMedia.audio.isNullOrEmpty;

  @override
  void initState() {
    super.initState();
    if (!widget.carMedia.images.isNullOrEmpty) {
      _designState = DesignState.photos;
    } else if (!widget.carMedia.video.isNullOrEmpty) {
      _designState = DesignState.video;
    } else if (!widget.carMedia.audio.isNullOrEmpty) {
      _designState = DesignState.audio;
    } else {
      _designState = DesignState.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_designState != DesignState.empty) ...[
          Container(
            height: 212,
            child: _body(_designState),
          ),
        ],
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _tabs(S.of(context).photo, DesignState.photos, isNoPhotos),
            _tabs(S.of(context).video, DesignState.video, isNoVideo),
            _tabs(S.of(context).audio, DesignState.audio, isNotAudio),
          ],
        ),
      ],
    );
  }

  Widget _tabs(String title, DesignState state, bool isNullOrEmpty) {
    if (isNullOrEmpty) {
      return Container();
    } else {
      return Tappable(
        onTap: () {
          setState(() {
            _designState = state;
          });
        },
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
        child: Text(
          title,
          style: _designState == state
              ? Thm.of(context).bodyPrimaryBold
              : Thm.of(context).bodySecondaryBold,
        ),
      );
    }
  }

  Widget _body(DesignState state) {
    switch (state) {
      case DesignState.photos:
        return isNoPhotos
            ? Container()
            : Images(
                images: widget.carMedia.images.map((e) => e.link).toList());
      case DesignState.video:
        return isNoVideo
            ? Container()
            : AVideo(url: widget.carMedia.video.first.link);
      case DesignState.audio:
        return isNotAudio
            ? Container()
            : AAudioPlayer(url: widget.carMedia.audio.first.link);
      default:
        return Container();
    }
  }
}
