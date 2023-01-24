import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/login/login_screen.dart';
import 'package:provider/provider.dart';

import '../../service/auth_provider.dart';
import '../../service/snakbar_service.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/button_inactive.dart';
import '../../widget/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String forgotPasswordRoute = '/forgotPassword';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailCtrl = TextEditingController();

  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    return Column(
      children: [
        Hero(
          tag: 'header',
          child: Container(
            height: 230.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/loginHeader.png"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 40),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                child: Text(
                  'A password reset link will be sent to your registered Email',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              CustomTextField(
                hint: 'Registered Email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                obscure: false,
                icon: FontAwesomeIcons.solidEnvelope,
              ),
              ActiveButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _auth.forgotPassword(_emailCtrl.text);
                },
                label: 'Reset Password',
                isDisabled: _auth.status == AuthStatus.authenticating,
              ),
              InactiveButton(
                  onPressed: () => context.go(LoginScreen.loginRoute),
                  label: 'Sign In'),
            ],
          ),
        ),
      ],
    );
  }
}
