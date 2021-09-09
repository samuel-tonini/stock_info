import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/data/protocols/protocols.dart';
import 'package:stock_info/data/usecases/usecases.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late LoadCompanyInfoUsecase sut;
  late Ticker ticker;
  late LoadCompanyInfoRepositorySpy loadCompanyInfoRepository;
  late CompanyInfo companyInfo;

  setUp(() {
    ticker = Ticker('AAPL');
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

  test('Should throw if LoadCompanyInfoRepository.companyInfo throws', () async {
    when(loadCompanyInfoRepository.companyInfo(ticker)).thenThrow(Error());

    final future = sut(ticker);

    expect(future, throwsA(isA<Error>()));
  });
}

class LoadCompanyInfoRepositorySpy extends Mock implements LoadCompanyInfoRepository {
  @override
  Future<CompanyInfo> companyInfo(Ticker ticker) async {
    return super.noSuchMethod(
      Invocation.method(#companyInfo, [ticker]),
      returnValue: CompanyInfo.empty(ticker.abreviation),
    );
  }
}
