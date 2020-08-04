import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/cars_store.dart';
import 'package:porsche_app/app/data/domain/deals_store.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/components/a/a_loading_indicator.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/network_error_widget.dart';
import 'package:porsche_app/app/presentation/components/status_deal.dart';
import 'package:porsche_app/app/presentation/feature/deals/active/active_deals_store.dart';
import 'package:porsche_app/app/presentation/feature/deals/deals_list.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import 'package:porsche_app/main.dart';
import '../../../resources/icons.dart';

class ActiveDealsPage extends StatefulWidget {
  const ActiveDealsPage({
    Key key,
  }) : super(key: key);

  @override
  _ActiveDealsPageState createState() => _ActiveDealsPageState();
}

class _ActiveDealsPageState extends State<ActiveDealsPage> {
  final ActiveDealsStore _activeDealsStore = getIt();
  final double _indicatorSize = 30.0;

  @override
  void initState() {
    super.initState();
    _activeDealsStore.fetchDeals();
  }

  @override
  Widget build(BuildContext context) {
    return AScaffold(
      appBar: AAppBar(
        isCenterTitle: false,
        title: Text(
          S.of(context).myDeals,
          style: Thm.of(context).toolbarTitle,
        ),
        trailingIcon: Tappable(
          onTap: () {
            ExtendedNavigator.of(context).pushPreviousDealsPage();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      S.of(context).history,
                      style: Thm.of(context).captionPrimary,
                    )),
                Icon(
                  AIcons.finish,
                  size: 15,
                  color: Thm.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
      body: Observer(
        builder: (context) {
          return _activeDealsStore.deals.matchValue(
            hasValue: (dealsValue) => DealsList(
              deals: _activeDealsStore.deals,
              retry: _activeDealsStore.fetchDeals,
            ),
            pending: () => Center(
              child: SizedBox(
                child: ALoadingIndicator.light(),
                height: _indicatorSize,
                width: _indicatorSize,
              ),
            ),
            rejected: (dynamic e) => NetworkErrorWidget(
              onPressed: _activeDealsStore.fetchDeals,
            ),
          );
        },
      ),
    );
  }
}
