import '../../../domain/models/models.dart';

abstract class LoadCompanyInfoRepository {
  Future<CompanyInfo> companyInfo(Ticker ticker);
}
