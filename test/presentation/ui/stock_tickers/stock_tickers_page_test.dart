import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:stock_info/presentation/protocols/protocols.dart';
import 'package:stock_info/presentation/ui/ui.dart';

import '../../helpers/helpers.dart';

main() {
  late StockTickersPresenterSpy presenter;
  late Rx<List<String>> tickersStreamController;
  late List<String> tickers;
  late String filter;

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      makePages(
        path: '/stock_tickers',
        page: () => StockTickersPage(presenter),
      ),
    );
  }

  setUp(() {
    tickers = ['AAPL', 'AMZO', 'LULU', 'MITT'];
    presenter = StockTickersPresenterSpy();
    tickersStreamController = Rx<List<String>>(<String>[]);
    filter = '';

    when(presenter.tickersStream).thenAnswer((_) => tickersStreamController.stream);
    when(presenter.load()).thenAnswer((_) async {
      tickersStreamController.value = [];
      await Future.delayed(Duration.zero);
      tickersStreamController.value = tickers;
    });
    when(presenter.goToCompanyInfo(tickers[0])).thenAnswer((_) {
      Get.toNamed('/any_route');
    });
  });

  tearDown(() {
    tickersStreamController.close();
  });

  testWidgets('Should render initial page correctly', (tester) async {
    expectLater(presenter.tickersStream, emitsInOrder([[], tickers]));

    await loadPage(tester);

    verify(presenter.load()).called(1);
    expect(find.text('Select a Stock'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Wait...'), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(tickers.length));
  });

  testWidgets('Should render error page', (tester) async {
    when(presenter.load()).thenAnswer((_) async {
      tickersStreamController.value = [];
      await Future.delayed(Duration.zero);
      tickersStreamController.addError('Error', StackTrace.empty);
    });

    await loadPage(tester);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Wait...'), findsNothing);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Should go to company info page', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    final listTileItem = tester.widget<ListTile>(
      find.descendant(
        of: find.bySemanticsLabel(tickers[0]),
        matching: find.byType(ListTile),
      ),
    );
    listTileItem.onTap?.call();

    await tester.pumpAndSettle();

    expect(currentRoute(), '/any_route');
  });

  testWidgets('Should show filter field', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Select a Stock'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.byType(TextFormField), findsNothing);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Select a Stock'), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('Should filter results loaded values', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    verify(presenter.load()).called(1);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    filter = 'AAPL';
    when(presenter.filter = filter).thenAnswer((_) {
      tickersStreamController.value = filter == '' ? tickers : tickers.where((ticker) => ticker == filter).toList();
      return filter;
    });
    await tester.enterText(find.byType(TextFormField), filter);
    await tester.pumpAndSettle();

    verifyNever(presenter.load());
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Should not reload if back to tickers page', (tester) async {
    await loadPage(tester);
    await tester.pumpAndSettle();

    verify(presenter.load()).called(1);

    Get.toNamed('/any_route');
    expect(currentRoute(), '/any_route');

    await tester.pumpAndSettle();

    Get.back();
    expect(currentRoute(), '/stock_tickers');

    await tester.pumpAndSettle();

    verifyNever(presenter.load());
  });
}

class StockTickersPresenterSpy extends Mock implements StockTickersPresenter {
  Stream<List<String>> get tickersStream {
    return super.noSuchMethod(
      Invocation.getter(#tickersStream),
      returnValue: Rx<List<String>>([]).stream,
    );
  }

  Future<void> load() {
    return super.noSuchMethod(
      Invocation.method(#load, []),
      returnValue: Future.sync(() {}),
    );
  }

  void goToCompanyInfo(String ticker) {
    return super.noSuchMethod(
      Invocation.method(#goToCompanyInfo, [ticker]),
      returnValue: null,
    );
  }

  set filter(String newFilter) {
    return super.noSuchMethod(
      Invocation.setter(#filter, [newFilter]),
      returnValue: '',
    );
  }
}
