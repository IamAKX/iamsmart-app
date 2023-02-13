import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/transaction/transaction_detail_screen.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:iamsmart/util/utilities.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../main.dart';
import '../../model/transaction_model.dart';
import '../../model/user_profile.dart';
import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../util/preference_key.dart';
import '../../widget/heading.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({
    Key? key,
    required this.txnIndex,
    required this.switchTab,
  }) : super(key: key);
  final int txnIndex;
  final Function(int index, int txnIndex) switchTab;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionModel> txnList = [];
  List<TransactionModel> depositList = [];
  List<TransactionModel> transferList = [];
  List<TransactionModel> redeemList = [];
  List<TransactionModel> withdrawList = [];
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

  @override
  void initState() {
    super.initState();
    getAllTxns();
  }

  void getAllTxns() async {
    txnList = await DBService.instance.getAllTransactions(userProfile.id!);

    depositList = txnList
        .where((txn) =>
            txn.debitParty! == Party.userExternal.name &&
            txn.creditParty! == Party.userWallet.name)
        .toList();
    transferList = txnList
        .where((txn) =>
            txn.debitParty! == Party.userWallet.name &&
            txn.creditParty! == Party.aiWallet.name)
        .toList();
    redeemList = txnList
        .where((txn) =>
            txn.debitParty! == Party.aiWallet.name &&
            txn.creditParty! == Party.userWallet.name)
        .toList();
    withdrawList = txnList
        .where((txn) =>
            txn.debitParty! == Party.userWallet.name &&
            txn.creditParty! == Party.userExternal.name)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return WillPopScope(
      onWillPop: () async {
        widget.switchTab(0, 0);
        return false;
      },
      child: DefaultTabController(
        initialIndex: widget.txnIndex,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Heading(title: 'Record'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Deposit'),
                Tab(text: 'Transfer'),
                Tab(text: 'Redeem'),
                Tab(text: 'Withdraw'),
                Tab(text: 'All'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              deposit(),
              transfer(),
              redeem(),
              withdraw(),
              all(),
            ],
          ),
        ),
      ),
    );
  }

  all() {
    if (txnList.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  Utilities.getIconForTransaction(txnList.elementAt(index)),
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                txnList.elementAt(index).transactionActivity?.first.comment ??
                    'Transaction',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txnList.elementAt(index).status ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: getStatusColor(
                              txnList.elementAt(index).status ?? ''),
                        ),
                  ),
                  Text(
                    timeago.format(txnList.elementAt(index).createdAt!),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: txnList.elementAt(index).id!,
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(txnList.elementAt(index).amount)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', txnList.elementAt(index).id!),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: txnList.length);
  }

  redeem() {
    if (redeemList.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  Utilities.getIconForTransaction(redeemList.elementAt(index)),
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                redeemList
                        .elementAt(index)
                        .transactionActivity
                        ?.first
                        .comment ??
                    '',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    redeemList.elementAt(index).status ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: getStatusColor(
                              redeemList.elementAt(index).status ?? ''),
                        ),
                  ),
                  Text(
                    timeago.format(redeemList.elementAt(index).createdAt!),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: redeemList.elementAt(index).id!,
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(redeemList.elementAt(index).amount)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', redeemList.elementAt(index).id!),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: redeemList.length);
  }

  transfer() {
    if (transferList.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  Utilities.getIconForTransaction(
                      transferList.elementAt(index)),
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                transferList
                        .elementAt(index)
                        .transactionActivity
                        ?.first
                        .comment ??
                    '',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transferList.elementAt(index).status ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: getStatusColor(
                              transferList.elementAt(index).status ?? ''),
                        ),
                  ),
                  Text(
                    timeago.format(transferList.elementAt(index).createdAt!),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: transferList.elementAt(index).id!,
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(transferList.elementAt(index).amount)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', transferList.elementAt(index).id!),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: transferList.length);
  }

  deposit() {
    if (depositList.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  Utilities.getIconForTransaction(depositList.elementAt(index)),
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                depositList
                        .elementAt(index)
                        .transactionActivity
                        ?.first
                        .comment ??
                    '',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    depositList.elementAt(index).status ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: getStatusColor(
                            depositList.elementAt(index).status ?? '')),
                  ),
                  Text(
                    timeago.format(depositList.elementAt(index).createdAt!),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: depositList.elementAt(index).id!,
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(depositList.elementAt(index).amount!)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', depositList.elementAt(index).id!),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: depositList.length);
  }

  withdraw() {
    if (withdrawList.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(
                  Utilities.getIconForTransaction(
                      withdrawList.elementAt(index)),
                  size: 18,
                  color: bottomNavbarActiveColor,
                ),
              ),
              title: Text(
                withdrawList
                        .elementAt(index)
                        .transactionActivity
                        ?.first
                        .comment ??
                    '',
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    withdrawList.elementAt(index).status ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: getStatusColor(
                            withdrawList.elementAt(index).status ?? '')),
                  ),
                  Text(
                    timeago.format(withdrawList.elementAt(index).createdAt!),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Hero(
                tag: withdrawList.elementAt(index).id!,
                child: Text(
                  '$rupeeSymbol ${currencyFormatter.format(withdrawList.elementAt(index).amount!)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () => context.push(
                TransactionDetailScreen.transactionDetailScreenRoute
                    .replaceFirst(':txnId', withdrawList.elementAt(index).id!),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
        itemCount: withdrawList.length);
  }
}
