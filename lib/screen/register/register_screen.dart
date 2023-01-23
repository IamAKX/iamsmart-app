import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../service/auth_provider.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/button_inactive.dart';
import '../../widget/custom_textfield.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String registerRoute = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
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
            height: 150.0,
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
          'Create account',
          style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 40),
        ),
        Expanded(
          child: ListView(
            children: [
              CustomTextField(
                hint: 'Name',
                controller: _nameCtrl,
                keyboardType: TextInputType.name,
                obscure: false,
                icon: FontAwesomeIcons.solidUser,
              ),
              CustomTextField(
                hint: 'Email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                obscure: false,
                icon: FontAwesomeIcons.solidEnvelope,
              ),
              CustomTextField(
                hint: 'Password',
                controller: _passwordCtrl,
                keyboardType: TextInputType.visiblePassword,
                obscure: true,
                icon: FontAwesomeIcons.lock,
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              ActiveButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_auth.status != AuthStatus.authenticating) {
                      _auth
                          .registerUserWithEmailAndPassword(_nameCtrl.text,
                              _emailCtrl.text, _passwordCtrl.text)
                          .then((value) {
                        if (value) {
                          context.go(LoginScreen.loginRoute);
                        }
                      });
                    }
                  },
                  label: 'Register'),
              InactiveButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.go(LoginScreen.loginRoute);
                  },
                  label: 'Sign In'),
            ],
          ),
        ),
      ],
    );
  }
}
