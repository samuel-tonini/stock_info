abstract class StockTickersPresenter {
  Stream<List<String>> get tickersStream;
  Future<void> load();
  void goToCompanyInfo(String ticker);
  set filter(String newFilter);
}
