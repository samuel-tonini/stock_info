class CompanyInfo {
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
  });

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
    String companyName = matches[0].group(0) ?? '';
    if (companyName.isEmpty) {
      return ticker;
    }
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
}
