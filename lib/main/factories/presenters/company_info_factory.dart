import 'package:get/get.dart';
import 'package:stock_info/domain/models/models.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../../presentation/protocols/protocols.dart';

import '../usecase/usecase.dart';

CompanyInfoPresenter makeGetxCompanyInfoPresenter() {
  return GetxCompanyInfoPresenter(
    loadCompanyInfo: makeHttpLoadCompanyInfoUsecase(),
    ticker: Ticker(Get.parameters['ticker'] ?? ''),
  );
}
