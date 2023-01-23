import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Profile Detail'),
      ),
      body: getBody(),
    );
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
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Update',
        )
      ],
    );
  }
}
