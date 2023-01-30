import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/button_active.dart';

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
  late UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    userProfile = UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    loadSavedData();
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Profile Detail'),
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
        CustomTextField(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          enabled: false,
          icon: FontAwesomeIcons.solidEnvelope,
        ),
        CustomTextField(
          hint: 'Name',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.solidUser,
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
            userProfile.name = _nameCtrl.text;
            userProfile.bankAccountName = _bankAccountNameCtrl.text;
            userProfile.bankAccountNumber = _bankAccountNumberCtrl.text;
            userProfile.bankBranchCode = _bankBranchNameCtrl.text;
            userProfile.bankIFSCCode = _bankIFSCCtrl.text;
            await DBService.instance
                .updateProfile(userProfile.id!, userProfile.toMap(), context)
                .then((value) {
              prefs.setString(PreferenceKey.user, userProfile.toJson());
              setState(() {});
            });
          },
          label: 'Update',
        )
      ],
    );
  }
}
