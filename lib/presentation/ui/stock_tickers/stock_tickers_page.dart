import 'package:flutter/material.dart';

import '../../protocols/protocols.dart';
import 'components/components.dart';

class StockTickersPage extends StatelessWidget {
  const StockTickersPage(this.presenter, {Key? key}) : super(key: key);

  final StockTickersPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.load();
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TickersAppBar(presenter),
      body: StreamBuilder<List<String>>(
        stream: presenter.tickersStream,
        initialData: [],
        builder: (context, snapshot) {
          Widget body;
          if (snapshot.hasError) {
            body = Center(
              child: Text(
                'Error',
                style: textTheme.headline4,
              ),
            );
          } else if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
            body = ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index] ?? ''),
                  onTap: () => presenter.goToCompanyInfo(snapshot.data?[index] ?? ''),
                );
              },
              itemCount: snapshot.data?.length ?? 0,
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
          return AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: body,
          );
        },
      ),
    );
  }
}
