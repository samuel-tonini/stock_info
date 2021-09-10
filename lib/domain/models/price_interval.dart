enum PriceInterval {
  fiveMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  oneDay,
  oneWeek,
  oneMonth,
  threeMonths,
}

extension PriceIntervalExtension on PriceInterval {
  String get description {
    switch (this) {
      case PriceInterval.fiveMinutes:
        return '5m';
      case PriceInterval.fifteenMinutes:
        return '15m';
      case PriceInterval.thirtyMinutes:
        return '30m';
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
