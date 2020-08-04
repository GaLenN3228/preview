import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/deals_store.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_loading_indicator.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/network_error_widget.dart';
import 'package:porsche_app/app/presentation/components/status_deal.dart';
import 'package:porsche_app/app/presentation/feature/deals/deals_list.dart';
import 'package:porsche_app/app/presentation/feature/deals/history/history_deals_store.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import '../../../resources/icons.dart';

class HistoryDealsPage extends StatefulWidget {
  const HistoryDealsPage({
    Key key,
  }) : super(key: key);

  @override
  _HistoryDealsPageState createState() => _HistoryDealsPageState();
}

class _HistoryDealsPageState extends State<HistoryDealsPage> {
  final HistoryDealsStore _historyDealsStore = getIt();
  final double _indicatorSize = 30.0;

  @override
  void initState() {
    _historyDealsStore.fetchDeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AScaffold(
      appBar: AAppBar(
        title: Text(
          S.of(context).history,
          style: Thm.of(context).toolbarTitle,
        ),
      ),
      body: Observer(
        builder: (context) => _historyDealsStore.deals.matchValue(
          hasValue: (dealsValue) => DealsList(
            deals: _historyDealsStore.deals,
            retry: _historyDealsStore.fetchDeals,
          ),
          pending: () => Center(
            child: SizedBox(
              child: ALoadingIndicator.light(),
              height: _indicatorSize,
              width: _indicatorSize,
            ),
          ),
          rejected: (dynamic e) => NetworkErrorWidget(
            onPressed: _historyDealsStore.fetchDeals,
          ),
        ),
      ),
    );
  }
}
