import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../infra/infra.dart';

LoadCompanyInfo makeHttpLoadCompanyInfoUsecase() {
  return LoadCompanyInfoUsecase(makeHttpLoadCompanyInfoRepository());
}
