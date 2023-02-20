import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:iamsmart/model/tricket_chat_model.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';

import '../../model/ticket_model.dart';
import '../../service/db_service.dart';
import '../../service/snakbar_service.dart';
import '../../widget/heading.dart';

class TicketChatScreen extends StatefulWidget {
  const TicketChatScreen({super.key, required this.ticketId});
  static const String ticketChatScreenRoute =
      '/mainContainer/ticket/ticketChatScreenRoute';
  final String ticketId;

  @override
  State<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends State<TicketChatScreen> {
  TicketModel? ticket;
  final TextEditingController _textEditingController = TextEditingController();
  Timer? timer;
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    // _controller.jumpTo(_controller.position.maxScrollExtent);
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    getTicketDetail();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => getTicketDetail());
  }

  getTicketDetail() async {
    ticket = await DBService.instance.getTicketById(widget.ticketId);

    _scrollDown();

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Support Chat'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              return BubbleSpecialThree(
                text: ticket?.chats?.elementAt(index).text ?? '',
                color: ticket?.chats?.elementAt(index).createdBy ==
                        TicketParty.user.name
                    ? primaryColor
                    : dividerColor,
                tail: false,
                isSender: ticket?.chats?.elementAt(index).createdBy ==
                    TicketParty.user.name,
                textStyle: TextStyle(
                    color: (ticket?.chats?.elementAt(index).createdBy ==
                            TicketParty.user.name)
                        ? Colors.white
                        : textColorDark,
                    fontSize: 16),
              );
            },
            itemCount: ticket?.chats?.length ?? 0,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  minLines: 1,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Start typing...',
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    suffixIcon: InkWell(
                      onTap: () async {
                        if (_textEditingController.text.isNotEmpty) {
                          TicketChatModel textModel = TicketChatModel(
                            id: ((ticket?.chats?.length ?? 0) + 1).toString(),
                            createdAt: DateTime.now(),
                            createdBy: TicketParty.user.name,
                            text: _textEditingController.text,
                          );
                          ticket?.chats?.add(textModel);
                          await DBService.instance
                              .updateTicket(ticket!)
                              .then((value) {
                            _textEditingController.text = '';
                            getTicketDetail();
                            _scrollDown();
                          });
                        }
                      },
                      child: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
