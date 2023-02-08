import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/set_model.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/util/utilities.dart';
import 'package:iamsmart/widget/custom_textfield.dart';
import 'package:string_validator/string_validator.dart';

import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class AiSetDetailScreen extends StatefulWidget {
  const AiSetDetailScreen({super.key, required this.txnId});
  static const String aiSetDetailScreenRoute =
      '/mainContainer/assets/aiSetDetail/:txnId';
  final String txnId;

  @override
  State<AiSetDetailScreen> createState() => _AiSetDetailScreenState();
}

class _AiSetDetailScreenState extends State<AiSetDetailScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  SetModel? set;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadSet(),
    );
  }

  loadSet() async {
    set = await DBService.instance.getSetById(widget.txnId);
    _amountCtrl.text = set?.amount.toString() ?? '0';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Set Detail'),
      ),
      body: set == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getBody(),
    );
  }

  getBody() {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        detailItem('Invested Amount',
            '$rupeeSymbol ${currencyFormatter.format(set!.amount)}'),
        detailItem(
            'Income', '$rupeeSymbol ${currencyFormatter.format(set!.income)}'),
        // detailItem('Total',
        //     '$rupeeSymbol ${currencyFormatter.format((1000 * (int.parse(widget.txnId) + 1)) + (0.5 * 1000 * (int.parse(widget.txnId) + 1)))}'),
        detailItem('Status', set!.status!,
            valueColor: getStatusColor(set!.status!)),
        detailItem(
          'Investment Time',
          Utilities.formatDate(set!.createdAt!),
        ),
        const SizedBox(
          height: defaultPadding * 2,
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: Text(
        //     'Withdraw complete/partial amount',
        //     style: Theme.of(context).textTheme.subtitle1?.copyWith(
        //           color: textColorDark,
        //           fontWeight: FontWeight.bold,
        //         ),
        //   ),
        // ),
        // CustomTextField(
        //   hint: 'Amount',
        //   controller: _amountCtrl,
        //   keyboardType: TextInputType.number,
        //   obscure: false,
        //   icon: FontAwesomeIcons.coins,
        // ),
        Visibility(
          visible: set!.status == SetStatus.running.name,
          child: ActiveButton(
              onPressed: () {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.bottomSlide,
                        title: 'Do you want to submit?',
                        autoDismiss: false,
                        desc:
                            'You are about to transfer $rupeeSymbol ${_amountCtrl.text} to user wallet, which can not be reversed.',
                        btnCancelOnPress: () {
                          context.pop();
                        },
                        btnOkOnPress: () async {
                          if (_amountCtrl.text.isEmpty ||
                              !isFloat(_amountCtrl.text)) {
                            SnackBarService.instance
                                .showSnackBarError('Amount is invalid');
                            context.pop();
                            return;
                          }

                          if (double.parse(_amountCtrl.text) > set!.amount!) {
                            SnackBarService.instance.showSnackBarError(
                                '$rupeeSymbol ${_amountCtrl.text} is more the available amount in set');
                            context.pop();
                            return;
                          }

                          await DBService.instance.withdrawSet(
                              set!, double.parse(_amountCtrl.text));
                          _amountCtrl.text = '';
                          context.pop();
                        },
                        onDismissCallback: (type) {
                          context.pop();
                        },
                        btnOkText: 'Submit',
                        btnCancelText: 'Cancel')
                    .show();
              },
              label: 'Close set'),
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
