import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/ticket_model.dart';
import 'package:iamsmart/screen/ticket/ticket_chat_screen.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/util/utilities.dart';

import '../../service/snakbar_service.dart';
import '../../widget/heading.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});
  static const String ticketDetailScreenRoute =
      '/mainContainer/ticket/ticketDetailScreenRoute/:ticketId';
  final String ticketId;
  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  TicketModel? ticket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketDetail();
  }

  getTicketDetail() async {
    ticket = await DBService.instance.getTicketById(widget.ticketId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Ticket Detail'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (ticket == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          Text(
            ticket?.subject ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColorDark,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            ticket?.text ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: textColorLight),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          const Divider(
            color: dividerColor,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          detailItem('Transaction ID', ticket!.id!),
          detailItem(
            'Status',
            ticket!.status!,
            valueColor: getStatusColor(ticket!.status!),
          ),
          detailItem(
              'Created At',
              ticket?.createdAt == null
                  ? '-'
                  : Utilities.formatDate(ticket!.createdAt!)),
          detailItem(
              'Closed At',
              ticket?.closedAt == null
                  ? '-'
                  : Utilities.formatDate(ticket!.closedAt!)),
          detailItem('Closed by', '${ticket?.closedBy ?? '-'}'),
          const SizedBox(
            height: defaultPadding,
          ),
          if (ticket?.status != TicketStatus.closed.name)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Want to connect with our support team?',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: textColorLight),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketChatScreen(
                          ticketId: ticket!.id!,
                        ),
                      ),
                    ).then((value) {
                      getTicketDetail();
                    });
                  },
                  child: Text('Chat'),
                )
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'If your issue is resolved, you may close this ticket',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: textColorLight),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'Are you sure?',
                    autoDismiss: false,
                    desc: 'You are going to permanently close this ticket.',
                    btnOkOnPress: () async {
                      ticket?.status = TicketStatus.closed.name;
                      ticket?.closedAt = DateTime.now();
                      ticket?.closedBy = TicketParty.user.name;
                      await DBService.instance
                          .updateTicket(ticket!)
                          .then((value) {
                        context.pop();
                        context.pop();
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onDismissCallback: (type) {},
                    btnOkText: 'Proceed',
                    btnCancelText: 'Cancel',
                    btnCancelOnPress: () {
                      context.pop();
                    },
                  ).show();
                },
                child: Text(
                  'Close',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red),
                ),
              )
            ],
          ),
        ],
      );
    }
  }

  Row detailItem(String key, String value,
      {Color? keyColor, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: keyColor ?? textColorDark,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: valueColor ?? textColorLight,
              ),
        ),
      ],
    );
  }
}
