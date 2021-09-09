import 'package:equatable/equatable.dart';

class Ticker extends Equatable {
  final String abreviation;
  Ticker(this.abreviation);

  @override
  List<Object?> get props => [abreviation];
}
