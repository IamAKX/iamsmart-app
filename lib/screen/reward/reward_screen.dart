import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/coming_soon.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../main.dart';
import '../../model/transaction_model.dart';
import '../../model/user_profile.dart';
import '../../service/db_service.dart';
import '../../util/preference_key.dart';
import '../../util/utilities.dart';
import '../../widget/heading.dart';
import '../transaction/transaction_detail_screen.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({
    Key? key,
    required this.switchTab,
  }) : super(key: key);
  final Function(int index, int txnIndex) switchTab;

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  List<TransactionModel> txnList = [];
  DateTime now = DateTime.now();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(now.year, now.month, now.day);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUserProfile(),
    );
  }

  loadUserProfile() async {
    userProfile = await DBService.instance.getUserById(userProfile.id!);
    prefs.setString(PreferenceKey.user, userProfile.toJson());
    await loadRewarTransactions(selectedDate);
  }

  loadRewarTransactions(DateTime date) async {
    await DBService.instance
        .getCurrentDateRewardTransactions(
            userProfile.id!,
            date.millisecondsSinceEpoch,
            date.add(const Duration(days: 1)).millisecondsSinceEpoch)
        .then((value) {
      setState(() {
        txnList = value;
        print('txnList = ${txnList.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.switchTab(0, 0);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Heading(title: 'Reward'),
          actions: [
            IconButton(
              onPressed: () async {
                await FlutterShare.share(
                  title: 'Invitation to join IamSMART',
                  text:
                      'You are invited by ${userProfile.name} to join IamSMART. Please use the referral code ${userProfile.inviteCode} while registering.',
                  linkUrl:
                      'https://play.google.com/store/apps/details?id=com.visutechnologies.iamsmart',
                  chooserTitle: 'Share invite code',
                );
              },
              icon: const Icon(
                Icons.share_outlined,
                color: bottomNavbarActiveColor,
                size: 20,
              ),
            ),
          ],
        ),
        body: getBody(),
      ),
    );
  }

  getBody() {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          color: rewardCardColor,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total rewards earned',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                Text(
                  '$rupeeSymbol ${currencyFormatter.format(userProfile.rewardBalance)}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'Total referrals',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                Text(
                  '${userProfile.referalList?.length}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'Total rewards earned today',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
                Text(
                  '$rupeeSymbol ${currencyFormatter.format(txnList.fold(0.0, (sum, element) => sum + element.amount!))}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(
                      const Duration(days: 1),
                    );
                    loadRewarTransactions(selectedDate);
                  });
                },
                icon: const Icon(Icons.arrow_left),
              ),
              Text(
                Utilities.formatDateShort(
                  selectedDate,
                ),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: textColorDark, fontWeight: FontWeight.w100),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.add(
                      const Duration(days: 1),
                    );
                    loadRewarTransactions(selectedDate);
                  });
                },
                icon: const Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
        Expanded(
          child: txnList.isEmpty
              ? Center(
                  child: Text(
                    'No Transaction',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.15),
                          child: Icon(
                            Utilities.getIconForTransaction(
                                txnList.elementAt(index)),
                            size: 18,
                            color: bottomNavbarActiveColor,
                          ),
                        ),
                        title: Text(
                          txnList
                                  .elementAt(index)
                                  .transactionActivity
                                  ?.first
                                  .comment ??
                              'Transaction',
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txnList.elementAt(index).status ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: getStatusColor(
                                        txnList.elementAt(index).status ?? ''),
                                  ),
                            ),
                            Text(
                              timeago
                                  .format(txnList.elementAt(index).createdAt!),
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Hero(
                          tag: txnList.elementAt(index).id!,
                          child: Text(
                            '$rupeeSymbol ${currencyFormatter.format(txnList.elementAt(index).amount)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        onTap: () => context.push(
                          TransactionDetailScreen.transactionDetailScreenRoute
                              .replaceFirst(
                                  ':txnId', txnList.elementAt(index).id!),
                        ),
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        color: dividerColor,
                        height: 1,
                      ),
                  itemCount: txnList.length),
        ),
      ],
    );
  }
}
