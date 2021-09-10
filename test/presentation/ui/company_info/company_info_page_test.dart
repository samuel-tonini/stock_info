import 'package:fl_chart/fl_chart.dart';
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
        path: '/company_info',
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
    expect(find.text(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text(companyInfo.name), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Wait...'), findsNothing);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text(companyInfo.address), findsOneWidget);
    expect(find.text('${companyInfo.city}, ${companyInfo.state}'), findsOneWidget);
    expect(find.text(companyInfo.zip), findsOneWidget);
    expect(find.text(companyInfo.country), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text(companyInfo.phone), findsOneWidget);
    expect(find.text('Site'), findsOneWidget);
    expect(find.text(companyInfo.webSite), findsOneWidget);
    expect(find.text('Sector'), findsOneWidget);
    expect(find.text('${companyInfo.sector}, ${companyInfo.industry}'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text(companyInfo.description, skipOffstage: false), findsOneWidget);
    for (final priceInterval in PriceInterval.values) {
      expect(
        find.ancestor(
          of: find.text(priceInterval.description),
          matching: find.byType(priceIntervalStreamController.value == priceInterval ? OutlinedButton : ElevatedButton),
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
    expect(find.text(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text(title), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Wait...'), findsNothing);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Should update button correctly', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    Finder finder;

    for (final priceIntervalItem in PriceInterval.values) {
      finder = find.ancestor(
        of: find.text(priceIntervalItem.description),
        matching:
            find.byType(priceIntervalStreamController.value == priceIntervalItem ? OutlinedButton : ElevatedButton),
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
