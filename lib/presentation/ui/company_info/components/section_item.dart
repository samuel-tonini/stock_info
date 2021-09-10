import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  SectionItem(this.label) : super(key: Key(label));

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
