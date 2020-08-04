import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/a_observable_future/a_observable_future.dart';
import 'package:porsche_app/app/data/domain/deals_store.dart';
import 'package:porsche_app/app/data/models/deal_model.dart';
import 'package:porsche_app/app/data/repository/porsche_api.dart';
import 'package:porsche_app/app/ext/ext.dart';
import 'package:porsche_app/app/presentation/feature/deals/deal_list_page_store.dart';
import 'package:porsche_app/main.dart';

part 'active_deals_store.g.dart';

@injectable
class ActiveDealsStore = ActiveDealsStoreBase with _$ActiveDealsStore;

abstract class ActiveDealsStoreBase extends DealListPageStore with Store {
  ActiveDealsStoreBase(PorscheApi api, DealsStore dealsStore)
      : super(api, dealsStore);

  @override
  Future<DealResponse> dealsQuery() => api.fetchActiveDeals();
}
