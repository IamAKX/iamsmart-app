import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/button_active.dart';

import '../../util/colors.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});
  static const String profileDetailRoute =
      '/mainContainer/settings/profileDetail';

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _bankAccountNameCtrl = TextEditingController();
  final TextEditingController _bankAccountNumberCtrl = TextEditingController();
  final TextEditingController _bankBranchNameCtrl = TextEditingController();
  final TextEditingController _bankIFSCCtrl = TextEditingController();
  // New field
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _rAddress1 = TextEditingController();
  final TextEditingController _rAddress2 = TextEditingController();
  final TextEditingController _rAddress3 = TextEditingController();
  final TextEditingController _rAddress4 = TextEditingController();
  final TextEditingController _cAddress1 = TextEditingController();
  final TextEditingController _cAddress2 = TextEditingController();
  final TextEditingController _cAddress3 = TextEditingController();
  final TextEditingController _cAddress4 = TextEditingController();

  late UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    userProfile = UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    loadSavedData();
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Profile Details'),
      ),
      body: getBody(),
    );
  }

  loadSavedData() {
    _emailCtrl.text = userProfile.email ?? '';
    _nameCtrl.text = userProfile.name ?? '';
    _bankAccountNameCtrl.text = userProfile.bankAccountName ?? '';
    _bankAccountNumberCtrl.text = userProfile.bankAccountNumber ?? '';
    _bankBranchNameCtrl.text = userProfile.bankBranchCode ?? '';
    _bankIFSCCtrl.text = userProfile.bankIFSCCode ?? '';
  }

  getBody() {
    return ListView(
      children: [
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            'Personal Details *',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: textColorLight,
                ),
          ),
        ),
        CustomTextField(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          enabled: false,
          icon: FontAwesomeIcons.solidEnvelope,
        ),
        CustomTextField(
          hint: 'Name as on Aadhaar card / PAN card',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
        ),
        CustomTextField(
          hint: 'Phone Number',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: FontAwesomeIcons.phone,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            'Residential Address',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: textColorLight,
                ),
          ),
        ),
        CustomTextField(
          hint: 'Street1, Street2',
          controller: _rAddress1,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'Area, Locality, District',
          controller: _rAddress2,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'State',
          controller: _rAddress3,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'Pincode',
          controller: _rAddress4,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            'Communication Address *',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: textColorLight,
                ),
          ),
        ),
        CustomTextField(
          hint: 'Street1, Street2',
          controller: _cAddress1,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'Area, Locality, District',
          controller: _cAddress2,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'State',
          controller: _cAddress3,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        CustomTextField(
          hint: 'Pincode',
          controller: _cAddress4,
          keyboardType: TextInputType.streetAddress,
          obscure: false,
          icon: FontAwesomeIcons.home,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            'Bank Details',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: textColorLight,
                ),
          ),
        ),
        CustomTextField(
          hint: 'Bank Name',
          controller: _bankAccountNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
        ),
        CustomTextField(
          hint: 'Bank Account Number',
          controller: _bankAccountNumberCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
        ),
        CustomTextField(
          hint: 'Bank Branch Name',
          controller: _bankBranchNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
        ),
        CustomTextField(
          hint: 'Branch IFSC Code',
          controller: _bankIFSCCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_emailCtrl.text.isEmpty ||
                _nameCtrl.text.isEmpty ||
                _phoneCtrl.text.isEmpty ||
                _cAddress1.text.isEmpty ||
                _cAddress2.text.isEmpty ||
                _cAddress3.text.isEmpty ||
                _cAddress4.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('Please fill in all mandatory fields');
              return;
            }
            userProfile.name = _nameCtrl.text;
            userProfile.bankAccountName = _bankAccountNameCtrl.text;
            userProfile.bankAccountNumber = _bankAccountNumberCtrl.text;
            userProfile.bankBranchCode = _bankBranchNameCtrl.text;
            userProfile.bankIFSCCode = _bankIFSCCtrl.text;
            userProfile.phone = _phoneCtrl.text;
            userProfile.residencialAddress1 = _rAddress1.text;
            userProfile.residencialAddress2 = _rAddress2.text;
            userProfile.residencialAddress3 = _rAddress3.text;
            userProfile.residencialAddress4 = _rAddress4.text;
            userProfile.communicationAddress1 = _cAddress1.text;
            userProfile.communicationAddress2 = _cAddress2.text;
            userProfile.communicationAddress3 = _cAddress3.text;
            userProfile.communicationAddress4 = _cAddress4.text;
            await DBService.instance
                .updateProfile(userProfile.id!, userProfile.toMap(), context)
                .then((value) {
              prefs.setString(PreferenceKey.user, userProfile.toJson());
              setState(() {});
            });
          },
          label: 'Update',
        ),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
