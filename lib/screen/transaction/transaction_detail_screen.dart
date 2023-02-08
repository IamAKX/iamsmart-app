import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/util/utilities.dart';

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
  TransactionModel? transaction;

  @override
  void initState() {
    super.initState();
    getTransactionDetail();
  }

  getTransactionDetail() async {
    await DBService.instance.getTransactionById(widget.txnId).then((value) {
      setState(() {
        transaction = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: userWalletColorDark,
      body: getBody(),
    );
  }

  getBody() {
    if (transaction == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                    '$rupeeSymbol ${currencyFormatter.format(transaction?.amount)}',
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
                  'Txn ID : ${widget.txnId}',
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
                detailItem(
                    'Timestamp', Utilities.formatDate(transaction!.createdAt!)),
                detailItem('Status', transaction?.status ?? '',
                    valueColor: getStatusColor(transaction?.status ?? '')),
                detailItem('Payment Mode', transaction?.transactionMode ?? ''),
                if (transaction!.transactionScreenshot?.isNotEmpty ?? false)
                  InkWell(
                    child: detailItem('Payment Proof', 'View image',
                        valueColor: Colors.blue),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Widget cancelButton = TextButton(
                            child: const Text("Close"),
                            onPressed: () {
                              context.pop();
                            },
                          );
                          return AlertDialog(
                            title: const Text('Transaction Proof'),
                            actions: [cancelButton],
                            content: CachedNetworkImage(
                              imageUrl:
                                  transaction?.transactionScreenshot ?? '',
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Center(
                                child: Text(
                                  error.toString(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                InkWell(
                  child: detailItem(
                    'Transaction Activity',
                    'View',
                    valueColor: Colors.blue,
                  ),
                  onTap: () {
                    Utilities.showActivityLogPopup(
                        transaction?.transactionActivity, context);
                  },
                ),
                detailItem('Credit', transaction?.creditParty ?? ''),
                detailItem('Debit', transaction?.debitParty ?? ''),
                detailItem(
                    'User Id', transaction?.user?.id?.substring(0, 10) ?? ''),
                const SizedBox(
                  height: defaultPadding,
                ),
                Visibility(
                  visible: transaction?.status == PaymentStatus.rejected.name,
                  child: Text(
                    'Rejection reason',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: textColorLight),
                  ),
                ),
                Visibility(
                  visible: transaction?.status == PaymentStatus.rejected.name,
                  child: Text(
                    transaction?.rejectionComment ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: textColorDark),
                  ),
                )
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
