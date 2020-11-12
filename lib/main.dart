import 'package:flutter/material.dart';

import 'BaseAuth.dart';
import 'RootPage.dart';
import 'StartPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: StartPage(title: 'Домашняя бухгалтерия'),
      home: new RootPage(auth: new Auth()),
    );
  }
}
