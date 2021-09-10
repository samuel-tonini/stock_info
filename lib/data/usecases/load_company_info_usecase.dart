import '../../domain/usecases/usecases.dart';
import '../../domain/models/models.dart';

import '../protocols/protocols.dart';

class LoadCompanyInfoUsecase implements LoadCompanyInfo {
  LoadCompanyInfoUsecase(this.loadCompanyInfoRepository);

  final LoadCompanyInfoRepository loadCompanyInfoRepository;

  Future<CompanyInfo> call(Ticker ticker) async {
    final result = await loadCompanyInfoRepository.companyInfo(ticker);
    return result;
  }
}
