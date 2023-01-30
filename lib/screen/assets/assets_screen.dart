import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_screen.dart';
import 'package:iamsmart/screen/depositToUserWallet/deposit_to_user_wallet_screen.dart';
import 'package:iamsmart/screen/transferToAIWallet/transafer_to_ai_wallet_screen.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:iamsmart/widget/heading.dart';

import '../../service/snakbar_service.dart';
import '../transaction/transaction_detail_screen.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({
    Key? key,
    required this.switchTab,
  }) : super(key: key);
  final Function(int index) switchTab;

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
        title: const Heading(title: 'Assets'),
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
                'TRANSACTIONS',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: textColorLight,
                    ),
              ),
              TextButton(
                onPressed: () {
                  widget.switchTab(1);
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
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(
                        index % 2 == 0
                            ? FontAwesomeIcons.arrowRightFromBracket
                            : index % 3 == 0
                                ? FontAwesomeIcons.arrowRightToBracket
                                : FontAwesomeIcons.arrowsLeftRight,
                        size: 18,
                        color: bottomNavbarActiveColor,
                      ),
                    ),
                    title: Text(
                      index % 2 == 0
                          ? 'Deposit to User wallet'
                          : index % 3 == 0
                              ? 'Transfered to User Wallet'
                              : 'Transfered to AI wallet',
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index % 2 == 0
                              ? 'Rejected'
                              : index % 3 == 0
                                  ? 'Approved'
                                  : 'Pending',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: index % 2 == 0
                                        ? Colors.red.withOpacity(0.7)
                                        : index % 3 == 0
                                            ? Colors.green.withOpacity(0.7)
                                            : Colors.orange.withOpacity(0.7),
                                  ),
                        ),
                        Text(
                          '${index + 1} days ago',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Hero(
                      tag: '$index',
                      child: Text(
                        '$rupeeSymbol ${currencyFormatter.format(10000 * (index + 1))}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    onTap: () => context.push(
                      TransactionDetailScreen.transactionDetailScreenRoute
                          .replaceFirst(':txnId', '${index}'),
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(
                    color: dividerColor,
                    height: 1,
                  ),
              itemCount: 5),
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
                        widget.switchTab(1);
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
                    onPressed: () {
                      context.push(
                          DepositeToUserWalletScreen.depositeToUserWalletRoute);
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
                    onPressed: () {
                      context.push(
                          TransferToAIWalletScreen.transferToAIWalletRoute);
                    },
                    tooltip: 'Invest',
                    icon: const Icon(
                      FontAwesomeIcons.moneyBillTransfer,
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
                        widget.switchTab(1);
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
                    onPressed: () {
                      context.push(
                          TransferToAIWalletScreen.transferToAIWalletRoute);
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
                    onPressed: () {
                      context.push(AiSetScreen.aiSetRoute);
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
