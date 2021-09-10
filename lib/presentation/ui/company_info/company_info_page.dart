import 'package:flutter/material.dart';

import '../../../domain/models/models.dart';

import '../../protocols/protocols.dart';

class CompanyInfoPage extends StatelessWidget {
  const CompanyInfoPage(this.presenter, {Key? key}) : super(key: key);

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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address', style: textTheme.subtitle2),
                    SizedBox(width: 8.0, height: 8.0),
                    Text(snapshot.data?.address ?? '', style: textTheme.bodyText1),
                    Text('${snapshot.data?.city ?? ''}, ${snapshot.data?.state ?? ''}', style: textTheme.bodyText1),
                    Text(snapshot.data?.zip ?? '', style: textTheme.bodyText1),
                    Text(snapshot.data?.country ?? '', style: textTheme.bodyText1),
                    SizedBox(width: 16.0, height: 16.0),
                    Text('Phone', style: textTheme.subtitle2),
                    SizedBox(width: 8.0, height: 8.0),
                    Text(snapshot.data?.phone ?? '', style: textTheme.bodyText1),
                    SizedBox(width: 16.0, height: 16.0),
                    Text('Site', style: textTheme.subtitle2),
                    SizedBox(width: 8.0, height: 8.0),
                    Text(snapshot.data?.webSite ?? '', style: textTheme.bodyText1),
                    SizedBox(width: 16.0, height: 16.0),
                    Text('Sector', style: textTheme.subtitle2),
                    SizedBox(width: 8.0, height: 8.0),
                    Text('${snapshot.data?.sector ?? ''}, ${snapshot.data?.industry ?? ''}',
                        style: textTheme.bodyText1),
                    SizedBox(width: 16.0, height: 16.0),
                    Text('Description', style: textTheme.subtitle2),
                    SizedBox(width: 8.0, height: 8.0),
                    Text(snapshot.data?.description ?? '', style: textTheme.bodyText1),
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
            body: body,
          );
        });
  }
}
