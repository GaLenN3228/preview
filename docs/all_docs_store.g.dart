// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_docs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AllDocsStore on AllDocsStoreBase, Store {
  Computed<bool> _$isValidToLoadComputed;

  @override
  bool get isValidToLoad =>
      (_$isValidToLoadComputed ??= Computed<bool>(() => super.isValidToLoad,
              name: 'AllDocsStoreBase.isValidToLoad'))
          .value;
  Computed<bool> _$isAcceptedComputed;

  @override
  bool get isAccepted =>
      (_$isAcceptedComputed ??= Computed<bool>(() => super.isAccepted,
              name: 'AllDocsStoreBase.isAccepted'))
          .value;
  Computed<bool> _$isDraftComputed;

  @override
  bool get isDraft => (_$isDraftComputed ??=
          Computed<bool>(() => super.isDraft, name: 'AllDocsStoreBase.isDraft'))
      .value;
  Computed<bool> _$isNotErrorComputed;

  @override
  bool get isNotError =>
      (_$isNotErrorComputed ??= Computed<bool>(() => super.isNotError,
              name: 'AllDocsStoreBase.isNotError'))
          .value;

  final _$statusAtom = Atom(name: 'AllDocsStoreBase.status');

  @override
  Status get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(Status value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$uploadDocsAsyncAction = AsyncAction('AllDocsStoreBase.uploadDocs');

  @override
  Future<void> uploadDocs() {
    return _$uploadDocsAsyncAction.run(() => super.uploadDocs());
  }

  @override
  String toString() {
    return '''
status: ${status},
isValidToLoad: ${isValidToLoad},
isAccepted: ${isAccepted},
isDraft: ${isDraft},
isNotError: ${isNotError}
    ''';
  }
}
