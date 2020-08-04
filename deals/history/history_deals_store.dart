import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/a_observable_future/a_observable_future.dart';
import 'package:porsche_app/app/data/domain/deals_store.dart';
import 'package:porsche_app/app/data/models/deal_model.dart';
import 'package:porsche_app/app/data/repository/porsche_api.dart';
import 'package:porsche_app/app/ext/ext.dart';
import 'package:porsche_app/app/presentation/feature/deals/deal_list_page_store.dart';
import 'package:porsche_app/main.dart';

part 'history_deals_store.g.dart';

@injectable
class HistoryDealsStore = HistoryDealsStoreBase with _$HistoryDealsStore;

abstract class HistoryDealsStoreBase extends DealListPageStore with Store {
  HistoryDealsStoreBase(PorscheApi api, DealsStore dealsStore)
      : super(api, dealsStore);

  @override
  Future<DealResponse> dealsQuery() => api.fetchHistoryDeals();
}
