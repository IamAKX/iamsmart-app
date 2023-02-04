import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/screen/assets/assets_screen.dart';
import 'package:iamsmart/screen/explore/explore_screen.dart';
import 'package:iamsmart/screen/reward/reward_screen.dart';
import 'package:iamsmart/screen/setting/setting_screen.dart';
import 'package:iamsmart/screen/transaction/transaction_screen.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/theme.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});
  static const String mainContainerRoute = '/mainContainer';

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedTab = 0;
  int _transactionTab = 0;

  List<FlashyTabBarItem> items = [
    FlashyTabBarItem(
        icon: const Icon(FontAwesomeIcons.coins),
        title: const Text('Assets'),
        activeColor: bottomNavbarActiveColor,
        inactiveColor: bottomNavbarInactiveColor),
    FlashyTabBarItem(
        icon: const Icon(FontAwesomeIcons.arrowsUpDown),
        title: const Text('Record'),
        activeColor: bottomNavbarActiveColor,
        inactiveColor: bottomNavbarInactiveColor),
    FlashyTabBarItem(
        icon: const Icon(FontAwesomeIcons.star),
        title: const Text('Reward'),
        activeColor: bottomNavbarActiveColor,
        inactiveColor: bottomNavbarInactiveColor),
    FlashyTabBarItem(
        icon: const Icon(FontAwesomeIcons.user),
        title: const Text('Profile'),
        activeColor: bottomNavbarActiveColor,
        inactiveColor: bottomNavbarInactiveColor),
  ];

  loadScreen() {
    switch (_selectedTab) {
      case 0:
        return AssetsScreen(
          switchTab: (index, txnIndex) {
            switchTab(index, txnIndex);
          },
        );
      case 1:
        return TransactionScreen(
          txnIndex: _transactionTab,
          switchTab: (index, txnIndex) {
            switchTab(index, txnIndex);
          },
        );
      case 2:
        return RewardScreen(
          switchTab: (index, txnIndex) {
            switchTab(index, txnIndex);
          },
        );
      case 3:
        return SettingScreen(
          switchTab: (index, txnIndex) {
            switchTab(index, txnIndex);
          },
        );
    }
  }

  switchTab(int index, int txnIndex) {
    setState(() {
      _selectedTab = index;
      _transactionTab = txnIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadScreen(),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(defaultPadding / 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                bottomNavigationBarBorderRadius,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                bottomNavigationBarBorderRadius,
              ),
            ),
            child: FlashyTabBar(
              selectedIndex: _selectedTab,
              showElevation: true,
              onItemSelected: (value) => switchTab(value, 0),
              items: items,
            ),
          ),
        ),
      ),
    );
  }
}
