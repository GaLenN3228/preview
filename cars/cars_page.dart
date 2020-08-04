import 'dart:math' as math;
import 'dart:math';

import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:porsche_app/app/data/domain/cars_store.dart';
import 'package:porsche_app/app/data/models/car_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_drawer.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/car_spec_info_short.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/app/util/composite_disposable_mixin.dart';
import 'package:porsche_app/app/util/specification_group.dart';
import 'package:porsche_app/app/util/string_util.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';
import 'package:porsche_app/app/ext/ext.dart';
import 'package:porsche_app/main.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CarsPage extends StatefulWidget {
  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> with CompositeDisposableMixin {
  AutoScrollController scrollController;
  PageController pageController;

  final CarsStore carsStore = getIt();

  int position = 0;
  bool pageViewNotScroll = true;
  GlobalKey<ADrawerState> keyMenu = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(2.0.seconds,
            () => firebaseMessaging.requestNotificationPermissions);

    scrollController = AutoScrollController().disposeWith(this);
    pageController = PageController().disposeWith(this)
      ..addListener(() {

        position = pageController.page.round();
        scrollController.scrollToIndex(position,
          duration: 100.milliseconds,
          preferPosition: AutoScrollPosition.middle,
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return AScaffold(
      resizeToAvoidBottomPadding: false,
      drawer: ADrawer(
        key: keyMenu,
//        mode: ADrawerMode.user,
//        bookingCount: 2,
      ),
      appBar: AAppBar(
        leadingIcon: null,
        isCenterTitle: false,
        backgroundColor: Thm.of(context).transparent,
        withDivider: false,
        isShowLeading: false,
        onDrawerOpen: () {
          keyMenu.currentState.open();
        },
        title: Tappable(
          onTap: () {
            ExtendedNavigator.of(context).pushDevPage();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Image.asset(
                Assets.toolbarLogo,
                height: 60.0,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _images(),
          Container(
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Thm.of(context).backgroundColor,
                  Thm.of(context).backgroundColor.withOpacity(0.0),
                  Thm.of(context).backgroundColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _shortInfoAboutCar(carsStore.cars.value[position]),
              ),
              _bottomListView(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _images() => NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            pageViewNotScroll = false;
          } else if (scrollNotification is ScrollUpdateNotification) {
            pageViewNotScroll = false;
          } else if (scrollNotification is ScrollEndNotification) {
            pageViewNotScroll = true;
          }
          return true;
        },
        child: PageView.builder(
          controller: pageController,
          physics: ClampingScrollPhysics(),
          itemBuilder: (_, i) => AnimatedOpacity(
            opacity: pageViewNotScroll ? 1.0 : 0.5,
            duration: Duration(milliseconds: 100),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  Assets.carHomeImage(carsStore.cars.value[i].assetId),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                /*PlayAnimation(
                  tween: 0.0.tweenTo(0.6),
                  duration: 1.0.seconds,
                  delay: 1.0.seconds,
                  curve: HeadlightCurve(),
                  builder: (context, child, double value) {
                    logger.d(value);
                    return AnimatedOpacity(
                      opacity: min(value, 1.0),
                      child: child,
                      duration: 100.milliseconds,
                    );
                  },
                  child: Image.asset(
                    Assets.carHeadlight(carsStore.cars.value[i].assetId),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),*/
              ],
            ),
          ),
          itemCount: carsStore.cars.value.length,
        ),
      );

  Widget _bottomListView() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) => AutoScrollTag(
                    key: ValueKey(i),
                    index: i,
                    controller: scrollController,
                    child: Tappable(
                      pressedOpacity: 1.0,
                      onTap: () {
                        pageController.animateToPage(
                          i,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 15.0,
                        ),
                        child: Container(
                          decoration: position == i
                              ? BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Thm.of(context).primaryColor,
                                      width: 1.0,
                                    ),
                                  ),
                                )
                              : BoxDecoration(),
                          child: Text(
                            carsStore.cars.value[i].model.toUpperCase(),
                            style: position == i
                                ? Thm.of(context).heading2Primary
                                : Thm.of(context).heading2Secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemCount: carsStore.cars.value.length,
                  separatorBuilder: (_, i) => SizedBox(
                    width: 14.0,
                  ),
                ),
              ),
            ),
          )
        ],
      );

  Widget _shortInfoAboutCar(Car car) => AnimatedOpacity(
        opacity: pageViewNotScroll ? 1.0 : 0.0,
        curve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            top: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IgnorePointer(
                    ignoring: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          Assets.carModelNameHome(car.assetId),
                          height: 40.0,
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          !car.prices.isNullOrEmpty
                              ? S.of(context).fromPricePerDay(
                                formatPrice(car.prices.first.price),
                              )
                              : '',
                          style: Thm.of(context).bodySecondary,
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AButton.small(
                        text: S.of(context).book,
                        onPressed: () => ExtendedNavigator.of(context)
                            .pushCarDetailsPage(car: car),
                      ),
                    ],
                  )
                ],
              ),
              IgnorePointer(
                ignoring: true,
                child: _carSpecShortInfo(car),
              )
            ],
          ),
        ),
      );

  Widget _carSpecShortInfo(Car car) {
    final specification = SpecificationsGroup.shortSpecification(car);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => CarSpecInfoShort(
        option: specification.options[i],
      ),
      itemCount: specification.options.length,
      separatorBuilder: (_, i) => SizedBox(height: 18.0),
    );
  }
}

class HeadlightCurve extends Curve {
  const HeadlightCurve();

  @override
  double transformInternal(double t) {
    return 2 * math.pow(t, 0.5) - 2 * max(0, t - 0.5);
  }
}
