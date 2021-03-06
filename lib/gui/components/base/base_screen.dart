import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviehub/gui/components/app_bar/main_app_bar.dart';
import 'package:moviehub/gui/components/dialogs/login_dialog.dart';
import 'package:moviehub/gui/components/drawer/account/auth_button.dart';
import 'package:moviehub/gui/components/drawer/list_item.dart';
import 'package:moviehub/gui/screens/created_lists/list_screen.dart';
import 'package:moviehub/gui/screens/discover/discover_screen.dart';
import 'package:moviehub/gui/screens/no_wifi/no_wifi_screen.dart';
import 'package:moviehub/gui/screens/search/search_screen.dart';
import 'package:moviehub/gui/screens/statistics/statistics_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BaseScreen extends StatefulWidget {
  Widget child;
  Widget accountTab;
  Widget loginButton;

  BaseScreen({this.child, this.changeTheme, this.accountTab, this.loginButton});

  VoidCallback changeTheme;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateWifi();
  }

  void updateWifi() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      if (result == ConnectivityResult.none) widget.child = NoWifiScreen();
      else widget.child = DiscoverScreen();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      updateWifi();
    });
  }

  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  void changeScreen(ListItemContent content, BuildContext context) {
    if (content == ListItemContent.NIGHT_MODE) return;
    Navigator.pop(context);
    setState(() {
      if (content == ListItemContent.DISCOVER) widget.child = DiscoverScreen();
      if (content == ListItemContent.SEARCH) widget.child = SearchScreen();
      if (content == ListItemContent.LIST) widget.child = ListScreen();
      if (content == ListItemContent.STATISTICS)
        widget.child = StatisticsScreen();
    });
  }

  void login() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          LoginDialog(updateLogin: () => this.updateScreen()),
    );
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("account", null);
    updateScreen();
  }

  void updateScreen() {
    changeScreen(ListItemContent.DISCOVER, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _drawerKey,
      drawer: SafeArea(
        child: Container(
          width: 300,
          child: Drawer(
            child: Column(
              children: <Widget>[
                widget.accountTab,
                ListItem(
                  content: ListItemContent.DISCOVER,
                  onTap: () => changeScreen(ListItemContent.DISCOVER, context),
                  title: "",
                ),
                ListItem(
                  content: ListItemContent.SEARCH,
                  onTap: () => changeScreen(ListItemContent.SEARCH, context),
                  title: "",
                ),
                ListItem(
                  onTap: () => changeScreen(ListItemContent.LIST, context),
                  content: ListItemContent.LIST,
                  title: "",
                ),
                ListItem(
                  content: ListItemContent.STATISTICS,
                  onTap: () =>
                      changeScreen(ListItemContent.STATISTICS, context),
                  title: "",
                ),
                ListItem(
                  onTap: () => widget.changeTheme(),
                  content: ListItemContent.NIGHT_MODE,
                  title: "",
                ),
                AuthButton(
                    login: () => login(),
                    logout: () => logout(),
                    onChange: () {
                      updateScreen();
                    })
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: MainAppBar(openDrawer: () => openDrawer()),
          body: Container(
            margin: EdgeInsets.only(left: 14, right: 14, top: 35),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
