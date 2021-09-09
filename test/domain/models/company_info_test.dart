import 'package:flutter_test/flutter_test.dart';

import 'package:stock_info/domain/models/models.dart';

main() {
  late CompanyInfo sut;
  late String ticker;
  late String address;
  late String city;
  late String state;
  late String zip;
  late String phone;
  late String webSite;
  late String industry;
  late String sector;
  late String country;
  late String description;

  setUp(() {
    ticker = 'AAPL';
    address = 'One Apple Park Way';
    city = 'Cupertino';
    state = 'CA';
    zip = '95014';
    phone = '408-996-1010';
    webSite = 'http://www.apple.com';
    industry = 'Consumer Electronics';
    sector = 'Technology';
    country = 'United States';
    description =
        'Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide.';
    sut = CompanyInfo(
      ticker: ticker,
      address: address,
      city: city,
      state: state,
      zip: zip,
      phone: phone,
      webSite: webSite,
      industry: industry,
      sector: sector,
      country: country,
      description: description,
    );
  });

  test('Should populate properties with correct values', () {
    expect(sut.ticker, ticker);
    expect(sut.address, address);
    expect(sut.city, city);
    expect(sut.state, state);
    expect(sut.zip, zip);
    expect(sut.phone, phone);
    expect(sut.webSite, webSite);
    expect(sut.industry, industry);
    expect(sut.country, country);
    expect(sut.description, description);
  });

  test('Should populate empty class', () {
    final sut = CompanyInfo.empty(ticker);

    expect(sut.ticker, ticker);
    expect(sut.address, '');
    expect(sut.city, '');
    expect(sut.state, '');
    expect(sut.zip, '');
    expect(sut.phone, '');
    expect(sut.webSite, '');
    expect(sut.industry, '');
    expect(sut.country, '');
    expect(sut.description, '');
  });

  test('Should extract company name from its description', () {
    expect(sut.name, 'Apple Inc.');
  });

  test('Should return company ticker as its name when description is empty', () {
    final sut = CompanyInfo.empty(ticker);

    expect(sut.name, ticker);
  });

  test('Should return company ticker as its name when description does not contains "Inc."', () {
    final sut = CompanyInfo(
      ticker: ticker,
      description:
          'Apple designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide.',
      address: '',
      city: '',
      state: '',
      zip: '',
      phone: '',
      webSite: '',
      industry: '',
      sector: '',
      country: '',
    );

    expect(sut.name, ticker);
  });

  test('Should throw if ticker is empty', () {
    expect(
      () {
        return CompanyInfo(
          ticker: '',
          description: '',
          address: '',
          city: '',
          state: '',
          zip: '',
          phone: '',
          webSite: '',
          industry: '',
          sector: '',
          country: '',
        );
      },
      throwsA(isA<ArgumentError>()),
    );
  });
}
