import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:porsche_app/app/data/models/doc_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/feature/docs/doc/doc_item.dart';
import 'package:porsche_app/app/presentation/feature/docs/doc/doc_store.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';

class PhotoPage extends StatelessWidget {
  final DocStore store;
  final FileType type;

  const PhotoPage({
    Key key,
    this.store,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    final bool isDocNotDraft = store.fileStatus != FileStatus.draft;
    switch (type) {
      case FileType.passport_page_one:
      case FileType.passport_page_two:
        appBarTitle = S.of(context).passportPhoto;
        break;
      case FileType.driver_license_front:
      case FileType.driver_license_rear:
        appBarTitle = S.of(context).driverLicense;
        break;
      case FileType.face_driver_license:
        appBarTitle = S.of(context).photoWithTheDocument;
        break;
    }
    return AScaffold(
      appBar: AAppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              appBarTitle,
            ),
          ),
        ),
        leadingIcon: Container(),
        trailingIcon: Tappable(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 30.0,
            ),
            child: Icon(
              AIcons.close,
              size: 15.0,
            ),
          ),
        ),
        isCenterTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: isDocNotDraft
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: <Widget>[
          if (isDocNotDraft) ...[
            Tappable(
              onTap: () {
                if (store.file != null) {
                  store.update(null);
                } else if (store.attachFile != null) {
                  store.deleteDoc();
                }
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 26.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      S.of(context).deletePhoto,
                      style: Thm.of(context).bodySecondary,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Icon(
                      AIcons.trash,
                      size: 20.0,
                      color: Thm.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
          _image(),
          if (isDocNotDraft) ...[
            AButton.secondary(
              text: S.of(context).replaceDocument,
              isBottom: true,
              onPressed: () async {
                final data = await showModalBottomSheet<File>(
                  context: context,
                  builder: (_) => CategoryBottomSheet(),
                );
                if (data != null) {
                  store.update(data);
                }
              },
            )
          ],
        ],
      ),
    );
  }

  Widget _image() {
    return Observer(builder: (_) {
      if (store.file != null) {
        return Image.file(store.file);
      } else if (store.attachFile != null) {
        return Image.network(store.attachFile);
      } else {
        return Container();
      }
    });
  }
}
