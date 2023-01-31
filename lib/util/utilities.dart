import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:intl/intl.dart';

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
}
