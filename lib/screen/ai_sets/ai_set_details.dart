import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/theme.dart';

import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class AiSetDetailScreen extends StatefulWidget {
  const AiSetDetailScreen({super.key, required this.txnId});
  static const String transactionDetailScreenRoute =
      '/mainContainer/assets/aiSetDetail/:txnId';
  final String txnId;

  @override
  State<AiSetDetailScreen> createState() => _AiSetDetailScreenState();
}

class _AiSetDetailScreenState extends State<AiSetDetailScreen> {
  String _selectedPaymentMode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Set Detail'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        detailItem('Invested Amount',
            '$rupeeSymbol ${currencyFormatter.format(1000 * (int.parse(widget.txnId) + 1))}'),
        detailItem('Income',
            '$rupeeSymbol ${currencyFormatter.format(0.5 * 1000 * (int.parse(widget.txnId) + 1))}'),
        detailItem('Total',
            '$rupeeSymbol ${currencyFormatter.format((1000 * (int.parse(widget.txnId) + 1)) + (0.5 * 1000 * (int.parse(widget.txnId) + 1)))}'),
        detailItem('Status', 'Running', valueColor: Colors.orange),
        detailItem('Investment Time',
            '1${widget.txnId} Jan, 2023 1${widget.txnId}:50'),
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: DropdownSearch<String>(
            mode: Mode.MENU,
            dropDownButton: const Icon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: textColorLight,
            ),
            showSelectedItems: true,
            selectedItem: _selectedPaymentMode,
            label: 'Payment Mode',
            items: withdrawlPaymentModeList,
            onChanged: (value) {
              _selectedPaymentMode = value!;
            },
          ),
        ),
        ActiveButton(
            onPressed: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.bottomSlide,
                      title: 'Do you want to submit?',
                      autoDismiss: false,
                      desc:
                          'You are about to complete the set and transfer $rupeeSymbol ${currencyFormatter.format((1000 * (int.parse(widget.txnId) + 1)) + (0.5 * 1000 * (int.parse(widget.txnId) + 1)))} to user wallet, which can not be reversed.',
                      btnCancelOnPress: () {
                        context.pop();
                      },
                      btnOkOnPress: () {
                        context.pop();
                      },
                      onDismissCallback: (type) {},
                      btnOkText: 'Submit',
                      btnCancelText: 'Cancel')
                  .show();
            },
            label: 'Proceed'),
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
