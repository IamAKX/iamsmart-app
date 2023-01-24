import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/login/login_screen.dart';
import 'package:iamsmart/screen/setting/kyc_document_screen.dart';
import 'package:iamsmart/screen/setting/profile_details_screen.dart';
import 'package:provider/provider.dart';

import '../../service/auth_provider.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isBiometricEnabled = false;
  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Settings'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/image/user.png',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Edit picture',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: primaryColorDark,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: hintColor,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ListTile(
          title: const Text(
            'Profile Details',
          ),
          leading: const Icon(
            FontAwesomeIcons.userGear,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {
            context.push(ProfileDetailScreen.profileDetailRoute);
          },
        ),
        ListTile(
          title: const Text(
            'KYC Documents',
          ),
          leading: const Icon(
            FontAwesomeIcons.userCheck,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {
            context.push(KycDocumentScreen.kycDocumentRoute);
          },
        ),
        ListTile(
          title: const Text(
            'Change password',
          ),
          leading: const Icon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {},
        ),
        SwitchListTile(
          value: isBiometricEnabled,
          onChanged: (value) {
            setState(() {
              isBiometricEnabled = !isBiometricEnabled;
            });
          },
          title: const Text(
            'Enable biometric',
          ),
          secondary: const Icon(
            FontAwesomeIcons.fingerprint,
            size: 20,
          ),
        ),
        ListTile(
          title: const Text(
            'Logout',
          ),
          textColor: Colors.red,
          leading: const Icon(
            FontAwesomeIcons.rightFromBracket,
            color: Colors.red,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            color: Colors.red,
            size: 15,
          ),
          onTap: () {
            _auth
                .logoutUser()
                .then((value) => context.go(LoginScreen.loginRoute));
          },
        ),
      ],
    );
  }
}
