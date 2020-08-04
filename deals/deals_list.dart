import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/a_observable_future/a_observable_future.dart';
import 'package:porsche_app/app/data/domain/cars_store.dart';
import 'package:porsche_app/app/data/models/deal_model.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/components/a/a_loading_indicator.dart';
import 'package:porsche_app/app/presentation/components/a_refresh_indicator.dart';
import 'package:porsche_app/app/presentation/components/network_error_widget.dart';
import 'package:porsche_app/app/presentation/components/status_deal.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import 'package:porsche_app/main.dart';

class DealsList extends StatefulWidget {
  final AObservableFuture<ObservableList<Deal>> deals;
  final RefreshCallback retry;

  const DealsList({
    Key key,
    @required this.deals,
    @required this.retry,
  }) : super(key: key);

  @override
  _DealsListState createState() => _DealsListState();
}

class _DealsListState extends State<DealsList> {
  final CarsStore _carsStore = getIt();
  final double _indicatorSize = 30.0;

  @override
  Widget build(BuildContext context) {
    if (!widget.deals.value.isNullOrEmpty) {
      return ARefreshIndicator(
        onRefresh: widget.retry,
        child: ListView.builder(
          itemCount: widget.deals.value.length,
          padding: EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final deal = widget.deals.value[index];
            final car = _carsStore.getCar(deal.carId);

            return Column(
              children: <Widget>[
                Tappable(
                  onTap: () {
                    ExtendedNavigator.of(context).pushDealPage(deal: deal);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 30),
                    color: Thm.of(context).backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Observer(builder: (context) {
                                return StatusDeal(
                                    state:
                                    widget.deals.value[index].status);
                              }),
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  '${car.model}',
                                  maxLines: 1,
                                  style: Thm.of(context).heading1Primary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AIcons.calendar,
                                      size: 12,
                                      color: Thm.of(context).primaryColor,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(left: 7),
                                        child: Text(
                                            '${timeFormat(widget.deals.value[index].periodStart, widget.deals.value[index].periodEnd)}'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(Assets.carDeal(car.assetId)))
                      ],
                    ),
                  ),
                ),
                ADivider(),
              ],
            );
          }
        ),
      );
    } else {
      return _EmptyPage(
        retry: widget.retry,
      );
    }
  }

  String timeFormat(int dateStart, int dateEnd) =>
      '${DateFormat('d MMMM hh:mm').format(DateTime.fromMillisecondsSinceEpoch(dateStart * 1000))} - ${DateFormat('d MMMM hh:mm').format(DateTime.fromMillisecondsSinceEpoch(dateEnd * 1000))}';
}

class _EmptyPage extends StatelessWidget {
  final VoidCallback retry;

  const _EmptyPage({Key key, this.retry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.asset(Assets.emptyDeal,
                          color: Thm.of(context).accentColor)),
                  ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return RadialGradient(
                          radius: 6,
                          colors: <Color>[
                            Thm.of(context).backgroundColor.withOpacity(0.0),
                            Thm.of(context).backgroundColor,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.multiply,
                      child: Column(
                        children: <Widget>[
                          Text(
                            S.of(context).emptyDealTitle,
                            style: Thm.of(context).heading1Primary,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            S.of(context).toMainScreen,
                            style: Thm.of(context).bodySecondary,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            AButton.main(
              text: 'Выбор автомобиля',
              isBottom: true,
              isArrowed: false,
              onPressed: () {
                ExtendedNavigator.of(context).pushCarsPage();
              },
            ),
          ],
        ),
        ARefreshIndicator(
          onRefresh: () async {
            retry();
          },
          child: ListView(),
        ),
      ],
    );
  }
}
