import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:provider/provider.dart';

import '../../service/auth_provider.dart';
import '../../service/snakbar_service.dart';
import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String changePasswordRoute =
      '/mainContainer/settings/changePasswordRoute';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordCtrl = TextEditingController();
  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;

    _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'New Password'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      children: [
        const SizedBox(
          height: defaultPadding,
        ),
        CustomTextField(
          hint: 'New Password',
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
          obscure: true,
          icon: FontAwesomeIcons.lock,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            _auth.updatePassword(_passwordCtrl.text).then((value) {
              if (value) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.bottomSlide,
                  title: 'Success',
                  autoDismiss: false,
                  desc: 'Your password is updated',
                  btnOkOnPress: () {
                    _passwordCtrl.text = '';
                    context.pop();
                    context.pop();
                  },
                  onDismissCallback: (type) {},
                  btnOkText: 'Okay',
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.bottomSlide,
                  title: 'Failed',
                  autoDismiss: false,
                  desc: 'Failed to update your password. Report to admin.',
                  btnOkOnPress: () {
                    _passwordCtrl.text = '';
                    context.pop();
                  },
                  onDismissCallback: (type) {},
                  btnOkText: 'Okay',
                ).show();
              }
            });
          },
          label: 'Update',
        )
      ],
    );
  }
}
