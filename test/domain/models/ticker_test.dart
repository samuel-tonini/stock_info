import 'package:flutter_test/flutter_test.dart';
import 'package:stock_info/domain/models/models.dart';

main() {
  test('Should populate properties with correct values', () {
    final sut = Ticker('AAPL');
    expect(sut.abreviation, 'AAPL');
  });

  test('Should throw InvalidArgumentError if ticker is empty', () {
    expect(() => Ticker(''), throwsArgumentError);
  });
}
