import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/transaction/transaction_detail_screen.dart';

import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../widget/heading.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Heading(title: 'Record'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Deposit'),
              Tab(text: 'Transfer'),
              Tab(text: 'Redeem'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            deposit(),
            transfer(),
            redeem(),
            all(),
          ],
        ),
      ),
    );
  }

  all() {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  index % 2 == 0
                      ? FontAwesomeIcons.arrowRightFromBracket
                      : index % 3 == 0
                          ? FontAwesomeIcons.arrowRightToBracket
                          : FontAwesomeIcons.arrowsLeftRight,
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                index % 2 == 0
                    ? 'Deposit to User wallet'
                    : index % 3 == 0
                        ? 'Transfered to User Wallet'
                        : 'Transfered to AI wallet',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index % 2 == 0
                        ? 'Rejected'
                        : index % 3 == 0
                            ? 'Approved'
                            : 'Pending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: index % 2 == 0
                              ? Colors.red.withOpacity(0.7)
                              : index % 3 == 0
                                  ? Colors.green.withOpacity(0.7)
                                  : Colors.orange.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    '${index + 1} days ago',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: '$index',
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(10000 * (index + 1))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', '$index'),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: 15);
  }

  redeem() {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: const Icon(
                  FontAwesomeIcons.arrowRightToBracket,
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: const Text(
                'Transfered to User Wallet',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index % 2 == 0
                        ? 'Rejected'
                        : index % 3 == 0
                            ? 'Approved'
                            : 'Pending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: index % 2 == 0
                              ? Colors.red.withOpacity(0.7)
                              : index % 3 == 0
                                  ? Colors.green.withOpacity(0.7)
                                  : Colors.orange.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    '${index + 1} days ago',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: '$index',
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(10000 * (index + 1))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', '$index'),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: 5);
  }

  transfer() {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: const Icon(
                  FontAwesomeIcons.arrowsLeftRight,
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: const Text(
                'Transfered to AI wallet',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index % 2 == 0
                        ? 'Rejected'
                        : index % 3 == 0
                            ? 'Approved'
                            : 'Pending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: index % 2 == 0
                              ? Colors.red.withOpacity(0.7)
                              : index % 3 == 0
                                  ? Colors.green.withOpacity(0.7)
                                  : Colors.orange.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    '${index + 1} days ago',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: '$index',
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(10000 * (index + 1))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', '$index'),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: 5);
  }

  deposit() {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: const Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: const Text(
                'Deposit to User wallet',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index % 2 == 0
                        ? 'Rejected'
                        : index % 3 == 0
                            ? 'Approved'
                            : 'Pending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: index % 2 == 0
                              ? Colors.red.withOpacity(0.7)
                              : index % 3 == 0
                                  ? Colors.green.withOpacity(0.7)
                                  : Colors.orange.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    '${index + 1} days ago',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: '$index',
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(10000 * (index + 1))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', '$index'),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: 5);
  }
}
