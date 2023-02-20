// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_screen.dart';
import 'package:iamsmart/screen/depositToUserWallet/deposit_to_user_wallet_screen.dart';
import 'package:iamsmart/screen/faq/faq_screen.dart';
import 'package:iamsmart/screen/ticket/ticket_screen.dart';
import 'package:iamsmart/screen/transferToAIWallet/transafer_to_ai_wallet_screen.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/email_generator.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/heading.dart';
import 'package:iamsmart/withdraw_from_user_wallet/withdraw_from_user_wallet_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../model/transaction_model.dart';
import '../../service/snakbar_service.dart';
import '../../util/utilities.dart';
import '../transaction/transaction_detail_screen.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({
    Key? key,
    required this.switchTab,
  }) : super(key: key);
  final Function(int index, int txnIndex) switchTab;

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  List<TransactionModel> txnList = [];

  loadUserProfile() async {
    userProfile = await DBService.instance.getUserById(userProfile.id!);
    prefs.setString(PreferenceKey.user, userProfile.toJson());

    await DBService.instance
        .getCurrentDateTransactions(userProfile.id!)
        .then((value) {
      setState(() {
        txnList = value;
      });
    });
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUserProfile(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => widget.switchTab(3, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(homePageUserIconSize),
                child: CachedNetworkImage(
                  imageUrl: userProfile.profileImage ?? '',
                  width: homePageUserIconSize,
                  height: homePageUserIconSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/image/user.png',
                    width: homePageUserIconSize,
                    height: homePageUserIconSize,
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hello ${userProfile.name?.split(' ')[0]}!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // Text(
                  //   '${userProfile.email}',
                  //   style: Theme.of(context).textTheme.caption,
                  // ),
                ],
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(TicketScreen.ticketScreenRoute);
            },
            icon: const Icon(
              Icons.support_agent_outlined,
              color: bottomNavbarActiveColor,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              context.push(FaqScreen.faqRoute);
            },
            icon: const Icon(
              FontAwesomeIcons.circleQuestion,
              color: bottomNavbarActiveColor,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () async {
              loadUserProfile();
              SnackBarService.instance.showSnackBarInfo('Refreshing...');
            },
            icon: const Icon(
              FontAwesomeIcons.arrowsRotate,
              color: bottomNavbarActiveColor,
              size: 20,
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Column(
      children: [
        const SizedBox(
          height: defaultPadding,
        ),
        CarouselSlider(
          items: [
            getUserWallet(),
            getAIWallet(),
          ],
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Transactions',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: textColorLight,
                    ),
              ),
              TextButton(
                onPressed: () {
                  widget.switchTab(1, 3);
                },
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: bottomNavbarActiveColor,
                      ),
                ),
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

  Container getUserWallet() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: userWalletRearColor,
        borderRadius: BorderRadius.circular(defaultPadding * 1.5),
      ),
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultPadding * 1.5),
                gradient: const LinearGradient(
                  colors: [
                    userWalletColorDark,
                    userWalletColorLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    child: Text(
                      '$rupeeSymbol ${currencyFormatter.format(userProfile.userWalletBalance)}',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 1,
                    child: Text(
                      'Wallet ID : ${userProfile.id!.substring(0, 10)}/UW',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: IconButton(
                      onPressed: () {
                        widget.switchTab(1, 0);
                        loadUserProfile();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.eye,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: double.infinity,
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'USER WALLET',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      if (await Utilities.checkForKycPrompt(context)) {
                        // context.push(DepositeToUserWalletScreen
                        //     .depositeToUserWalletRoute);
                        // ignore: use_build_context_synchronously
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DepositeToUserWalletScreen(),
                          ),
                        ).then((value) => loadUserProfile());
                      }
                    },
                    tooltip: 'Add to wallet',
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (await Utilities.checkForKycPrompt(context)) {
                        // Future.sync(() => context.push(TransferToAIWalletScreen
                        //         .transferToAIWalletRoute))
                        //     .then((value) => loadUserProfile());
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TransferToAIWalletScreen()),
                        ).then((value) => loadUserProfile());
                      }
                    },
                    tooltip: 'Invest',
                    icon: const Icon(
                      FontAwesomeIcons.moneyBillTransfer,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (await Utilities.checkForKycPrompt(context)) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WithdrawFromUserWalletScreen()),
                        ).then((value) => loadUserProfile());
                      }
                    },
                    tooltip: 'Withdraw',
                    icon: const Icon(
                      FontAwesomeIcons.handHoldingDollar,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container getAIWallet() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: userWalletRearColor,
        borderRadius: BorderRadius.circular(defaultPadding * 1.5),
      ),
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultPadding * 1.5),
                gradient: const LinearGradient(
                  colors: [
                    aiWalletColorDark,
                    aiWalletColorLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    child: Text(
                      '$rupeeSymbol ${currencyFormatter.format(userProfile.aiWalletBalance)}',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 1,
                    child: Text(
                      'Wallet ID : ${userProfile.id!.substring(0, 10)}/AIW',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: IconButton(
                      onPressed: () {
                        widget.switchTab(1, 1);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.eye,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: double.infinity,
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'AI WALLET',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      if (await Utilities.checkForKycPrompt(context)) {
                        // context.push(
                        //     TransferToAIWalletScreen.transferToAIWalletRoute);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TransferToAIWalletScreen()),
                        ).then((value) => loadUserProfile());
                      }
                    },
                    tooltip: 'Add to wallet',
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (await Utilities.checkForKycPrompt(context)) {
                        // context.push(AiSetScreen.aiSetRoute);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AiSetScreen()),
                        ).then((value) => loadUserProfile());
                      }
                    },
                    tooltip: 'Redeem',
                    icon: const Icon(
                      FontAwesomeIcons.moneyBillTrendUp,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
