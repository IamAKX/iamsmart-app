import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/constants.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  'Transfered ammount can take upto 5 working hours to get approved',
                  style: Theme.of(context).textTheme.caption,
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
                      btnOkOnPress: () {
                        context.pop();
                      },
                      onDismissCallback: (type) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      btnOkText: 'Transfer',
                      btnCancelText: 'Cancel')
                  .show();
            },
            label: 'Proceed'),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
