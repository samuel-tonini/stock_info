import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/data/protocols/protocols.dart';
import 'package:stock_info/data/usecases/usecases.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late LoadCompanyInfoUsecase sut;
  late String ticker;
  late LoadCompanyInfoRepositorySpy loadCompanyInfoRepository;
  late CompanyInfo companyInfo;

  setUp(() {
    ticker = 'AAPL';
    loadCompanyInfoRepository = LoadCompanyInfoRepositorySpy();
    sut = LoadCompanyInfoUsecase(loadCompanyInfoRepository);
    companyInfo = CompanyInfo(
      ticker: 'AAPL',
      address: 'One Apple Park Way',
      city: 'Cupertino',
      state: 'CA',
      zip: '95014',
      phone: '408-996-1010',
      webSite: 'http://www.apple.com',
      industry: 'Consumer Electronics',
      sector: 'Technology',
      country: 'United States',
      description:
          'Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide.',
    );
    when(loadCompanyInfoRepository.companyInfo(ticker)).thenAnswer((_) async => companyInfo);
  });

  test('Should call LoadCompanyInfoRepository.companyInfo with correct values', () async {
    await sut(ticker);

    verify(loadCompanyInfoRepository.companyInfo(ticker)).called(1);
  });

  test('Should return company info', () async {
    final result = await sut(ticker);

    expect(result, companyInfo);
  });
}

class LoadCompanyInfoRepositorySpy extends Mock implements LoadCompanyInfoRepository {
  @override
  Future<CompanyInfo> companyInfo(String ticker) async {
    return super.noSuchMethod(
      Invocation.method(#companyInfo, [ticker]),
      returnValue: CompanyInfo.empty(ticker),
    );
  }
}
