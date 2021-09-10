import '../../../domain/models/models.dart';

abstract class CompanyInfoPresenter {
  String get title;
  Stream<CompanyInfo?> get companyInfoStream;
  Future<void> load();
}
