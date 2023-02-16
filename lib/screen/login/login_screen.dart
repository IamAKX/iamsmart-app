import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/screen/forgotPassword/forgot_password_screen.dart';
import 'package:iamsmart/screen/mainContainer/main_container.dart';
import 'package:iamsmart/screen/register/register_screen.dart';
import 'package:iamsmart/service/local_auth_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../service/auth_provider.dart';
import '../../service/snakbar_service.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/button_inactive.dart';
import '../../widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String loginRoute = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  late AuthProvider _auth;
  bool showBiometricAuth = false;

  checkBiometricAuth() async {
    showBiometricAuth = (FirebaseAuth.instance.currentUser != null &&
        prefs.containsKey(PreferenceKey.user) &&
        await LocalAuthService.canAuthenticate() &&
        (prefs.getBool(PreferenceKey.isBiometricEnabled) ?? false));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkBiometricAuth();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;

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
            height: 180.0,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo_256.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              'IamSMART',
              style:
                  Theme.of(context).textTheme.headline1?.copyWith(fontSize: 40),
            )
          ],
        ),
        Expanded(
          child: ListView(
            children: [
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () =>
                      context.go(ForgotPasswordScreen.forgotPasswordRoute),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(
                      'Forgot Password ?',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              ActiveButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _auth
                      .loginUserWithEmailAndPassword(
                          _emailCtrl.text, _passwordCtrl.text)
                      .then((value) {
                    if (_auth.status == AuthStatus.authenticated) {
                      UserProfile profile = UserProfile.fromJson(
                          prefs.getString(PreferenceKey.user)!);
                      if (profile.isProfileSuspended ?? true) {
                        SnackBarService.instance
                            .showSnackBarError('Account suspended');
                      } else {
                        context.go(MainContainer.mainContainerRoute);
                      }
                    }
                  });
                },
                label: 'Sign In',
                isDisabled: _auth.status == AuthStatus.authenticating,
              ),
              InactiveButton(
                  onPressed: () => context.go(RegisterScreen.registerRoute),
                  label: 'Create Account'),
              const SizedBox(
                height: defaultPadding,
              ),
              if (showBiometricAuth)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      if (await LocalAuthService.authenticate()) {
                        UserProfile profile = UserProfile.fromJson(
                            prefs.getString(PreferenceKey.user)!);
                        if (profile.isProfileSuspended ?? true) {
                          SnackBarService.instance
                              .showSnackBarError('Account suspended');
                        } else {
                          context.go(MainContainer.mainContainerRoute);
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: primaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.fingerprint,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              if (showBiometricAuth)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Use biometric authentication',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
