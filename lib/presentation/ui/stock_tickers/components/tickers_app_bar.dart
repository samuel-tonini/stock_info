import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../protocols/protocols.dart';

class TickersAppBar extends StatefulWidget implements PreferredSizeWidget {
  TickersAppBar(this.presenter, {Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final StockTickersPresenter presenter;

  @override
  final Size preferredSize;

  @override
  _TickersAppBarState createState() => _TickersAppBarState();
}

class _TickersAppBarState extends State<TickersAppBar> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: widget.presenter.tickersStream,
      initialData: [],
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData || (snapshot.data?.length ?? 0) == 0;
        return AppBar(
          title: !isSearching
              ? Text('Select a Stock')
              : TextFormField(
                  onChanged: (value) => widget.presenter.filter = value,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  inputFormatters: [
                    _UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
          leading: !isSearching
              ? null
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
          actions: [
            if (!isLoading && !isSearching)
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
                icon: Icon(Icons.search),
              ),
            if (isSearching)
              IconButton(
                onPressed: () {
                  widget.presenter.filter = '';
                  setState(() {
                    isSearching = false;
                  });
                },
                icon: Icon(Icons.close),
              ),
          ],
        );
      },
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
