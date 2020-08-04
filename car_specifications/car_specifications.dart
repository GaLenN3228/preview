import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porsche_app/app/data/models/car_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_expansion_tile.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/car_spec_info_short.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/app/util/specification_group.dart';
import 'package:porsche_app/generated/l10n.dart';

class CarSpecificationPage extends StatefulWidget {
  CarSpecificationPage({Key key, @required this.carSpecification})
      : super(key: key);
  final Car carSpecification;

  @override
  _CarSpecificationPageState createState() => _CarSpecificationPageState();
}

class _CarSpecificationPageState extends State<CarSpecificationPage> {
  @override
  Widget build(BuildContext context) {
    return AScaffold(
        appBar: AAppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              Assets.carModelNameToolbar(widget.carSpecification.assetId),
            ),
          ),
          isCenterTitle: false,
          leadingIcon: SizedBox(width: 30.0),
          trailingIcon: Tappable(
            padding: EdgeInsets.symmetric(
              horizontal: 23.0,
              vertical: 15.0,
            ),
            child: Icon(
              AIcons.close,
              size: 14.0,
            ),
            onTap: () {
              ExtendedNavigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  _appSpecifications(),
                  _specList(),
                ],
              ),
            )
          ],
        ));
  }

  Widget _specList() {
    final specs = widget.carSpecification.specifications
        .where((item) => item.alias != 'short' && item.alias != 'main')
        .toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AExpansionTile(
              contentPadding: EdgeInsets.only(bottom: 30),
              headerPadding: EdgeInsets.symmetric(vertical: 30),
              title: Text(
                '${specs[index].name}',
                style: Thm.of(context).mainBtnText,
              ),
              children: <Widget>[
                Container(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: specs[index].options.length,
                    itemBuilder: (context, _index) {
                      return _carSpecificationsBody(index, _index, specs);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        childCount: specs.length,
      ),
    );
  }

  Widget _carSpecificationsBody(int index, int _index, List specs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            '${specs[index].options[_index].value} '
            '${specs[index].options[_index].measureUnit ?? ''}',
            style: Thm.of(context).specValue,
          ),
        ),
        Container(
          child: Text(
            '${specs[index].options[_index].name}',
            style: Thm.of(context)
                .captionSecondary
                .copyWith(color: Thm.of(context).secondaryDarker50Color),
          ),
        ),
      ],
    );
  }

  Widget _appSpecifications() {
    final Specification specification =
        SpecificationsGroup.mainSpecification(widget.carSpecification);
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 54.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              S.of(context).allSpecifications,
              style: Thm.of(context).heading1Primary,
            ),
          ),
          Image.asset(
            Assets.carSpecs(widget.carSpecification.assetId),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 29.0),
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: specification.options
                  .map((e) => CarSpecInfoShort(
                        option: e,
                        mainAxisAlignment: MainAxisAlignment.center,
                        specNameTextStyle:
                            Thm.of(context).captionSecondary.copyWith(
                                  color: Thm.of(context).secondaryDarker50Color,
                                ),
                      ))
                  .toList(),
              childAspectRatio: 120.0 / 46.0,
            ),
          )
        ],
      ),
    );
  }
}
