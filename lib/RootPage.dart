import 'package:flutter/cupertino.dart';
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
   int _userId;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.id;
        }
        authStatus =
        user?.id == 0 ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return StartPage(title: 'Домашняя бухгалтерия');
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback);
        break;
      case AuthStatus.LOGGED_IN:
        StartPage(title: 'Домашняя бухгалтерия');
        // if (_userId.length > 0 && _userId != null) {
        //   return new HomePage(
        //     userId: _userId,
        //     auth: widget.auth,
        //     logoutCallback: logoutCallback,
        //   );
        // } else
          return StartPage(title: 'Домашняя бухгалтерия');
        break;
      default:
        return StartPage(title: 'Домашняя бухгалтерия');
    }
  }
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.id;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = 0;
    });
  }
}