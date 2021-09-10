import 'package:equatable/equatable.dart';

import '../../domain/models/models.dart';

class HistoricalStockPriceViewModel extends Equatable {
  HistoricalStockPriceViewModel(this.historicalStockPrice);

  final HistoricalStockPrice historicalStockPrice;

  String get date => '${historicalStockPrice.at.day}/${historicalStockPrice.at.month}/${historicalStockPrice.at.year}';
  String get hour => '${historicalStockPrice.at.hour}:${historicalStockPrice.at.minute}';
  double get price => historicalStockPrice.price;

  @override
  List<Object?> get props => [date, hour, price];
}
