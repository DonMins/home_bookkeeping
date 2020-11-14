import 'package:flutter/cupertino.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'package:home_bookkeeping/login.dart';

import 'BaseAuth.dart';
import 'StartPage.dart';

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN, }

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
   UsersDb currUser;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currUser = user;
        }
        authStatus = user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback);
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback);
        break;
      case AuthStatus.LOGGED_IN:
        return new StartPage(title: 'Домашняя бухгалтерия',user: currUser);
        break;
    }
  }
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        currUser = user;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      currUser = new UsersDb(-1,"","");
    });
  }
}