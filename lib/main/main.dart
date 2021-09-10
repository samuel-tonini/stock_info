import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'factories/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/stock_tickers',
      getPages: [
        GetPage(name: '/stock_tickers', page: makeStockTickersPage),
        GetPage(name: '/company_info/:ticker', page: makeCompanyInfoPage),
      ],
    );
  }
}
