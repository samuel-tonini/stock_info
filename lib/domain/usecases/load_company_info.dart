import '../models/models.dart';

abstract class LoadCompanyInfo {
  Future<CompanyInfo> call(String ticker);
}
