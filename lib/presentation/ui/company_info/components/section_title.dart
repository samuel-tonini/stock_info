import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle(this.title) : super(key: Key(title));

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: 16.0, height: 16.0),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(width: 8.0, height: 8.0),
      ],
    );
  }
}
