import 'package:equatable/equatable.dart';

class CompanyInfo extends Equatable {
  CompanyInfo({
    required this.ticker,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
    required this.webSite,
    required this.industry,
    required this.sector,
    required this.description,
    required this.country,
  }) {
    if (ticker.isEmpty) {
      throw ArgumentError.value('', 'ticker', 'Ticker must to have a value');
    }
  }

  final String ticker;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String phone;
  final String webSite;
  final String industry;
  final String sector;
  final String description;
  final String country;

  String get name {
    final regex = RegExp(r'^.*?(?=inc\.)', multiLine: true);
    final matches = regex.allMatches(description.toLowerCase()).toList();
    if (matches.isEmpty) {
      return ticker;
    }
    String companyName = matches[0].group(0) ?? ' ';
    companyName = companyName
        .trim()
        .split(' ')
        .map(
          (part) => '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
    return '$companyName Inc.';
  }

  static CompanyInfo empty(String ticker) {
    return CompanyInfo(
      address: '',
      country: '',
      city: '',
      description: '',
      industry: '',
      phone: '',
      sector: '',
      state: '',
      zip: '',
      webSite: '',
      ticker: ticker,
    );
  }

  @override
  List<Object?> get props {
    return [
      ticker,
      address,
      city,
      state,
      zip,
      phone,
      webSite,
      industry,
      sector,
      description,
      country,
    ];
  }
}
