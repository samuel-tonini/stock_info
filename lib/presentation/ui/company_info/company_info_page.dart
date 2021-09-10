import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/models.dart';

import '../../protocols/protocols.dart';

import 'components/components.dart';

class CompanyInfoPage extends StatelessWidget {
  CompanyInfoPage(this.presenter, {Key? key}) : super(key: key) {
    Get.put<CompanyInfoPresenter>(presenter);
  }

  final CompanyInfoPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.load();
    return StreamBuilder<CompanyInfo?>(
        stream: presenter.companyInfoStream,
        builder: (context, snapshot) {
          Widget body;

          final textTheme = Theme.of(context).textTheme;

          if (snapshot.hasError) {
            body = Center(
              child: Text(
                'Error',
                style: textTheme.headline4,
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            body = Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Stock Price History'),
                    HistoricalPrice(),
                    SectionTitle('Company Information'),
                    SectionTitle('Address'),
                    SectionItem(snapshot.data?.address ?? ''),
                    SectionItem('${snapshot.data?.city ?? ''}, ${snapshot.data?.state ?? ''}'),
                    SectionItem(snapshot.data?.zip ?? ''),
                    SectionItem(snapshot.data?.country ?? ''),
                    SectionTitle('Phone'),
                    SectionItem(snapshot.data?.phone ?? ''),
                    SectionTitle('Site'),
                    SectionItem(snapshot.data?.webSite ?? ''),
                    SectionTitle('Sector'),
                    SectionItem('${snapshot.data?.sector ?? ''}, ${snapshot.data?.industry ?? ''}'),
                    SectionTitle('Description'),
                    SectionItem(snapshot.data?.description ?? ''),
                  ],
                ),
              ),
            );
          } else {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.0, height: 16.0),
                  Text('Wait...', style: textTheme.headline6),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(presenter.title),
            ),
            body: AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: body,
            ),
          );
        });
  }
}
