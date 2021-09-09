import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class LoadStockTickersUsecase implements LoadStockTickers {
  final LoadStockTickersRepository loadStockTickersRepository;

  LoadStockTickersUsecase(this.loadStockTickersRepository);

  Future<List<Ticker>> call() async {
    List<Ticker> result = await loadStockTickersRepository.loadTickers();
    result = result.where((ticker) => !ticker.abreviation.contains(RegExp('[^A-Z]'))).toList();
    result.sort((a, b) => a.abreviation.compareTo(b.abreviation));
    return result;
  }
}
