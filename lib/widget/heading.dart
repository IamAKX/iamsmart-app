import 'package:flutter/material.dart';

import '../util/theme.dart';

class Heading extends StatelessWidget {
  final String title;
  const Heading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 40),
      ),
    );
  }
}
