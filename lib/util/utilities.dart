import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../model/email_model.dart';
import '../model/transaction_activity_model.dart';
import '../model/user_profile.dart';
import '../service/db_service.dart';
import 'preference_key.dart';

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
    if (txn.debitParty == Party.reward.name &&
        txn.creditParty == Party.userWallet.name) {
      return FontAwesomeIcons.tags;
    }
    return FontAwesomeIcons.circleDollarToSlot;
  }

  static String formatDate(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return '-';
    }
  }

  static String formatDateShort(DateTime date) {
    try {
      return DateFormat('dd MMM').format(date);
    } catch (e) {
      return '-';
    }
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

  static Future<bool> checkForKycPrompt(BuildContext context) async {
    UserProfile profile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    profile = await DBService.instance.getUserById(profile.id!);
    prefs.setString(PreferenceKey.user, profile.toJson());
    if (profile.isKycDone ?? false) {
      return true;
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Action restricted',
        autoDismiss: false,
        desc: 'Please complete your KYC to continue with the transaction',
        btnOkOnPress: () {
          context.pop();
        },
        onDismissCallback: (type) {},
        btnOkText: 'Okay',
      ).show();
      return false;
    }
  }

  static Future<bool> sendEmail(EmailModel emailBody) async {
    Dio dio = Dio();
    String api =
        'https://us-central1-iamsmart-fee96.cloudfunctions.net/userFunction/v1/admin/sendEmail';
    var data = {
      "from": emailBody.from,
      "to": emailBody.to,
      "subject": emailBody.subject,
      "text": emailBody.text,
    };
    Response response = await dio.post(
      api,
      data: data,
      options: Options(
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );
    debugPrint(emailBody.toString());
    if (response.statusCode == 200) {
      debugPrint(response.data.toString());
      return true;
    } else {
      return false;
    }
  }
}
