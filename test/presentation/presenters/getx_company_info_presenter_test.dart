import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/models.dart';
import 'package:stock_info/domain/usecases/usecases.dart';

import 'package:stock_info/presentation/presenters/presenters.dart';

main() {
  late GetxCompanyInfoPresenter sut;
  late LoadCompanyInfoSpy loadCompanyInfo;
  late Ticker ticker;
  late CompanyInfo companyInfo;

  setUp(() {
    loadCompanyInfo = LoadCompanyInfoSpy();
    ticker = Ticker('AAPL');
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
    sut = GetxCompanyInfoPresenter(
      ticker: ticker,
      loadCompanyInfo: loadCompanyInfo,
    );
    when(loadCompanyInfo(ticker)).thenAnswer((_) async => companyInfo);
  });

  test('Should call LoadCompanyInfo', () async {
    await sut.load();

    verify(loadCompanyInfo(ticker)).called(1);
  });

  test('Should emit error if LoadCompanyInfo throws', () async {
    when(loadCompanyInfo(ticker)).thenThrow(Error());

    expectLater(sut.companyInfoStream, emitsInOrder([null, emitsError(isA<Error>())]));

    await sut.load();
  });

  test('Should emit null and after the result', () async {
    expectLater(sut.companyInfoStream, emitsInOrder([null, companyInfo]));

    await sut.load();
  });

  test('Should use ticker abreviation as initial title', () async {
    expect(sut.title, ticker.abreviation);

    await sut.load();

    expect(sut.title, companyInfo.name);
  });
}

class LoadCompanyInfoSpy extends Mock implements LoadCompanyInfo {
  Future<CompanyInfo> call(Ticker ticker) async {
    return super.noSuchMethod(
      Invocation.method(#call, []),
      returnValue: CompanyInfo.empty(ticker.abreviation),
    );
  }
}
