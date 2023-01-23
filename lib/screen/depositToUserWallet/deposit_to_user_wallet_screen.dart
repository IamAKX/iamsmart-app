import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class DepositeToUserWalletScreen extends StatefulWidget {
  const DepositeToUserWalletScreen({super.key});
  static const String depositeToUserWalletRoute =
      '/mainContainer/assets/depositeToUserWallet';

  @override
  State<DepositeToUserWalletScreen> createState() =>
      _DepositeToUserWalletScreenState();
}

class _DepositeToUserWalletScreenState
    extends State<DepositeToUserWalletScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  String _selectedPaymentMode = '';
  bool isImageSelected = false;
  late File? imageFile;
  bool isAgreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Deposit'),
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
                  'Deposited amount can take upto 3 working days to get approved',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              CustomTextField(
                  hint: 'Amount',
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  obscure: false,
                  icon: FontAwesomeIcons.coins),
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
                  items: depositePaymentModeList,
                  onChanged: (value) {
                    _selectedPaymentMode = value!;
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                ),
                child: Text(
                  'Please attched the transaction proof',
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  height: 200,
                  width: 200,
                  child: !isImageSelected
                      ? InkWell(
                          child: Image.asset(
                            'assets/image/add-image.png',
                          ),
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              imageFile = File(image.path);

                              setState(() {
                                isImageSelected = true;
                              });
                            }
                          },
                        )
                      : SizedBox(
                          height: 200,
                          width: 200,
                          child: Stack(
                            children: [
                              Image.file(
                                imageFile!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 1,
                                top: 1,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        imageFile = null;
                                        isImageSelected = false;
                                      });
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    )),
                              )
                            ],
                          ),
                        ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isAgreementChecked,
                    onChanged: (value) {
                      setState(() {
                        isAgreementChecked = value ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'I have entered exact deposited amount and have attached the required transaction proof',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              )
            ],
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
                          'You are about to submit a transaction record, which can not be reversed.',
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
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
