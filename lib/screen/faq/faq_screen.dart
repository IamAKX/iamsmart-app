import 'package:flutter/material.dart';
import 'package:iamsmart/model/faq_model.dart';
import 'package:iamsmart/service/db_service.dart';

import '../../util/theme.dart';
import '../../widget/heading.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  static const String faqRoute = '/mainContainer/faq';

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqModel> faqList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadFaq(),
    );
  }

  loadFaq() async {
    faqList.clear();
    await DBService.instance.getAllFaqs().then((value) {
      faqList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'FAQ'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(faqList[index].question ?? ''),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Text(
                faqList[index].answer ?? '',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      },
      itemCount: faqList.length,
    );
  }
}
