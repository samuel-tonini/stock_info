import '../../../domain/models/models.dart';

abstract class LoadStockTickersRepository {
  Future<List<Ticker>> loadTickers();
}
