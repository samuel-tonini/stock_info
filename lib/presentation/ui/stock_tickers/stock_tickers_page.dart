import 'package:flutter/material.dart';

import '../../protocols/protocols.dart';

class StockTickersPage extends StatelessWidget {
  const StockTickersPage(this.presenter, {Key? key}) : super(key: key);

  final StockTickersPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Stock'),
      ),
      body: Builder(
        builder: (context) {
          presenter.load();
          return StreamBuilder<List<String>>(
              stream: presenter.tickersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
                  );
                }
                if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data?[index] ?? ''),
                        onTap: () => presenter.goToCompanyInfo(snapshot.data?[index] ?? ''),
                      );
                    },
                    itemCount: snapshot.data?.length ?? 0,
                  );
                }
                return Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16.0, height: 16.0),
                    Text('Wait...'),
                  ],
                );
              });
        },
      ),
    );
  }
}
