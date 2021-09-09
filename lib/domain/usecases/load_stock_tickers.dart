import '../models/models.dart';

abstract class LoadStockTickers {
  Future<List<Ticker>> call();
}
