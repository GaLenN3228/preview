import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/a_observable_future/a_observable_future.dart';
import 'package:porsche_app/app/data/domain/deals_store.dart';
import 'package:porsche_app/app/data/models/deal_model.dart';
import 'package:porsche_app/app/data/repository/porsche_api.dart';
import 'package:porsche_app/app/ext/ext.dart';
import 'package:porsche_app/main.dart';

part 'deal_list_page_store.g.dart';

abstract class DealListPageStore = DealListPageBaseStore with _$DealListPageStore;

abstract class DealListPageBaseStore with Store {
  DealListPageBaseStore(this.api, this._dealsStore);

  @protected
  final PorscheApi api;

  final DealsStore _dealsStore;

  @observable
  AObservableFuture<ObservableList<int>> _dealIds;

  @computed
  AObservableFuture<ObservableList<Deal>> get deals =>
    _dealIds.copyWithValue((dealIds) {
      if(dealIds.value == null) {
        return null;
      }else {
        return dealIds.value
            .map((element) => _dealsStore.getDeal(element).value)
            .toObservableList();
      }
    });

  @protected
  Future<DealResponse> dealsQuery();

  @action
  Future<DealResponse> fetchDeals() {
    final query = dealsQuery();

    _dealIds = query.then(
      (value) {
        _dealsStore.updateDeals(value.data);
        return value.data.map((e) => e.id).toObservableList();
      },
    ).replaceObservableFuture(_dealIds);

    return query;
  }
}