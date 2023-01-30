import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:string_validator/string_validator.dart';

import '../../main.dart';
import '../../model/transaction_activity_model.dart';
import '../../model/transaction_model.dart';
import '../../service/snakbar_service.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class TransferToAIWalletScreen extends StatefulWidget {
  const TransferToAIWalletScreen({super.key});
  static const String transferToAIWalletRoute =
      '/mainContainer/assets/transferToAIWallet';
  @override
  State<TransferToAIWalletScreen> createState() =>
      _TransferToAIWalletScreenState();
}

class _TransferToAIWalletScreenState extends State<TransferToAIWalletScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  bool isPostingTransaction = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Transfer to AI'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(
                  transferToUserWalletPrompt,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  'You can transfer at max $rupeeSymbol ${currencyFormatter.format(userProfile.userWalletBalance)}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              CustomTextField(
                  hint: 'Amount',
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  obscure: false,
                  icon: FontAwesomeIcons.coins),
            ],
          ),
        ),
        ActiveButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_amountCtrl.text.isEmpty || !isFloat(_amountCtrl.text)) {
              SnackBarService.instance.showSnackBarError('Amount is invalid');
              return;
            }
            if (double.parse(_amountCtrl.text) >
                userProfile.userWalletBalance!) {
              SnackBarService.instance.showSnackBarError(
                  'You can transfer at max $rupeeSymbol ${currencyFormatter.format(userProfile.userWalletBalance)}');
              return;
            }
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.bottomSlide,
                    title: 'Do you want to transfer?',
                    autoDismiss: false,
                    desc:
                        'You are about to transfer $rupeeSymbol ${currencyFormatter.format(double.parse(_amountCtrl.text))} to AI wallet, which can not be reversed.',
                    btnCancelOnPress: () {
                      context.pop();
                    },
                    btnOkOnPress: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.pop();
                      setState(() {
                        isPostingTransaction = true;
                      });
                      TransactionModel txn = TransactionModel(
                          amount: double.parse(_amountCtrl.text),
                          assignedTo: Party.admin.name,
                          creditParty: Party.aiWallet.name,
                          debitParty: Party.userWallet.name,
                          status: PaymentStatus.pending.name,
                          transactionActivity: [
                            TransactionActivityModel(
                              comment: 'Transfer to AI',
                              createdAt: DateTime.now(),
                            )
                          ],
                          transactionMode: '',
                          userId: userProfile.id,
                          transactionScreenshot: '',
                          createdAt: DateTime.now());

                      DBService.instance.addTransaction(txn).then((value) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          title: 'Success',
                          autoDismiss: false,
                          desc: transferToUserWalletPrompt,
                          btnOkOnPress: () {
                            _amountCtrl.text = '';
                            setState(() {
                              isPostingTransaction = false;
                            });
                            context.pop();
                          },
                          onDismissCallback: (type) {},
                          btnOkText: 'Okay',
                        ).show();
                      });
                    },
                    onDismissCallback: (type) {},
                    btnOkText: 'Transfer',
                    btnCancelText: 'Cancel')
                .show();
          },
          label: 'Proceed',
          isDisabled: isPostingTransaction,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
