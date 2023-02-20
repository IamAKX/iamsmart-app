import 'package:flutter/material.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/ticket_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/screen/ticket/ticket_create.dart';
import 'package:iamsmart/screen/ticket/ticket_detail.dart';
import 'package:iamsmart/screen/transaction/transaction_detail_screen.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widget/heading.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});
  static const String ticketScreenRoute = '/mainContainer/ticket';

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<TicketModel> ticketList = [];
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

  @override
  void initState() {
    super.initState();
    getAllTickets();
  }

  getAllTickets() async {
    await DBService.instance.getAllTicketsById(userProfile.id!).then((value) {
      setState(() {
        ticketList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Ticket'),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TicketCreateScreen(),
                ),
              ).then((value) {
                getAllTickets();
              });
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailScreen(
                  ticketId: ticketList[index].id!,
                ),
              ),
            ).then((value) {
              getAllTickets();
            });
          },
          title: Text(ticketList[index].subject ?? ''),
          trailing: const Icon(Icons.chevron_right),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticketList[index].status!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: getStatusColor(ticketList[index].status!)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TXN ID : ${ticketList[index].id}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${timeago.format(ticketList.elementAt(index).createdAt!, locale: 'en_short')} ago',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: dividerColor,
        );
      },
      itemCount: ticketList.length,
    );
  }
}
