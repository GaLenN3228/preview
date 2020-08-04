// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DocStore on DocStoreBase, Store {
  Computed<bool> _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??=
          Computed<bool>(() => super.isValid, name: 'DocStoreBase.isValid'))
      .value;

  final _$isLoadingAtom = Atom(name: 'DocStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$errorAtom = Atom(name: 'DocStoreBase.error');

  @override
  Exception get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Exception value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$fileAtom = Atom(name: 'DocStoreBase.file');

  @override
  File get file {
    _$fileAtom.reportRead();
    return super.file;
  }

  @override
  set file(File value) {
    _$fileAtom.reportWrite(value, super.file, () {
      super.file = value;
    });
  }

  final _$fileStatusAtom = Atom(name: 'DocStoreBase.fileStatus');

  @override
  FileStatus get fileStatus {
    _$fileStatusAtom.reportRead();
    return super.fileStatus;
  }

  @override
  set fileStatus(FileStatus value) {
    _$fileStatusAtom.reportWrite(value, super.fileStatus, () {
      super.fileStatus = value;
    });
  }

  final _$docResponseAtom = Atom(name: 'DocStoreBase.docResponse');

  @override
  DocResponse get docResponse {
    _$docResponseAtom.reportRead();
    return super.docResponse;
  }

  @override
  set docResponse(DocResponse value) {
    _$docResponseAtom.reportWrite(value, super.docResponse, () {
      super.docResponse = value;
    });
  }

  final _$percentAtom = Atom(name: 'DocStoreBase.percent');

  @override
  int get percent {
    _$percentAtom.reportRead();
    return super.percent;
  }

  @override
  set percent(int value) {
    _$percentAtom.reportWrite(value, super.percent, () {
      super.percent = value;
    });
  }

  final _$fileTypeAtom = Atom(name: 'DocStoreBase.fileType');

  @override
  FileType get fileType {
    _$fileTypeAtom.reportRead();
    return super.fileType;
  }

  @override
  set fileType(FileType value) {
    _$fileTypeAtom.reportWrite(value, super.fileType, () {
      super.fileType = value;
    });
  }

  final _$attachFileAtom = Atom(name: 'DocStoreBase.attachFile');

  @override
  String get attachFile {
    _$attachFileAtom.reportRead();
    return super.attachFile;
  }

  @override
  set attachFile(String value) {
    _$attachFileAtom.reportWrite(value, super.attachFile, () {
      super.attachFile = value;
    });
  }

  final _$commentAtom = Atom(name: 'DocStoreBase.comment');

  @override
  String get comment {
    _$commentAtom.reportRead();
    return super.comment;
  }

  @override
  set comment(String value) {
    _$commentAtom.reportWrite(value, super.comment, () {
      super.comment = value;
    });
  }

  final _$uploadDocAsyncAction = AsyncAction('DocStoreBase.uploadDoc');

  @override
  Future<void> uploadDoc() {
    return _$uploadDocAsyncAction.run(() => super.uploadDoc());
  }

  final _$deleteDocAsyncAction = AsyncAction('DocStoreBase.deleteDoc');

  @override
  Future<void> deleteDoc() {
    return _$deleteDocAsyncAction.run(() => super.deleteDoc());
  }

  final _$DocStoreBaseActionController = ActionController(name: 'DocStoreBase');

  @override
  void fetchPercent() {
    final _$actionInfo = _$DocStoreBaseActionController.startAction(
        name: 'DocStoreBase.fetchPercent');
    try {
      return super.fetchPercent();
    } finally {
      _$DocStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  FileStatus validateItem(File file) {
    final _$actionInfo = _$DocStoreBaseActionController.startAction(
        name: 'DocStoreBase.validateItem');
    try {
      return super.validateItem(file);
    } finally {
      _$DocStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void update(File file) {
    final _$actionInfo =
        _$DocStoreBaseActionController.startAction(name: 'DocStoreBase.update');
    try {
      return super.update(file);
    } finally {
      _$DocStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fetchAttachFile() {
    final _$actionInfo = _$DocStoreBaseActionController.startAction(
        name: 'DocStoreBase.fetchAttachFile');
    try {
      return super.fetchAttachFile();
    } finally {
      _$DocStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
file: ${file},
fileStatus: ${fileStatus},
docResponse: ${docResponse},
percent: ${percent},
fileType: ${fileType},
attachFile: ${attachFile},
comment: ${comment},
isValid: ${isValid}
    ''';
  }
}
