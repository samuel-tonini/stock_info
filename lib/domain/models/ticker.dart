import 'package:equatable/equatable.dart';

class Ticker extends Equatable {
  final String abreviation;
  Ticker(this.abreviation) {
    if (abreviation.isEmpty) {
      throw ArgumentError.value('', 'abreviation', 'Ticker abreviation must to have a value');
    }
  }

  @override
  List<Object?> get props => [abreviation];
}
