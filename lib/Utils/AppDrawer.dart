import 'package:connect/Screens/DashBoardScreen/DashBoardScreen.dart';
import 'package:connect/Screens/DpProcessScreen/DpProcessScreen.dart';
import 'package:connect/Screens/IPOScreen/IPOScreen.dart';
import 'package:connect/Screens/MyAccountScreen/MyAccountScreen.dart';
import 'package:connect/SettingsScreen/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  PersistentTabController? controller;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  List<PersistentTabConfig> _navBarsItems() {
    return [
      PersistentTabConfig(
        item: ItemConfig(
          icon: tab == 0 ? SvgPicture.asset("assets/icons/HomeIcon.svg") : SvgPicture.asset("assets/icons/DeSelectedHomeicon.svg"),
          title: ("DashBoard"),
        ), screen: const DashBoardScreen(),
      ),
      PersistentTabConfig(
        item: ItemConfig(
          icon: tab == 1 ? SvgPicture.asset("assets/icons/IpoIcon.svg") : SvgPicture.asset("assets/icons/DeSelectedIPOIcon.svg"),
          title: ("IPO"),
        ), screen: const IPOScreen(),
      ),
      PersistentTabConfig(
        item: ItemConfig(
          icon: tab == 2 ? SvgPicture.asset("assets/icons/AccountIcon.svg") : SvgPicture.asset("assets/icons/DeSelectedAccountIcon.svg"),
          title: ("Account"),
        ), screen: const Myaccountscreen(),
      ),
      PersistentTabConfig(
        item: ItemConfig(
          icon: tab == 3 ? SvgPicture.asset("assets/icons/SettingIcon.svg",height: 22,width: 22,) : SvgPicture.asset("assets/icons/DeSelectSettingIcon.svg"),
          title: ("Settings"),
        ), screen: const SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      popAllScreensOnTapAnyTabs: true,
      tabs: _navBarsItems(),
      onTabChanged: (value) {
        setState(() {
          tab = value;
        });
      },
      navBarBuilder: (navBarConfig) => Style6BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}