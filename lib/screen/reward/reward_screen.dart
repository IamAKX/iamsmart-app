import 'package:flutter/material.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';

import '../../widget/heading.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Reward'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: rewardCardColor,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total rewards earned',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                Text(
                  '$rupeeSymbol ${currencyFormatter.format(5378.74444)}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'Total rewards earned today',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                Text(
                  '$rupeeSymbol ${currencyFormatter.format(35.53)}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: ListView()),
      ],
    );
  }
}
