import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porsche_app/app/data/models/doc_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/feature/docs/doc/doc_store.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:porsche_app/app/ext/ext.dart';
import 'package:simple_animations/simple_animations.dart';

class DocItem extends StatefulWidget {
  final FileType fileType;

  const DocItem({Key key, this.fileType}) : super(key: key);

  @override
  _DocItemState createState() => _DocItemState();
}

class _DocItemState extends State<DocItem> {
  String title;
  String subtitle;
  DocStore _store;


  @override
  Widget build(BuildContext context) {
    init();
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 29.0,
        ),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            if (_store.fileStatus != FileStatus.draft &&
                (_store.file != null || _store.attachFile != null)) ...[
              IconSlideAction(
                  onTap: () {
                    if (_store.file != null) {
                      _store.update(null);
                    } else if (_store.attachFile != null) {
                      _store.deleteDoc();
                    }
                  },
                  iconWidget: Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(AIcons.trash),
                  ),
                  caption: S.of(context).remove,
                  color: Thm.of(context).accentColor,
                  foregroundColor: Thm.of(context).primaryColor),
            ]
          ],
          child: Tappable(
            onTap: () async {
              if (_store.isValid) {
                ExtendedNavigator.of(context).pushPhotoPage(
                  store: _store,
                  type: widget.fileType,
                );
              } else {
                final data = await showModalBottomSheet<File>(
                  context: context,
                  builder: (_) => CategoryBottomSheet(),
                );
                if (data != null) {
                  _store.update(data);
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Thm.of(context).lightBackgroundColor,
                    border: _store.fileStatus != FileStatus.declined &&
                            _store.fileStatus != FileStatus.empty
                        ? null
                        : Border.all(
                            color: Thm.of(context).accentColor,
                            width: 1.0,
                          ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 19.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              style: Thm.of(context).ghostBtnText,
                            ),
                          ),
                          if (!_store.isValid) ...[
                            Icon(
                              AIcons.doc,
                              size: 15.0,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10.0),
                      if (!_store.isLoading) ...[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                subtitle,
                                style: Thm.of(context).captionSecondaryDarker50,
                              ),
                            ),
                            Text(
                              _store.isValid
                                  ? S.of(context).view
                                  : S.of(context).download,
                              style: Thm.of(context).captionPrimary,
                            )
                          ],
                        ),
                      ],
                      if (_store.isLoading) ...[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _loadIndicator(),
                            ),
                            Text(
                              '${_store.percent}%',
                              style: Thm.of(context).captionPrimary,
                            )
                          ],
                        )
                      ],
                    ],
                  ),
                ),
                if (_store.fileStatus == FileStatus.declined) ...[
                  Container(
                    color: Thm.of(context).accentColor,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 40.0,
                    ),
                    child: Text(
                      _store.comment ?? "Не четкое изображение",
                      textAlign: TextAlign.center,
                      style: Thm.of(context).captionPrimary,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      );
    });
  }

  void init() {
    switch (widget.fileType) {
      case FileType.passport_page_one:
        title = S.of(context).pageTurn(1);
        subtitle = S.of(context).fioAndPhoto;
        break;
      case FileType.passport_page_two:
        title = S.of(context).pageTurn(2);
        subtitle = S.of(context).propiska;
        break;
      case FileType.driver_license_front:
        title = S.of(context).pageSide(1);
        subtitle = S.of(context).categoryTransportManagement;
        break;
      case FileType.driver_license_rear:
        title = S.of(context).pageSide(2);
        subtitle = S.of(context).categoryTransportManagement;
        break;
      case FileType.face_driver_license:
        title = S.of(context).photoOfPersonWithDriverLicense;
        subtitle = S.of(context).driverLicenseInHand;
        break;
    }
    _store = Provider.of<DocStore>(context);
    _store.fileType = widget.fileType;
    _store.fetchAttachFile();
  }

  Widget _loadIndicator() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5.0,
        right: 65.0,
      ),
      child: Container(
        width: double.infinity,
        height: 3.0,
        alignment: Alignment.centerLeft,
        color: Thm.of(context).secondaryDarker50Color,
        child: CustomAnimation<double>(
          tween: 0.0.tweenTo(1.0),
          curve: Curves.easeInOutSine,
          duration: 2.seconds,
          builder: (context, child, value) => FractionallySizedBox(
            widthFactor: value,
            child: child,
          ),
          child: Container(
            height: 3.0,
            color: Thm.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

class CategoryBottomSheet extends StatefulWidget {
  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  CropAspectRatio aspectRatio = CropAspectRatio(ratioX: 1.0, ratioY: 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Thm.of(context).backgroundColor,
      child: IconTheme(
        data: IconThemeData(
          color: Thm.of(context).primaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _toolBar(),
            ADivider(
              color: Thm.of(context).backgroundColor,
            ),
            _categoryItem(
              () async {
                final data =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                if (data != null) {
                  final File file = await _cropImage(data);
                  Navigator.pop(context, file);
                }
              },
              S.of(context).gallery,
            ),
            ADivider(
              color: Thm.of(context).backgroundColor,
            ),
            _categoryItem(
              () async {
                final data =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                if (data != null) {
                  final File file = await _cropImage(data);
                  Navigator.pop(context, file);
                }
              },
              S.of(context).takePhoto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolBar() => Container(
        color: Thm.of(context).lightBackgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 30.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                S.of(context).uploadMethod,
                style: Thm.of(context).mainBtnText,
              ),
            ),
            Tappable(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                AIcons.close,
                size: 15.0,
              ),
            )
          ],
        ),
      );

  Widget _categoryItem(VoidCallback onTap, String title) => Tappable(
        onTap: onTap,
        child: Container(
          color: Thm.of(context).lightBackgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 30.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: Thm.of(context).bodySecondaryHeight22.copyWith(
                        color: Thm.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(
                AIcons.arrow_right,
                size: 12.0,
              )
            ],
          ),
        ),
      );

  Future<File> _cropImage(File imageFile) async {
    return await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: aspectRatio,
        aspectRatioPresets: aspectRatio == null
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [CropAspectRatioPreset.square],
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Thm.of(context).backgroundColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Thm.of(context).accentColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: aspectRatio != null,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: aspectRatio != null,
          aspectRatioPickerButtonHidden: aspectRatio != null,
          doneButtonTitle: S.of(context).done,
          cancelButtonTitle: S.of(context).cancel,
        ));
  }
}
