import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:porsche_app/app/data/domain/auth_store.dart';
import 'package:porsche_app/app/data/models/doc_models.dart';
import 'package:porsche_app/app/presentation/feature/docs/doc/doc_store.dart';
import 'package:porsche_app/app/presentation/navigation/router.gr.dart';

part 'all_docs_store.g.dart';

@injectable
class AllDocsStore = AllDocsStoreBase with _$AllDocsStore;

abstract class AllDocsStoreBase with Store {
  final DocStore passwordPageOneStore;
  final DocStore passwordPageTwoStore;
  final DocStore driverLicenseFrontStore;
  final DocStore driverLicenseRearStore;
  final DocStore faceDriverLicenseStore;
  final AuthStore _authStore;

  AllDocsStoreBase(
    this.passwordPageOneStore,
    this.passwordPageTwoStore,
    this.driverLicenseFrontStore,
    this.driverLicenseRearStore,
    this.faceDriverLicenseStore,
    this._authStore,
  );

  @observable
  Status status;

  @computed
  bool get isValidToLoad {
    final List<FileStatus> list = [
      passwordPageOneStore.fileStatus,
      passwordPageTwoStore.fileStatus,
      driverLicenseFrontStore.fileStatus,
      driverLicenseRearStore.fileStatus,
      faceDriverLicenseStore.fileStatus,
    ];

    final List<FileStatus> readyToLoadList =
        list.where((element) => element == FileStatus.readyToUpload).toList();
    final List<FileStatus> draftOrAsseptedList = list
        .where((element) =>
            element == FileStatus.draft || element == FileStatus.accepted)
        .toList();
    return list.length - readyToLoadList.length - draftOrAsseptedList.length ==
        0;
  }

  @computed
  bool get isAccepted =>
      passwordPageOneStore.fileStatus != null &&
      passwordPageOneStore.fileStatus == FileStatus.accepted &&
      passwordPageTwoStore.fileStatus != null &&
      passwordPageTwoStore.fileStatus == FileStatus.accepted &&
      driverLicenseFrontStore.fileStatus != null &&
      driverLicenseFrontStore.fileStatus == FileStatus.accepted &&
      driverLicenseRearStore.fileStatus != null &&
      driverLicenseRearStore.fileStatus == FileStatus.accepted &&
      faceDriverLicenseStore.fileStatus != null &&
      faceDriverLicenseStore.fileStatus == FileStatus.accepted;

  @computed
  bool get isDraft =>
      passwordPageOneStore.fileStatus != null &&
      (passwordPageOneStore.fileStatus == FileStatus.draft ||
          passwordPageOneStore.fileStatus == FileStatus.accepted) &&
      passwordPageTwoStore.fileStatus != null &&
      (passwordPageTwoStore.fileStatus == FileStatus.draft ||
          passwordPageTwoStore.fileStatus == FileStatus.accepted) &&
      driverLicenseFrontStore.fileStatus != null &&
      (driverLicenseFrontStore.fileStatus == FileStatus.draft ||
          driverLicenseFrontStore.fileStatus == FileStatus.accepted) &&
      driverLicenseRearStore.fileStatus != null &&
      (driverLicenseRearStore.fileStatus == FileStatus.draft ||
          driverLicenseRearStore.fileStatus == FileStatus.accepted) &&
      faceDriverLicenseStore.fileStatus != null &&
      (faceDriverLicenseStore.fileStatus == FileStatus.draft ||
          faceDriverLicenseStore.fileStatus == FileStatus.accepted);

  @computed
  bool get isNotError =>
      passwordPageOneStore.error == null &&
      passwordPageTwoStore.error == null &&
      driverLicenseFrontStore.error == null &&
      driverLicenseRearStore.error == null &&
      faceDriverLicenseStore.error == null;

  @action
  Future<void> uploadDocs() async {
    await Future.wait<void>([
      passwordPageOneStore.uploadDoc(),
      passwordPageTwoStore.uploadDoc(),
      driverLicenseFrontStore.uploadDoc(),
      driverLicenseRearStore.uploadDoc(),
      faceDriverLicenseStore.uploadDoc(),
    ]);
    if (isNotError) {
      valide();
      if (status == Status.valid) {
        await _authStore.fetchProfile();
        ExtendedNavigator.ofRouter<Router>().popUntil((route) =>
            route.settings.name == Routes.carsPage ||
            route.settings.name == Routes.dealPage);
      }
    }
  }

  void valide() {
    final List<FileStatus> list = [
      passwordPageOneStore.fileStatus,
      passwordPageTwoStore.fileStatus,
      driverLicenseFrontStore.fileStatus,
      driverLicenseRearStore.fileStatus,
      faceDriverLicenseStore.fileStatus,
    ];
    final emptyList = list.where((element) =>
        element == FileStatus.empty || element == FileStatus.declined);
    if (emptyList.length > 1) {
      status = Status.empty;
    } else {
      if (list[0] == FileStatus.empty || list[0] == FileStatus.declined) {
        status = Status.passwordPageOneEmpty;
      } else if (list[1] == FileStatus.empty ||
          list[1] == FileStatus.declined) {
        status = Status.passwordPageTwoEmpty;
      } else if (list[2] == FileStatus.empty ||
          list[2] == FileStatus.declined) {
        status = Status.driverLicenseFrontEmpty;
      } else if (list[3] == FileStatus.empty ||
          list[3] == FileStatus.declined) {
        status = Status.driverLicenseRearEmpty;
      } else if (list[4] == FileStatus.empty ||
          list[4] == FileStatus.declined) {
        status = Status.faceDriverLicenseEmpty;
      } else {
        status = Status.valid;
      }
    }
  }
}

enum Status {
  empty,
  passwordPageOneEmpty,
  passwordPageTwoEmpty,
  driverLicenseFrontEmpty,
  driverLicenseRearEmpty,
  faceDriverLicenseEmpty,
  valid,
  errorStatus,
}
