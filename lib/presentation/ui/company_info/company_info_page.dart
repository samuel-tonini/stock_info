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

          if (snapshot.hasError) {
            body = Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            body = Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Address'),
                    Text(snapshot.data?.address ?? ''),
                    Text('${snapshot.data?.city ?? ''}, ${snapshot.data?.state ?? ''}'),
                    Text(snapshot.data?.zip ?? ''),
                    Text(snapshot.data?.country ?? ''),
                    Text('Phone'),
                    Text(snapshot.data?.phone ?? ''),
                    Text('Site'),
                    Text(snapshot.data?.webSite ?? ''),
                    Text('Sector'),
                    Text('${snapshot.data?.sector ?? ''}, ${snapshot.data?.industry ?? ''}'),
                    Text('Description'),
                    Text(snapshot.data?.description ?? ''),
                  ],
                ),
              ),
            );
          } else {
            body = Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0, height: 16.0),
                Text('Wait...'),
              ],
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
