import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/set_model.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_details.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/util/utilities.dart';

import '../../main.dart';
import '../../model/user_profile.dart';
import '../../util/colors.dart';
import '../../util/preference_key.dart';
import '../../widget/heading.dart';

class AiSetScreen extends StatefulWidget {
  const AiSetScreen({super.key});
  static const String aiSetRoute = '/mainContainer/assets/aiSet';

  @override
  State<AiSetScreen> createState() => _AiSetScreenState();
}

class _AiSetScreenState extends State<AiSetScreen> {
  List<SetModel> setList = [];
  List<SetModel> runningList = [];
  List<SetModel> completeList = [];
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  @override
  void initState() {
    super.initState();
    getAllSet();
  }

  getAllSet() async {
    setList = await DBService.instance.getAllSet(userProfile.id!);
    runningList =
        setList.where((set) => set.status != SetStatus.complete.name).toList();
    completeList =
        setList.where((set) => set.status == SetStatus.complete.name).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Heading(title: 'AI Sets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Running'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            running(),
            completed(),
          ],
        ),
      ),
    );
  }

  completed() {
    return ListView.builder(
      itemCount: completeList.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => context.push(
          AiSetDetailScreen.aiSetDetailScreenRoute
              .replaceAll(':txnId', completeList[index].id!),
        ),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Set #${completeList[index].setNumber}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColorDark,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 10,
                    ),
                  ],
                ),
                detailItem('Invested Amount',
                    '$rupeeSymbol ${currencyFormatter.format(completeList[index].amount)}'),
                detailItem('Income',
                    '$rupeeSymbol ${currencyFormatter.format(completeList[index].income)}'),
                // detailItem('Total',
                //     '$rupeeSymbol ${currencyFormatter.format((1000 * (index + 1)) + (0.5 * 1000 * (index + 1)))}'),
                detailItem(
                  'Status',
                  completeList[index].status!,
                  valueColor: getStatusColor(completeList[index].status!),
                ),
                detailItem('Investment Time',
                    Utilities.formatDate(completeList[index].createdAt!)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  running() {
    return ListView.builder(
      itemCount: runningList.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => context.push(
          AiSetDetailScreen.aiSetDetailScreenRoute
              .replaceAll(':txnId', runningList[index].id!),
        ),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Set #${runningList[index].setNumber}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColorDark,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 10,
                    ),
                  ],
                ),
                detailItem('Invested Amount',
                    '$rupeeSymbol ${currencyFormatter.format(runningList[index].amount)}'),
                detailItem('Income',
                    '$rupeeSymbol ${currencyFormatter.format(runningList[index].income)}'),
                // detailItem('Total',
                //     '$rupeeSymbol ${currencyFormatter.format((1000 * (index + 1)) + (0.5 * 1000 * (index + 1)))}'),
                detailItem('Status', '${runningList[index].status}',
                    valueColor: getStatusColor(runningList[index].status!)),
                detailItem('Investment Time',
                    Utilities.formatDate(runningList[index].createdAt!)),
              ],
            ),
          ),
        ),
      ),
    );
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
