import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:string_validator/string_validator.dart';

import '../main.dart';
import '../model/transaction_activity_model.dart';
import '../model/transaction_model.dart';
import '../model/user_profile.dart';
import '../service/db_service.dart';
import '../service/snakbar_service.dart';
import '../util/constants.dart';
import '../util/preference_key.dart';
import '../util/theme.dart';
import '../widget/button_active.dart';
import '../widget/custom_textfield.dart';
import '../widget/heading.dart';

class WithdrawFromUserWalletScreen extends StatefulWidget {
  const WithdrawFromUserWalletScreen({super.key});
  static const String transferFromUserWalletRoute =
      '/mainContainer/assets/withdrawFromUserWalletScreen';
  @override
  State<WithdrawFromUserWalletScreen> createState() =>
      _WithdrawFromUserWalletScreenState();
}

class _WithdrawFromUserWalletScreenState
    extends State<WithdrawFromUserWalletScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  bool isPostingTransaction = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Withdraw'),
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
              Visibility(
                visible: !checkIfBankDetailsAdded(),
                child: Container(
                  margin: const EdgeInsets.all(defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(defaultPadding / 2)),
                  child: Text(
                    'You have not provided your bank details. Kindly update the same in Profile Detail section.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ),
              ),
              Visibility(
                visible: checkIfBankDetailsAdded(),
                child: Container(
                  margin: const EdgeInsets.all(defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  decoration: BoxDecoration(
                      color: hintColor.withOpacity(0.1),
                      border: Border.all(color: hintColor),
                      borderRadius: BorderRadius.circular(defaultPadding / 2)),
                  child: Text(
                    'Bank Name : ${userProfile.bankAccountName}\nAccount Number : ${userProfile.bankAccountNumber}\nBranch Code : ${userProfile.bankBranchCode}\nIFSC Code : ${userProfile.bankIFSCCode}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: textColorDark),
                  ),
                ),
              ),
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
            if (double.parse(_amountCtrl.text) < 100) {
              SnackBarService.instance.showSnackBarError(
                  'Minimum transaction amount is $rupeeSymbol 100');
              return;
            }
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.bottomSlide,
                    title: 'Do you want to transfer?',
                    autoDismiss: false,
                    desc:
                        'You are about to withdraw $rupeeSymbol ${currencyFormatter.format(double.parse(_amountCtrl.text))}, which can not be reversed.',
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
                          creditParty: Party.userExternal.name,
                          debitParty: Party.userWallet.name,
                          status: PaymentStatus.pending.name,
                          transactionActivity: [
                            TransactionActivityModel(
                              comment:
                                  'Withdraw from user wallet | $rupeeSymbol ${_amountCtrl.text}',
                              createdAt: DateTime.now(),
                            )
                          ],
                          transactionMode: '',
                          user: userProfile,
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
          isDisabled: isPostingTransaction || !checkIfBankDetailsAdded(),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }

  bool checkIfBankDetailsAdded() {
    return (userProfile.bankAccountName!.isNotEmpty &&
        userProfile.bankAccountNumber!.isNotEmpty &&
        userProfile.bankBranchCode!.isNotEmpty &&
        userProfile.bankIFSCCode!.isNotEmpty);
  }
}
