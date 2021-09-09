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
    expect(find.bySemanticsLabel('Select a Stock'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Wait...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.bySemanticsLabel('Wait...'), findsNothing);
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
    expect(find.bySemanticsLabel('Wait...'), findsNothing);
    expect(find.bySemanticsLabel('Error'), findsOneWidget);
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
}
