import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/auth_store.dart';
import 'package:porsche_app/app/data/models/doc_models.dart';
import 'package:porsche_app/app/presentation/components/a/a_app_bar.dart';
import 'package:porsche_app/app/presentation/components/a/a_button.dart';
import 'package:porsche_app/app/presentation/components/a/a_scaffold.dart';
import 'package:porsche_app/app/presentation/components/a/a_toast.dart';
import 'package:porsche_app/app/presentation/components/tappable.dart';
import 'package:porsche_app/app/presentation/feature/docs/all_docs_store.dart';
import 'package:porsche_app/app/presentation/feature/docs/doc/doc_item.dart';
import 'package:porsche_app/app/presentation/resources/icons.dart';
import 'package:porsche_app/app/presentation/theme/app_theme.dart';
import 'package:porsche_app/generated/l10n.dart';
import 'package:porsche_app/injection.dart';
import 'package:provider/provider.dart';

class AllDocsPage extends StatefulWidget {
  @override
  _AllDocsPageState createState() => _AllDocsPageState();
}

class _AllDocsPageState extends State<AllDocsPage> {
  final AllDocsStore _store = getIt();
  final AuthStore _authStore = getIt();

  @override
  void initState() {
    super.initState();
    reaction((_) => _store.status, (Status status) {
      switch (status) {
        case Status.empty:
          showToast(
              context,
              AToast(
                title: S.of(context).toastDocsEmpty,
              ));
          break;
        case Status.passwordPageOneEmpty:
        case Status.passwordPageTwoEmpty:
          showToast(
              context,
              AToast(
                title: S.of(context).toastPasswordDocsEmpty,
              ));
          break;
        case Status.driverLicenseFrontEmpty:
        case Status.driverLicenseRearEmpty:
          showToast(
              context,
              AToast(
                title: S.of(context).toastDriverLicenseEmpty,
              ));
          break;
        case Status.faceDriverLicenseEmpty:
          showToast(
              context,
              AToast(
                title: S.of(context).toastFaceDriverLicenseEmpty,
              ));
          break;
        case Status.valid:
          showToast(
              context,
              AToast(
                title: S.of(context).toastDocumentsAreAllLoaded,
              ));
          break;
        case Status.errorStatus:
          showToast(
              context,
              AToast(
                title: S.of(context).networkError,
              ));
          break;
      }
      _store.status = null;
    });

    reaction((_) => _store.isNotError, (bool isNotError) {
      if (!isNotError) {
        showToast(context, AToast(title: S.of(context).networkError));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _authStore.fetchProfile();
        return true;
      },
      child: AScaffold(
        appBar: AAppBar(
          title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).docs,
              )),
          isCenterTitle: false,
          leadingIcon: Tappable(
            padding: EdgeInsets.only(
              left: 23.0,
              right: 20.0,
              top: 15.0,
              bottom: 15.0,
            ),
            child: Icon(AIcons.arrow_left),
            onTap: () async {
              await _authStore.fetchProfile();
              ExtendedNavigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: CustomScrollView(
              slivers: <Widget>[
                _title(S.of(context).passportPhoto),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Provider(
                        create: (_) => _store.passwordPageOneStore,
                        child: DocItem(
                          fileType: FileType.passport_page_one,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Provider(
                        create: (_) => _store.passwordPageTwoStore,
                        child: DocItem(
                          fileType: FileType.passport_page_two,
                        ),
                      ),
                    ],
                  ),
                ),
                _title(S.of(context).driverLicense),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Provider(
                        create: (_) => _store.driverLicenseFrontStore,
                        child: DocItem(
                          fileType: FileType.driver_license_front,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Provider(
                        create: (_) => _store.driverLicenseRearStore,
                        child: DocItem(
                          fileType: FileType.driver_license_rear,
                        ),
                      ),
                    ],
                  ),
                ),
                _title(S.of(context).photoWithTheDocument),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Provider(
                        create: (_) => _store.faceDriverLicenseStore,
                        child: DocItem(
                          fileType: FileType.face_driver_license,
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            )),
            Observer(builder: (context) {
              if (_store.isAccepted) {
                return AButton.secondary(
                  isBottom: true,
                  text: S.of(context).allDocumentsAreApproved,
                  backgroundColor: Thm.of(context).acceptedColor,
                );
              } else if (_store.isDraft) {
                return AButton.secondary(
                  isBottom: true,
                  text: S.of(context).photosUploadedAndUnderReview,
                  backgroundColor: Thm.of(context).draftColor,
                );
              }
              return AButton.main(
                text: S.of(context).submitForVerification,
                isBottom: true,
                isActive: _store.isValidToLoad,
                onPressed: () {
                  _store.uploadDocs();
                },
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Text(
            text,
            style: Thm.of(context).bodyPrimaryBold,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
