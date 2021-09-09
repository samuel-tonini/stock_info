import '../../domain/models/models.dart';

class HttpPriceInterval {
  static String toQueryParam(PriceInterval priceInterval) {
    switch (priceInterval) {
      case PriceInterval.fiveMinutes:
        return '5m';
      case PriceInterval.fifteenMinutes:
        return '15m';
      case PriceInterval.oneDay:
        return '1d';
      case PriceInterval.oneWeek:
        return '1wk';
      case PriceInterval.oneMonth:
        return '1mo';
      case PriceInterval.threeMonths:
        return '3mo';
      default:
        return '1h';
    }
  }
}
