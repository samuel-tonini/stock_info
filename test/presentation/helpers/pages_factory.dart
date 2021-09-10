import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePages({
  required String path,
  required Widget Function() page,
  bool goToPath = true,
}) {
  return GetMaterialApp(
    initialRoute: goToPath ? path : '/any_route',
    getPages: [
      GetPage(
        name: path,
        page: page,
      ),
      GetPage(
        name: '/any_route',
        page: () => Scaffold(
          appBar: AppBar(title: Text('any_title')),
          body: Text('any_page'),
        ),
      )
    ],
  );
}
