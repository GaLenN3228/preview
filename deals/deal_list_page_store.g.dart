// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_list_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DealListPageStore on DealListPageBaseStore, Store {
  Computed<AObservableFuture<ObservableList<Deal>>> _$dealsComputed;

  @override
  AObservableFuture<ObservableList<Deal>> get deals => (_$dealsComputed ??=
          Computed<AObservableFuture<ObservableList<Deal>>>(() => super.deals,
              name: 'DealListPageBaseStore.deals'))
      .value;

  final _$_dealIdsAtom = Atom(name: 'DealListPageBaseStore._dealIds');

  @override
  AObservableFuture<ObservableList<int>> get _dealIds {
    _$_dealIdsAtom.reportRead();
    return super._dealIds;
  }

  @override
  set _dealIds(AObservableFuture<ObservableList<int>> value) {
    _$_dealIdsAtom.reportWrite(value, super._dealIds, () {
      super._dealIds = value;
    });
  }

  final _$DealListPageBaseStoreActionController =
      ActionController(name: 'DealListPageBaseStore');

  @override
  Future<DealResponse> fetchDeals() {
    final _$actionInfo = _$DealListPageBaseStoreActionController.startAction(
        name: 'DealListPageBaseStore.fetchDeals');
    try {
      return super.fetchDeals();
    } finally {
      _$DealListPageBaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
deals: ${deals}
    ''';
  }
}
