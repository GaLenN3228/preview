import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/auth_store.dart';
import 'package:porsche_app/app/data/models/doc_models.dart';
import 'package:porsche_app/app/data/repository/porsche_api.dart';
import 'package:porsche_app/main.dart';

part 'doc_store.g.dart';

@injectable
class DocStore = DocStoreBase with _$DocStore;

abstract class DocStoreBase with Store {
  final PorscheApi _api;
  final AuthStore _authStore;

  DocStoreBase(this._api, this._authStore);

  @observable
  bool isLoading = false;

  @observable
  Exception error;


  @observable
  File file;

  @observable
  FileStatus fileStatus;

  @observable
  DocResponse docResponse;

  @observable
  int percent = 0;

  @computed
  bool get isValid => file != null || attachFile != null;

  @observable
  FileType fileType;

  @observable
  String attachFile;

  @observable
  String comment;

  @action
  void fetchPercent() {
    percent = 0;
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (percent >= 100) {
        timer.cancel();
      } else {
        percent += 5;
      }
    });
  }

  @action
  Future<void> uploadDoc() async {
    if(attachFile==null) {
      fileStatus ??= FileStatus.empty;
    }
    if (!isLoading && fileStatus == FileStatus.readyToUpload) {
      try {
        error = null;
        isLoading = true;
        fetchPercent();
        docResponse =
            await _api.uploadFile(fileType.toString().split('.')[1], file);
        fileStatus = docResponse.status;
        comment = docResponse.comment;
        attachFile = docResponse.file;
        file = null;
        logger.d('File - $file');
        logger.d(docResponse);
      } on DioError catch (e) {
        error = e.error;
        logger.e(error);
      }
      isLoading = false;
    }
  }

  @action
  Future<void> deleteDoc() async {
    try {
      error = null;
      await _api.deleteFile(
        docResponse.id,
        DocRemove(
          type: fileType.toString().split('.')[1],
          upload: attachFile,
        ),
      );
      attachFile = null;
      fileStatus = null;
    } on DioError catch (e) {
      error = e.error;
      logger.e(error);
    }
  }

  @action
  FileStatus validateItem(File file) {
    if (file != null) {
      return FileStatus.readyToUpload;
    } else {
      return null;
    }
  }

  @action
  void update(File file) {
    this.file = file;
    fileStatus = validateItem(file);
  }

  @action
  void fetchAttachFile() {
    if (_authStore.isAuthorized) {
      _authStore.profile.value.documents.map((e) {
        if (e.type == fileType) {
          docResponse = e;
        }
        return e;
      }).toList();
      if (docResponse != null) {
        attachFile = docResponse.file;
        fileStatus = docResponse.status;
        comment = docResponse.comment;
      }
    }
  }
}
