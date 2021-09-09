import '../../domain/models/models.dart';

class JsonCompanyInfo {
  static CompanyInfo fromJson({required String ticker, required Map json}) {
    return CompanyInfo(
      ticker: ticker,
      address: json['address1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      phone: json['phone'] ?? '',
      webSite: json['website'] ?? '',
      industry: json['industry'] ?? '',
      sector: json['sector'] ?? '',
      description: json['longBusinessSummary'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
