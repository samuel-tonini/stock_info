import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/models.dart';

import 'package:stock_info/presentation/protocols/protocols.dart';
import 'package:stock_info/presentation/ui/ui.dart';

import '../../helpers/helpers.dart';

main() {
  late CompanyInfoPresenterSpy presenter;
  late Rx<CompanyInfo?> companyInfoStreamController;
  late CompanyInfo companyInfo;
  late String title;

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePages(
        path: '/stock_tickers',
        page: () => CompanyInfoPage(presenter),
      ),
    );
  }

  setUp(() {
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
    title = 'AAPL';
    presenter = CompanyInfoPresenterSpy();
    companyInfoStreamController = Rx<CompanyInfo?>(null);

    when(presenter.companyInfoStream).thenAnswer((_) => companyInfoStreamController.stream);
    when(presenter.title).thenAnswer((_) => title);
    when(presenter.load()).thenAnswer((_) async {
      companyInfoStreamController.value = null;
      await Future.delayed(Duration.zero);
      title = companyInfo.name;
      companyInfoStreamController.value = companyInfo;
    });
  });

  tearDown(() {
    companyInfoStreamController.close();
  });

  testWidgets('Should render initial page correctly', (tester) async {
    await loadPage(tester);

    verify(presenter.load()).called(1);
    expect(find.bySemanticsLabel(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(companyInfo.name), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.bySemanticsLabel('Wait...'), findsNothing);
    expect(find.bySemanticsLabel('Address'), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.address), findsOneWidget);
    expect(find.bySemanticsLabel('${companyInfo.city}, ${companyInfo.state}'), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.zip), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.country), findsOneWidget);
    expect(find.bySemanticsLabel('Phone'), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.phone), findsOneWidget);
    expect(find.bySemanticsLabel('Site'), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.webSite), findsOneWidget);
    expect(find.bySemanticsLabel('Sector'), findsOneWidget);
    expect(find.bySemanticsLabel('${companyInfo.sector}, ${companyInfo.industry}'), findsOneWidget);
    expect(find.bySemanticsLabel('Description'), findsOneWidget);
    expect(find.bySemanticsLabel(companyInfo.description), findsOneWidget);
  });

  testWidgets('Should render error page correctly', (tester) async {
    when(presenter.load()).thenAnswer((_) async {
      companyInfoStreamController.value = null;
      await Future.delayed(Duration.zero);
      companyInfoStreamController.addError(
        Error(),
        StackTrace.empty,
      );
    });

    expectLater(presenter.companyInfoStream, emitsInOrder([null, emitsError(isA<Error>())]));

    await loadPage(tester);

    verify(presenter.load()).called(1);
    expect(find.bySemanticsLabel(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.bySemanticsLabel('Wait...'), findsNothing);
    expect(find.bySemanticsLabel('Error'), findsOneWidget);
  });
}

class CompanyInfoPresenterSpy extends Mock implements CompanyInfoPresenter {
  String get title {
    return super.noSuchMethod(
      Invocation.getter(#title),
      returnValue: '',
    );
  }

  Stream<CompanyInfo?> get companyInfoStream {
    return super.noSuchMethod(
      Invocation.getter(#companyInfoStream),
      returnValue: Rx<CompanyInfo?>(null).stream,
    );
  }

  Future<void> load() async {
    return super.noSuchMethod(
      Invocation.method(#load, []),
      returnValue: null,
    );
  }
}
