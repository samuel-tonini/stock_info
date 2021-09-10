import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxCompanyInfoPresenter implements CompanyInfoPresenter {
  GetxCompanyInfoPresenter({
    required this.ticker,
    required this.loadCompanyInfo,
  }) : _title = ticker.abreviation;

  String _title;
  final _companyInfo = Rx<CompanyInfo?>(null);
  final Ticker ticker;
  final LoadCompanyInfo loadCompanyInfo;

  @override
  Stream<CompanyInfo?> get companyInfoStream => _companyInfo.stream;

  @override
  Future<void> load() async {
    try {
      _companyInfo.value = null;
      _title = ticker.abreviation;
      final companyInfo = await loadCompanyInfo(ticker);
      _title = companyInfo.name;
      _companyInfo.value = companyInfo;
    } catch (error) {
      _companyInfo.addError(
        error,
        StackTrace.empty,
      );
    }
  }

  @override
  String get title => _title;
}
