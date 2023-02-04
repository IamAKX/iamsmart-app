import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:intl/intl.dart';

import '../model/transaction_activity_model.dart';

class Utilities {
  static IconData getIconForTransaction(TransactionModel txn) {
    if (txn.debitParty == Party.userExternal.name &&
        txn.creditParty == Party.userWallet.name) {
      return FontAwesomeIcons.arrowRightFromBracket;
    }
    if (txn.debitParty == Party.userWallet.name &&
        txn.creditParty == Party.aiWallet.name) {
      return FontAwesomeIcons.arrowRightArrowLeft;
    }
    if (txn.debitParty == Party.admin.name &&
        txn.creditParty == Party.userWallet.name) {
      return FontAwesomeIcons.arrowRightToBracket;
    }
    if (txn.debitParty == Party.userWallet.name &&
        txn.creditParty == Party.userExternal.name) {
      return FontAwesomeIcons.coins;
    }
    return FontAwesomeIcons.circleDollarToSlot;
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random rnd = Random();
    int length = 6;
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static void showActivityLogPopup(
      List<TransactionActivityModel>? transactionActivity,
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Activity log'),
          actions: [
            OutlinedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Builder(
            builder: (context) {
              return SizedBox(
                // height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                          title:
                              Text(transactionActivity?[index].comment ?? ''),
                          subtitle: Text(Utilities.formatDate(
                              transactionActivity![index].createdAt!)),
                        ),
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: transactionActivity?.length ?? 0),
              );
            },
          ),
        );
      },
    );
  }
}
