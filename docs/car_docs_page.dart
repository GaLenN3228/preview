import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:porsche_app/app/data/domain/auth_store.dart';
import 'package:porsche_app/app/data/models/profile_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_divider.dart';
import 'package:porsche_app/app/presentation/components/a/a_drawer.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/resources/assets.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';
import 'package:porsche_app/injection.dart';
import 'package:porsche_app/app/ext/ext.dart';

class DocsPage extends StatefulWidget {
  @override
  _DocsPageState createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  GlobalKey<ADrawerState> keyDrawer = GlobalKey<ADrawerState>();
  final AuthStore _authStore = getIt();

  @override
  Widget build(BuildContext context) {
    return AScaffold(
      drawer: ADrawer(key: keyDrawer),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CarRentPageHeader(
                    context,
                    keyDrawer,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CarRentPageBody(),
                )
              ],
            ),
          ),
          Observer(
            builder: (_) => _docs(),
          ),
        ],
      ),
    );
  }

  Widget _docs() {
    Widget icon;
    String subtitle;

    switch(_authStore.profile.value.status) {
      case ProfileStatus.statusNew:
      case ProfileStatus.registered:
        icon = Icon(
          Icons.error,
          color: Thm.of(context).accentColor,
          size: 24.0,
        );
        subtitle = S.of(context).addDocs;
        break;
      case ProfileStatus.verification:
        icon = CircleAvatar(
          radius: 12.0,
          backgroundColor: Thm.of(context).draftColor,
          child: Center(
            child: Icon(
              Icons.autorenew,
              color: Thm.of(context).primaryColor,
              size: 15.0,
            ),
          ),
        );
        subtitle = S.of(context).check;
        break;
      case ProfileStatus.verified:
      case ProfileStatus.penny:
        icon = CircleAvatar(
          radius: 12.0,
          backgroundColor: Thm.of(context).acceptedColor,
          child: Center(
            child: Icon(
              AIcons.done,
              color: Thm.of(context).primaryColor,
              size: 10.0,
            ),
          ),
        );
        subtitle = S.of(context).confirmed;
        break;
      case ProfileStatus.unverified:
        icon = CircleAvatar(
          radius: 12.0,
          backgroundColor: Thm.of(context).accentColor,
          child: Center(
            child: Icon(
              AIcons.attention_3,
              color: Thm.of(context).primaryColor,
              size: 12.0,
            ),
          ),
        );
        subtitle = S.of(context).fillInError;
        break;
    }

    return Tappable(
      onTap: () {
        ExtendedNavigator.of(context).pushAllDocsPage();
      },
      child: Container(
        color: Thm.of(context).lightBackgroundColor,
        padding: EdgeInsets.all(30),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom <= 10
              ? MediaQuery.of(context).padding.bottom / 3.0
              : 0),
          child: Row(
            children: <Widget>[
              icon,
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).docs,
                      style: Thm.of(context).mainBtnText,
                    ),
                    Text(
                      subtitle,
                      style: Thm.of(context).captionSecondary,
                    )
                  ],
                ),
              ),
              Spacer(),
              Icon(AIcons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}

class CarRentPageHeader extends SliverPersistentHeaderDelegate {
  final GlobalKey<ADrawerState> keyDrawer;
  final double height;
  final double statusBarHeight;

  CarRentPageHeader(BuildContext context, this.keyDrawer)
      : height = MediaQuery.of(context).size.width,
        statusBarHeight = MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scrollPercent =
            (maxExtent - constraints.maxHeight) / (maxExtent - minExtent);
        return Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    Assets.carRent,
                    fit: BoxFit.cover,
                    color: Thm.of(context).darkMaskColor,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Thm.of(context).backgroundColor.withOpacity(0.46),
                        Thm.of(context).backgroundColor.withOpacity(0.72),
                        Thm.of(context).backgroundColor.withOpacity(0.93),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: constraints.maxHeight,
              color: Thm.of(context).backgroundColor.withOpacity(scrollPercent),
            ),
            SafeArea(
              bottom: false,
              child: AAppBar(
                backgroundColor: Thm.of(context).transparent,
                onDrawerOpen: keyDrawer.currentState.open,
                trailingIcon: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(AIcons.menu)),
                title: Text(
                  S.of(context).profile,
                  style: Thm.of(context).toolbarTitle,
                ),
                withDivider: false,
              ),
            ),
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(Assets.splashLogo),
                      Tappable(
                        padding: EdgeInsets.all(10),
                        onTap: () {
                          ExtendedNavigator.of(context).pushSettingsPage();
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: 35),
                            child: Icon(AIcons.settings)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 56 + statusBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CarRentPageBody extends StatefulWidget {
  @override
  _CarRentPageBodyState createState() => _CarRentPageBodyState();
}

class _CarRentPageBodyState extends State<CarRentPageBody> {
  final AuthStore _authStore = getIt();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_authStore.profile.value.status != ProfileStatus.verified) ...[
          _loadDocs(),
        ] else ...[
          _nameUser(null),
          ADivider(),
          _infoItem(S.of(context).phoneNumber, _authStore.profile.value.phone),
          _infoItem(S.of(context).email, _authStore.profile.value.email),
          SizedBox(height: 30.0),
        ]
      ],
    );
  }

  Widget _nameUser(String birthDate) {
    final name = [
      _authStore.profile.value.lastName, _authStore.profile.value.firstName
    ].where((element) => !element.isNullEmptyOrWhitespace).join(' ');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: !name.isNullEmptyOrWhitespace || birthDate != null ? 30.0 : 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!name.isNullEmptyOrWhitespace) ...[
            Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Text(
                name,
                style: Thm.of(context).heading1Primary,
              ),
            ),
          ],
          if (birthDate != null) ...[
            SizedBox(height: 5.0),
            Text(
              birthDate,
              style: Thm.of(context).subtitleSecondary,
            )
          ],
        ],
      ),
    );
  }

  Widget _loadDocs() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 30,
              top: 38,
              bottom: 5,
            ),
            child: Text(
              S.of(context).docsForRent,
              style: Thm.of(context).heading1Primary,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30,
              top: 38,
              bottom: 5,
              right: 30,
            ),
            child: Text(
              S.of(context).docsRequirement,
              style: Thm.of(context).bodySecondary,
            ),
          )
        ],
      );

  Widget _infoItem(String title, String subtitle) => subtitle != null
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Text(
                title,
                style: Thm.of(context).captionSecondaryDarker50,
              ),
              SizedBox(height: 2.0),
              Text(
                subtitle,
                style: Thm.of(context).ghostBtnText,
              )
            ],
          ),
        )
      : Container();
}
