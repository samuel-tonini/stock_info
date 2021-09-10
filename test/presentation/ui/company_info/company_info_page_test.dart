import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/domain/models/models.dart';
import 'package:stock_info/presentation/models/models.dart';

import 'package:stock_info/presentation/protocols/protocols.dart';
import 'package:stock_info/presentation/ui/ui.dart';

import '../../helpers/helpers.dart';

main() {
  late CompanyInfoPresenterSpy presenter;
  late Rx<CompanyInfo?> companyInfoStreamController;
  late Rx<List<HistoricalStockPriceViewModel>> historicalPriceStreamController;
  late CompanyInfo companyInfo;
  late String title;
  late Rx<PriceInterval> priceIntervalStreamController;
  late PriceInterval priceInterval;

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
    priceIntervalStreamController = Rx<PriceInterval>(PriceInterval.oneHour);
    presenter = CompanyInfoPresenterSpy();
    companyInfoStreamController = Rx<CompanyInfo?>(null);
    historicalPriceStreamController = Rx<List<HistoricalStockPriceViewModel>>(<HistoricalStockPriceViewModel>[]);
    priceInterval = PriceInterval.oneHour;

    when(presenter.companyInfoStream).thenAnswer((_) => companyInfoStreamController.stream);
    when(presenter.historicalPriceStream).thenAnswer((_) => historicalPriceStreamController.stream);
    when(presenter.title).thenAnswer((_) => title);
    when(presenter.priceIntervalStream).thenAnswer((_) => priceIntervalStreamController.stream);
    when(presenter.priceInterval = priceInterval).thenAnswer(
      (_) => priceIntervalStreamController.value = priceInterval,
    );
    when(presenter.load()).thenAnswer((_) async {
      companyInfoStreamController.value = null;
      await Future.delayed(Duration.zero);
      title = companyInfo.name;
      companyInfoStreamController.value = companyInfo;
    });
  });

  tearDown(() {
    companyInfoStreamController.close();
    historicalPriceStreamController.close();
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
    for (final priceInterval in PriceInterval.values) {
      expect(
        find.ancestor(
          of: find.bySemanticsLabel(priceInterval.description),
          matching: find.byType(priceIntervalStreamController.value == priceInterval ? TextButton : ElevatedButton),
        ),
        findsOneWidget,
      );
    }
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

  testWidgets('Should update button correctly', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    Finder finder;

    for (final priceIntervalItem in PriceInterval.values) {
      finder = find.ancestor(
        of: find.bySemanticsLabel(priceIntervalItem.description),
        matching: find.byType(priceIntervalStreamController.value == priceIntervalItem ? TextButton : ElevatedButton),
      );

      expect(finder, findsOneWidget);

      await tester.tap(finder);
      await tester.pumpAndSettle();

      expect(finder, findsOneWidget);
    }
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

  Stream<List<HistoricalStockPriceViewModel>> get historicalPriceStream {
    return super.noSuchMethod(
      Invocation.getter(#historicalPriceStream),
      returnValue: Rx<List<HistoricalStockPriceViewModel>>(<HistoricalStockPriceViewModel>[]).stream,
    );
  }

  Stream<PriceInterval> get priceIntervalStream {
    return super.noSuchMethod(
      Invocation.getter(#priceIntervalStream),
      returnValue: Rx<PriceInterval>(PriceInterval.oneHour).stream,
    );
  }

  set priceInterval(PriceInterval newPriceInterval) {
    return super.noSuchMethod(
      Invocation.setter(#priceInterval, [newPriceInterval]),
      returnValue: PriceInterval.oneHour,
    );
  }
}
