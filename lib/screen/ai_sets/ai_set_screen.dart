import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_details.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';

import '../../util/colors.dart';
import '../../widget/heading.dart';

class AiSetScreen extends StatefulWidget {
  const AiSetScreen({super.key});
  static const String aiSetRoute = '/mainContainer/assets/aiSet';

  @override
  State<AiSetScreen> createState() => _AiSetScreenState();
}

class _AiSetScreenState extends State<AiSetScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Heading(title: 'AI Sets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Running'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            running(),
            completed(),
          ],
        ),
      ),
    );
  }

  completed() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => InkWell(
        onTap: () => context.push(
          AiSetDetailScreen.transactionDetailScreenRoute
              .replaceAll(':txnId', '$index'),
        ),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Set #${index + 1}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColorDark,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 10,
                    ),
                  ],
                ),
                detailItem('Invested Amount',
                    '$rupeeSymbol ${currencyFormatter.format(1000 * (index + 1))}'),
                detailItem('Income',
                    '$rupeeSymbol ${currencyFormatter.format(0.5 * 1000 * (index + 1))}'),
                detailItem('Total',
                    '$rupeeSymbol ${currencyFormatter.format((1000 * (index + 1)) + (0.5 * 1000 * (index + 1)))}'),
                detailItem('Status', 'Completed', valueColor: Colors.green),
                detailItem('Investment Time', '1$index Jan, 2023 1$index:50'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  running() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => InkWell(
        onTap: () => context.push(
          AiSetDetailScreen.transactionDetailScreenRoute
              .replaceAll(':txnId', '$index'),
        ),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Set #${index + 1}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColorDark,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 10,
                    ),
                  ],
                ),
                detailItem('Invested Amount',
                    '$rupeeSymbol ${currencyFormatter.format(1000 * (index + 1))}'),
                detailItem('Income',
                    '$rupeeSymbol ${currencyFormatter.format(0.5 * 1000 * (index + 1))}'),
                detailItem('Total',
                    '$rupeeSymbol ${currencyFormatter.format((1000 * (index + 1)) + (0.5 * 1000 * (index + 1)))}'),
                detailItem('Status', 'Running', valueColor: Colors.orange),
                detailItem('Investment Time', '1$index Jan, 2023 1$index:50'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row detailItem(String key, String value,
      {Color? keyColor, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: keyColor ?? textColorDark,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: valueColor ?? textColorLight,
              ),
        ),
      ],
    );
  }
}
