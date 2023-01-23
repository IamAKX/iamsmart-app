import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/theme.dart';

import '../../util/constants.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key, required this.txnId});
  static const String transactionDetailScreenRoute =
      '/mainContainer/transaction/transactionDetail/:txnId';
  final String txnId;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: userWalletColorDark,
      body: getBody(),
    );
  }

  getBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                userWalletColorDark,
                userWalletColorLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: defaultPadding * 3.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Hero(
                  tag: widget.txnId,
                  child: Text(
                    '$rupeeSymbol ${currencyFormatter.format(10000 * (int.parse(widget.txnId) + 1))}',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  'Txn ID : hkjhiudsKJGEAH${widget.txnId}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 5,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 180,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultPadding * 2),
                topRight: Radius.circular(
                  defaultPadding * 2,
                ),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'Transfer to User Wallet',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                detailItem('Timestamp', '15 Jan,2023 23:11:34'),
                detailItem('Status', 'Pending approval',
                    valueColor: Colors.orange.withOpacity(0.7)),
                detailItem('Payment Mode', 'IMPS'),
                detailItem('Payment Proof', 'View image',
                    valueColor: Colors.blue),
              ],
            ),
          ),
        ),
      ],
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
