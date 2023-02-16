import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/transaction_activity_model.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:iamsmart/service/storage_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/email_generator.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/util/utilities.dart';
import 'package:iamsmart/widget/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:string_validator/string_validator.dart';

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
  File? imageFile;
  bool isAgreementChecked = false;
  bool isPostingTransaction = false;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
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
                  depositToUserWalletPrompt,
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
                    setState(() {
                      _selectedPaymentMode = value!;
                    });
                  },
                ),
              ),
              getPayeeAccountDetail(),
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
                          'You are about to submit a transaction record of $rupeeSymbol ${currencyFormatter.format(double.parse(_amountCtrl.text))}, which can not be reversed.',
                      btnCancelOnPress: () {
                        context.pop();
                      },
                      btnOkOnPress: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (_amountCtrl.text.isEmpty ||
                            !isFloat(_amountCtrl.text)) {
                          SnackBarService.instance
                              .showSnackBarError('Amount is invalid');
                          context.pop();
                          return;
                        }
                        if (_selectedPaymentMode.isEmpty) {
                          SnackBarService.instance
                              .showSnackBarError('Payment is not selected');
                          context.pop();
                          return;
                        }
                        if (imageFile == null) {
                          SnackBarService.instance.showSnackBarError(
                              'Select transaction proof image');
                          context.pop();
                          return;
                        }
                        if (!isAgreementChecked) {
                          SnackBarService.instance.showSnackBarError(
                              'Please check the agreement checkbox');
                          context.pop();
                          return;
                        }
                        context.pop();
                        setState(() {
                          isPostingTransaction = true;
                        });

                        await StorageService.uploadTransactionProof(imageFile!)
                            .then((fileDownloadUrl) async {
                          TransactionModel txn = TransactionModel(
                              amount: double.parse(_amountCtrl.text),
                              assignedTo: Party.admin.name,
                              creditParty: Party.userWallet.name,
                              debitParty: Party.userExternal.name,
                              status: PaymentStatus.pending.name,
                              transactionActivity: [
                                TransactionActivityModel(
                                  comment:
                                      'Depost to user wallet | $rupeeSymbol ${_amountCtrl.text}',
                                  createdAt: DateTime.now(),
                                )
                              ],
                              transactionMode: _selectedPaymentMode,
                              user: userProfile,
                              transactionScreenshot: fileDownloadUrl,
                              createdAt: DateTime.now());

                          await DBService.instance
                              .addTransaction(txn)
                              .then((value) async {
                            await Utilities.sendEmail(
                              EmailGenerator().depositToUserWalletRequest(
                                userProfile,
                                currencyFormatter.format(txn.amount),
                                value.toString(),
                              ),
                            );
                            setState(() {
                              isPostingTransaction = false;
                            });
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.bottomSlide,
                              title: 'Success',
                              autoDismiss: false,
                              desc: depositToUserWalletPrompt,
                              btnOkOnPress: () {
                                resetFields();
                                setState(() {});
                                context.pop();
                              },
                              onDismissCallback: (type) {},
                              btnOkText: 'Okay',
                            ).show();
                          });
                        });
                      },
                      onDismissCallback: (type) {},
                      btnOkText: 'Submit',
                      btnCancelText: 'Cancel')
                  .show();
            },
            isDisabled: isPostingTransaction,
            label: 'Proceed'),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }

  void resetFields() {
    isImageSelected = false;
    _amountCtrl.text = '';
    _selectedPaymentMode = '';
    isAgreementChecked = false;
    imageFile = null;
  }

  getPayeeAccountDetail() {
    switch (_selectedPaymentMode) {
      case 'IMPS':
      case 'NEFT':
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: dividerColor),
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.all(defaultPadding / 2),
          margin: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              detailItem(
                'Account Holder',
                'Visu Technologies Private Limited',
              ),
              detailItem(
                'Account Number',
                '50200059883509',
              ),
              detailItem(
                'Account Type',
                'Current Account',
              ),
              detailItem(
                'IFSC Code',
                'HDFC0000632',
              ),
              detailItem(
                'Branch',
                'Alwal',
              ),
            ],
          ),
        );

      case 'PayPal':
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: dividerColor),
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.all(defaultPadding / 2),
          margin: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              detailItem(
                'PayPal Id',
                'visu.3006@gmail.com',
              ),
            ],
          ),
        );
      case 'UPI ID':
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: dividerColor),
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.all(defaultPadding / 2),
          margin: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              detailItem(
                'UPI Id',
                'visutechnologies@ybl',
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Row detailItem(String key, String value,
      {Color? keyColor, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            key,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: keyColor ?? textColorDark,
                ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: valueColor ?? textColorLight,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
