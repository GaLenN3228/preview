import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porsche_app/app/data/domain/cars_store.dart';
import 'package:porsche_app/app/data/domain/deal_draft/deal_draft_store.dart';
import 'package:porsche_app/app/data/models/car_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/components/a/a_expansion_tile.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/car_color_provider.dart';
import 'package:porsche_app/app/presentation/components/car_spec_info_short.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/feature/car_details/design_media_part.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/app/util/specification_group.dart';
import 'package:porsche_app/app/util/string_util.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:porsche_app/app/ext/ext.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({Key key, this.car}) : super(key: key);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final AutoScrollController _controller = AutoScrollController();
  final CarsStore carsStore = getIt();
  final ValueKey _idea = ValueKey<int>(0);
  final ValueKey _design = ValueKey<int>(1);
  final ValueKey _specifications = ValueKey<int>(2);
  final ValueKey _equipment = ValueKey<int>(3);

  @override
  Widget build(BuildContext context) {
    return AScaffold(
      appBar: AAppBar(
        isCenterTitle: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                Assets.carModelNameToolbar(widget.car.assetId),
                height: 13,
              ),
              if (!widget.car.prices.isNullOrEmpty) ...[
                SizedBox(height: 5.0),
                Text(
                  S.of(context).fromPricePerDay(
                      formatPrice(widget.car.prices.first.price)),
                  style: Thm.of(context).captionSecondary,
                ),
              ]
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              _navigationOnScreen(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    bottom: 50.0,
                  ),
                  child: CarColorProvider(
                    assetId: widget.car.assetId,
                  ),
                ),
              ),
              _ideaItem(),
              SliverToBoxAdapter(child: SizedBox(height: 30,)),
              _designItem(),
              SliverToBoxAdapter(child: SizedBox(height: 30,)),
              _specificationsItem(),
              SliverToBoxAdapter(child: SizedBox(height: 30,)),
              ..._equipmentItem(),
              _footer(),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 60,
              )),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AButton.accent(
              isBottom: true,
              text: S.of(context).resume,
              onPressed: () {
                getIt<DealDraftStore>().resetDraft(widget.car);
                ExtendedNavigator.of(context).pushAdditionalEquipmentPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationOnScreen() => SliverToBoxAdapter(
        child: Stack(
          children: <Widget>[
            Image.asset(
              Assets.carTitle(widget.car.assetId),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 28.0),
                  _itemNavigation(S.of(context).idea, () {
                    _controller.scrollToIndex(0,
                        preferPosition: AutoScrollPosition.begin);
                  }),
                  SizedBox(height: 2.0),
                  _itemNavigation(S.of(context).design, () {
                    _controller.scrollToIndex(1,
                        preferPosition: AutoScrollPosition.begin);
                  }),
                  SizedBox(height: 2.0),
                  _itemNavigation(S.of(context).specifications, () {
                    _controller.scrollToIndex(2,
                        preferPosition: AutoScrollPosition.begin);
                  }),
                  SizedBox(height: 2.0),
                  _itemNavigation(S.of(context).equipment, () {
                    _controller.scrollToIndex(3,
                        preferPosition: AutoScrollPosition.begin);
                  }),
                ],
              ),
            )
          ],
        ),
      );

  Widget _itemNavigation(String title, VoidCallback onTap) => Tappable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                title,
                style: Thm.of(context).bodySecondary,
              ),
              SizedBox(
                width: 10.0,
              ),
              Icon(
                AIcons.arrow_left,
                size: 9.0,
                color: Thm.of(context).secondaryColor,
              ),
            ],
          ),
        ),
      );

  Widget _ideaItem() => SliverToBoxAdapter(
        child: AutoScrollTag(
          index: 0,
          controller: _controller,
          key: _idea,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  Assets.carIdea(widget.car.assetId),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 149.0,
                  top: 84.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      S.of(context).ideaWithModel(widget.car.model),
                      style: Thm.of(context).heading1Primary,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      widget.car.idea,
                      style: Thm.of(context).bodySecondaryHeight22,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _designItem() => SliverToBoxAdapter(
        child: AutoScrollTag(
          index: 1,
          controller: _controller,
          key: _design,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 149.0,
                  top: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      S.of(context).design,
                      style: Thm.of(context).heading1Primary,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      widget.car.design,
                      style: Thm.of(context).bodySecondaryHeight22,
                    ),
                    SizedBox(height: 21.0),
                  ],
                ),
              ),
              DesignMediaPart(
                carMedia: widget.car.media,
              ),
            ],
          ),
        ),
      );

  Widget _specificationsItem() => SliverToBoxAdapter(
        child: AutoScrollTag(
          index: 2,
          key: _specifications,
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  S.of(context).specifications,
                  style: Thm.of(context).heading1Primary,
                ),
              ),
              Image.asset(
                Assets.carSpecs(widget.car.assetId),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50.0),
              _itemShortInfo(),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: AButton.outlined(
                      text: 'Узнать больше',
                      onPressed: () {
                        ExtendedNavigator.of(context).pushCarSpecificationPage(
                            carSpecification: widget.car);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _itemShortInfo() {
    final Specification specification =
        SpecificationsGroup.mainSpecification(widget.car);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: specification.options
          .map((e) => Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: CarSpecInfoShort(
                  option: e,
                  mainAxisAlignment: MainAxisAlignment.start,
                  specNameTextStyle: Thm.of(context).captionSecondary.copyWith(
                        color: Thm.of(context).secondaryDarker50Color,
                      ),
                ),
              ))
          .toList(),
      childAspectRatio: 120.0 / 46.0,
    );
  }

  List<Widget> _equipmentItem() => [
        SliverToBoxAdapter(
          child: AutoScrollTag(
            index: 3,
            controller: _controller,
            key: _equipment,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    S.of(context).equipment,
                    style: Thm.of(context).heading1Primary,
                  ),
                ),
                Image.asset(
                  Assets.carEquipment(widget.car.assetId),
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final equipment = widget.car.equipments[index];
              return AExpansionTile(
                headerPadding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                contentPadding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  bottom: 10.0,
                ),
                dividerOnContent: DividerTile.bottom,
                title: Text(
                  equipment.name,
                  style: Thm.of(context).bodySecondary,
                ),
                children: equipment.values.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      item,
                      style: Thm.of(context).bodySecondary,
                      textAlign: TextAlign.left,
                    ),
                  );
                }).toList(),
              );
            },
            childCount: widget.car.equipments.length,
          ),
        ),
      ];

  Widget _footer() => SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            SizedBox(height: 60),
            Column(
              children: carsStore.cars.value
                  .where((element) => element.assetId != widget.car.assetId)
                  .map((e) => _footerTapItem(e))
                  .toList(),
            ),
          ],
        ),
      );

  Widget _footerTapItem(Car car) => Tappable(
        onTap: () {
          ExtendedNavigator.of(context).pop();
          ExtendedNavigator.of(context).pushCarDetailsPage(car: car);
        },
        child: Column(
          children: <Widget>[
            ADivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    Assets.carModelNameMenu(car.assetId),
                    height: 26.0,
                  ),
                  Icon(
                    AIcons.arrow_right,
                    size: 13,
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
