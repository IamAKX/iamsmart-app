import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/ticket_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/button_active.dart';

import '../../service/snakbar_service.dart';
import '../../widget/heading.dart';

class TicketCreateScreen extends StatefulWidget {
  const TicketCreateScreen({super.key});
  static const String ticketCreateScreenRoute =
      '/mainContainer/ticket/ticketCreateScreenRoute';

  @override
  State<TicketCreateScreen> createState() => _TicketCreateScreenState();
}

class _TicketCreateScreenState extends State<TicketCreateScreen> {
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _bodyCtrl = TextEditingController();
  bool networkCallInProgress = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Create Ticket'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: TextField(
            keyboardType: TextInputType.name,
            autocorrect: true,
            controller: _subjectCtrl,
            maxLength: 100,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Subject',
              labelText: 'Subject',
              alignLabelWithHint: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: TextField(
            keyboardType: TextInputType.name,
            autocorrect: true,
            controller: _bodyCtrl,
            maxLines: 15,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Tyoe your complain here',
              labelText: 'Complaint',
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_subjectCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) {
              SnackBarService.instance.showSnackBarError(
                  'Subject and Complaint should not be empty');
              return;
            }
            setState(() {
              networkCallInProgress = !networkCallInProgress;
            });
            TicketModel ticket = TicketModel(
              user: UserProfile.fromJson(prefs.getString(PreferenceKey.user)!),
              createdAt: DateTime.now(),
              status: TicketStatus.open.name,
              subject: _subjectCtrl.text,
              text: _bodyCtrl.text,
              chats: [],
            );

            await DBService.instance.createTicket(ticket).then((value) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: 'Success',
                autoDismiss: false,
                desc: 'Your ticket is created. Ticket id is $value',
                btnOkOnPress: () {
                  context.pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onDismissCallback: (type) {
                  context.pop();
                },
                btnOkText: 'Okay',
              ).show();
            });
          },
          label: 'Create',
          isDisabled: networkCallInProgress,
        ),
      ],
    );
  }
}
